#!/usr/bin/env bash
# One-time VPS provisioning for the Kaza backend: Postgres db/user, schema +
# seed data, backend/.env, the MinIO + API containers, and (optionally)
# nginx/certbot for HTTPS.
#
# Safe to re-run — every phase checks current state before changing
# anything, and never overwrites an existing backend/.env or an existing
# Postgres user's password.
#
# This is one-time setup. Day-to-day redeploys after that happen on their
# own via deploy.sh, triggered by the deploy-backend GitHub Actions
# workflow on every push to backend/**.
#
# Usage (run on the VPS, as a user with sudo rights):
#   cp deploy/setup.conf.example deploy/setup.conf
#   nano deploy/setup.conf              # fill in DB_PASSWORD, CLAUDE_API_KEY, etc.
#   bash deploy/setup.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONF_FILE="$SCRIPT_DIR/setup.conf"
REPO_URL="https://github.com/WisdomBusara/unfat.git"

log() { echo "==> $1"; }
warn() { echo "WARNING: $1" >&2; }
confirm() {
  [ "$AUTO_CONFIRM" = "true" ] && return 0
  read -r -p "$1 [y/N] " reply
  [[ "$reply" =~ ^[Yy]$ ]]
}

if [ ! -f "$CONF_FILE" ]; then
  echo "ERROR: $CONF_FILE not found. Copy deploy/setup.conf.example to deploy/setup.conf and fill it in first." >&2
  exit 1
fi
# shellcheck source=/dev/null
source "$CONF_FILE"

: "${DEPLOY_PATH:?DEPLOY_PATH must be set in setup.conf}"
: "${DB_PASSWORD:?DB_PASSWORD must be set in setup.conf}"
: "${CLAUDE_API_KEY:?CLAUDE_API_KEY must be set in setup.conf}"
SETUP_NGINX="${SETUP_NGINX:-false}"
AUTO_CONFIRM="${AUTO_CONFIRM:-false}"

# ---------------------------------------------------------------------------
log "Checking prerequisites..."
for cmd in git docker psql curl openssl; do
  command -v "$cmd" >/dev/null 2>&1 || { echo "ERROR: '$cmd' is required but not installed." >&2; exit 1; }
done
docker compose version >/dev/null 2>&1 || { echo "ERROR: 'docker compose' plugin not found." >&2; exit 1; }
docker info >/dev/null 2>&1 || { echo "ERROR: current user can't run docker (not in the 'docker' group?). Run: sudo usermod -aG docker \$USER, then log out and back in." >&2; exit 1; }

# ---------------------------------------------------------------------------
log "Postgres: creating database/user if missing..."
DB_EXISTS=$(sudo -u postgres psql -tAc "SELECT 1 FROM pg_database WHERE datname='kaza'")
if [ "$DB_EXISTS" != "1" ]; then
  sudo -u postgres psql -c "CREATE DATABASE kaza;" >/dev/null
  log "Created database 'kaza'."
else
  log "Database 'kaza' already exists, skipping."
fi

USER_EXISTS=$(sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='kaza'")
if [ "$USER_EXISTS" != "1" ]; then
  sudo -u postgres psql -c "CREATE USER kaza WITH ENCRYPTED PASSWORD '${DB_PASSWORD}';" >/dev/null
  log "Created user 'kaza'."
else
  log "User 'kaza' already exists — leaving its password untouched. If it doesn't match DB_PASSWORD in setup.conf, the API won't be able to connect; fix with ALTER USER and update backend/.env to match."
fi
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE kaza TO kaza;" >/dev/null

# ---------------------------------------------------------------------------
log "Postgres: checking it accepts connections from Docker containers..."
HBA_FILE=$(sudo -u postgres psql -tAc "SHOW hba_file" | xargs)
PG_CONF_FILE=$(sudo -u postgres psql -tAc "SHOW config_file" | xargs)
DOCKER_RULE="host    kaza    kaza    172.17.0.0/16    scram-sha-256"

if sudo grep -qF "$DOCKER_RULE" "$HBA_FILE" 2>/dev/null; then
  log "pg_hba.conf already allows the Docker bridge network, skipping."
else
  if confirm "About to append a rule to $HBA_FILE allowing 172.17.0.0/16 to reach the 'kaza' db, set listen_addresses='*' in $PG_CONF_FILE, and restart postgresql. Continue?"; then
    sudo cp "$HBA_FILE" "${HBA_FILE}.kaza-setup.bak"
    echo "$DOCKER_RULE" | sudo tee -a "$HBA_FILE" >/dev/null
    if sudo grep -q "^#*listen_addresses" "$PG_CONF_FILE"; then
      sudo sed -i "s/^#*listen_addresses.*/listen_addresses = '*'/" "$PG_CONF_FILE"
    else
      echo "listen_addresses = '*'" | sudo tee -a "$PG_CONF_FILE" >/dev/null
    fi
    sudo systemctl restart postgresql
    log "pg_hba.conf updated (backup at ${HBA_FILE}.kaza-setup.bak) and postgresql restarted."
  else
    warn "Skipped — the API container will not be able to reach Postgres until this is done manually (see backend/README.md step 1)."
  fi
fi

# ---------------------------------------------------------------------------
log "Cloning/updating the repo at $DEPLOY_PATH..."
if [ -d "$DEPLOY_PATH/.git" ]; then
  (cd "$DEPLOY_PATH" && git fetch origin main && git reset --hard origin/main)
  log "Repo already present, updated to latest main."
else
  git clone "$REPO_URL" "$DEPLOY_PATH"
fi
BACKEND_DIR="$DEPLOY_PATH/backend"

# ---------------------------------------------------------------------------
log "Writing backend/.env..."
ENV_FILE="$BACKEND_DIR/.env"
VPS_IP=$(curl -s https://ifconfig.me || echo "127.0.0.1")

if [ -f "$ENV_FILE" ]; then
  log "$ENV_FILE already exists, leaving it untouched."
else
  MINIO_ACCESS_KEY="${MINIO_ACCESS_KEY:-$(openssl rand -hex 12)}"
  MINIO_SECRET_KEY="${MINIO_SECRET_KEY:-$(openssl rand -base64 32)}"
  JWT_ACCESS_SECRET="${JWT_ACCESS_SECRET:-$(openssl rand -base64 48)}"
  JWT_REFRESH_SECRET="${JWT_REFRESH_SECRET:-$(openssl rand -base64 48)}"

  cat > "$ENV_FILE" <<ENVEOF
DB_HOST=host.docker.internal
DB_PORT=5432
DB_NAME=kaza
DB_USER=kaza
DB_PASSWORD=${DB_PASSWORD}

JWT_ACCESS_SECRET=${JWT_ACCESS_SECRET}
JWT_REFRESH_SECRET=${JWT_REFRESH_SECRET}
ACCESS_TOKEN_TTL_MINUTES=15
REFRESH_TOKEN_TTL_DAYS=30

MINIO_ENDPOINT=minio
MINIO_PORT=9000
MINIO_ACCESS_KEY=${MINIO_ACCESS_KEY}
MINIO_SECRET_KEY=${MINIO_SECRET_KEY}
MINIO_BUCKET=kaza-photos
MINIO_USE_SSL=false
MINIO_PUBLIC_URL=http://${VPS_IP}:9000

CLAUDE_API_KEY=${CLAUDE_API_KEY}
ENVEOF
  chmod 600 "$ENV_FILE"
  log "Wrote $ENV_FILE (MinIO/JWT secrets auto-generated where left blank in setup.conf)."
fi

# ---------------------------------------------------------------------------
log "Loading schema and seed data (idempotent, safe to re-run)..."
PGPASSWORD="$DB_PASSWORD" psql -U kaza -d kaza -h localhost -f "$BACKEND_DIR/schema.sql"
PGPASSWORD="$DB_PASSWORD" psql -U kaza -d kaza -h localhost -f "$BACKEND_DIR/seeds/exercises.sql"
PGPASSWORD="$DB_PASSWORD" psql -U kaza -d kaza -h localhost -f "$BACKEND_DIR/seeds/foods.sql"

# ---------------------------------------------------------------------------
log "Building and starting containers..."
(cd "$BACKEND_DIR" && docker compose up -d --build)

log "Waiting for the API to come up..."
up=false
for i in $(seq 1 10); do
  if curl -sf http://127.0.0.1:8080/ >/dev/null; then
    log "API is responding on :8080."
    up=true
    break
  fi
  sleep 5
done
[ "$up" = "true" ] || warn "API did not respond after 50s. Check: docker compose -f $BACKEND_DIR/docker-compose.yml logs api"

# ---------------------------------------------------------------------------
if [ "$SETUP_NGINX" = "true" ]; then
  log "Setting up nginx + HTTPS..."
  : "${CERTBOT_EMAIL:?CERTBOT_EMAIL must be set in setup.conf when SETUP_NGINX=true}"

  dns_ok=true
  if command -v dig >/dev/null 2>&1; then
    API_IP=$(dig +short "$DOMAIN_API" | tail -1)
    STORAGE_IP=$(dig +short "$DOMAIN_STORAGE" | tail -1)
    if [ "$API_IP" != "$VPS_IP" ] || [ "$STORAGE_IP" != "$VPS_IP" ]; then
      dns_ok=false
      warn "$DOMAIN_API -> '$API_IP' and/or $DOMAIN_STORAGE -> '$STORAGE_IP' don't match this VPS's IP ($VPS_IP)."
      warn "Add/fix the DNS records in Cloudflare (DNS-only, not proxied), let them propagate, then re-run setup.sh."
    fi
  else
    warn "'dig' not installed, skipping DNS pre-check — certbot will fail with its own message if the records aren't ready yet."
  fi

  if [ "$dns_ok" = "true" ]; then
    command -v nginx >/dev/null 2>&1 || sudo apt-get update && sudo apt-get install -y nginx
    command -v certbot >/dev/null 2>&1 || sudo apt-get install -y certbot python3-certbot-nginx

    sudo cp "$BACKEND_DIR/deploy/nginx-api.conf" /etc/nginx/sites-available/
    sudo cp "$BACKEND_DIR/deploy/nginx-storage.conf" /etc/nginx/sites-available/
    sudo ln -sf /etc/nginx/sites-available/nginx-api.conf /etc/nginx/sites-enabled/
    sudo ln -sf /etc/nginx/sites-available/nginx-storage.conf /etc/nginx/sites-enabled/
    sudo nginx -t && sudo systemctl reload nginx

    sudo certbot --nginx -d "$DOMAIN_API" -d "$DOMAIN_STORAGE" \
      --non-interactive --agree-tos -m "$CERTBOT_EMAIL" --redirect

    sed -i "s#^MINIO_PUBLIC_URL=.*#MINIO_PUBLIC_URL=https://${DOMAIN_STORAGE}#" "$ENV_FILE"
    (cd "$BACKEND_DIR" && docker compose restart api)
    log "HTTPS is live at https://$DOMAIN_API and https://$DOMAIN_STORAGE."
  fi
else
  log "SETUP_NGINX is false, skipping nginx/certbot. Backend is reachable at http://${VPS_IP}:8080 for now."
fi

# ---------------------------------------------------------------------------
log "Done. GitHub Actions secrets for auto-deploy (repo Settings > Secrets and variables > Actions):"
echo "  VPS_HOST       = ${VPS_IP}"
echo "  VPS_USER       = $(whoami)"
echo "  VPS_SSH_KEY    = <private half of the SSH key you use to log into this VPS, copied from your laptop, not this server>"
echo "  KAZA_REPO_PATH = ${DEPLOY_PATH}"
