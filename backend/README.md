# Kaza API

Self-hosted backend for the Kaza app: Dart Frog + Postgres + MinIO, running on your own VPS. No Firebase involved — the Flutter app talks only to this API.

## Why this exists

The Flutter client never talks to Postgres or MinIO directly (no mobile app should hold DB credentials). This API sits in between: it owns auth (JWT), owns the database, owns object storage, and proxies Claude API calls so the Anthropic key never ships inside the app.

## 1. Postgres setup

You said Postgres is already running on your VPS — just add a database and user for this app:

```bash
sudo -u postgres psql
```
```sql
CREATE DATABASE kaza;
CREATE USER kaza WITH ENCRYPTED PASSWORD 'pick_a_strong_password';
GRANT ALL PRIVILEGES ON DATABASE kaza TO kaza;
\q
```

Then load the schema, then the exercise/food catalog seed data:

```bash
psql -U kaza -d kaza -h localhost -f schema.sql
psql -U kaza -d kaza -h localhost -f seeds/exercises.sql
psql -U kaza -d kaza -h localhost -f seeds/foods.sql
```

Both seed files are idempotent (`ON CONFLICT` on the name) — safe to rerun after adding more rows to them later. They deliberately aren't run automatically by `deploy.sh`, same reasoning as `schema.sql`: anything touching the database stays a manual, reviewed step.

## 2. MinIO setup

If you don't already run MinIO, the included `docker-compose.yml` starts it:

```bash
cp .env.example .env
# edit .env: set MINIO_ACCESS_KEY / MINIO_SECRET_KEY to real values
docker compose up -d minio
```

Console is at `http://your-vps-ip:9001` — log in with the keys you set, and the API will auto-create the `kaza-photos` bucket on first upload.

## 3. Configure environment

Fill in the rest of `.env` (copy from `.env.example`):

- `DB_*` — point at the Postgres database/user from step 1
- `JWT_ACCESS_SECRET` / `JWT_REFRESH_SECRET` — generate two **different** random strings: `openssl rand -base64 48`
- `MINIO_*` — from step 2
- `CLAUDE_API_KEY` — from console.anthropic.com. This never goes in the Flutter app.

## 4. Run

**Local dev:**
```bash
dart pub get
dart pub global activate dart_frog_cli
dart_frog dev
```
Serves on `http://localhost:8080`.

**Production (Docker):**
```bash
docker compose up -d --build
```

**Production (systemd, no Docker):**
```bash
dart pub global run dart_frog_cli:dart_frog build
cd build && dart pub get
dart compile exe bin/server.dart -o /opt/kaza-api/server
```
Then a systemd unit running `/opt/kaza-api/server` with the `.env` values as `Environment=` lines (or use `EnvironmentFile=`).

## 5. Expose it over HTTPS

You'll need one more DNS record beyond `kaza.wisdombusara.com` (the app's landing page):

| Subdomain | Points to | Purpose |
|---|---|---|
| `api.wisdombusara.com` | this backend | Flutter app's API calls |
| `storage.wisdombusara.com` | MinIO | Serves progress photo URLs over HTTPS (optional but recommended over a bare IP) |

Nginx configs for both are in `deploy/`. After adding the Cloudflare DNS records (CNAME or A, **DNS only** — not proxied, so Let's Encrypt/certbot can verify), run:

```bash
sudo cp deploy/nginx-api.conf /etc/nginx/sites-available/
sudo cp deploy/nginx-storage.conf /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/nginx-api.conf /etc/nginx/sites-enabled/
sudo ln -s /etc/nginx/sites-available/nginx-storage.conf /etc/nginx/sites-enabled/
sudo certbot --nginx -d api.wisdombusara.com -d storage.wisdombusara.com
sudo nginx -t && sudo systemctl reload nginx
```

Once `storage.wisdombusara.com` is live, set `MINIO_PUBLIC_URL=https://storage.wisdombusara.com` in `.env` and restart the API so new photo URLs use the HTTPS domain instead of the bare port.

## 6. Continuous deployment (auto-deploy on push)

Every push to `main` that touches `backend/` triggers [`.github/workflows/deploy-backend.yml`](../.github/workflows/deploy-backend.yml), which SSHs into the VPS and runs [`deploy/deploy.sh`](deploy/deploy.sh) — that pulls the latest code and runs `docker compose up -d --build api`. This is one-time setup; after it's done, deploys are just `git push`.

**On the VPS:**

1. Make a dedicated deploy user (or reuse one you already have) and put it in the `docker` group so it can run `docker compose` without `sudo`:
   ```bash
   sudo useradd -m -s /bin/bash kaza-deploy
   sudo usermod -aG docker kaza-deploy
   ```

2. Generate a dedicated SSH keypair for GitHub Actions to use — don't reuse your personal key:
   ```bash
   ssh-keygen -t ed25519 -f ~/.ssh/kaza_deploy_key -N ""
   sudo -u kaza-deploy mkdir -p /home/kaza-deploy/.ssh
   cat ~/.ssh/kaza_deploy_key.pub | sudo tee -a /home/kaza-deploy/.ssh/authorized_keys
   sudo chown -R kaza-deploy:kaza-deploy /home/kaza-deploy/.ssh
   sudo chmod 700 /home/kaza-deploy/.ssh && sudo chmod 600 /home/kaza-deploy/.ssh/authorized_keys
   ```
   Keep `~/.ssh/kaza_deploy_key` (the private half) — it goes into a GitHub secret in step 4, then you're done with the local copy (delete it or keep it somewhere safe, but it never needs to touch your laptop again).

3. Clone the repo once at a fixed path, as that deploy user, and create the real `.env` (steps 1-3 above still apply — this `.env` is never committed):
   ```bash
   sudo -u kaza-deploy git clone git@github.com:WisdomBusara/unfat.git /opt/kaza-app
   cd /opt/kaza-app/backend
   sudo -u kaza-deploy cp .env.example .env
   sudo -u kaza-deploy nano .env   # fill in real values
   chmod +x deploy/deploy.sh
   ```
   Run it once by hand to confirm it works before wiring up Actions: `sudo -u kaza-deploy bash deploy/deploy.sh`

4. In the GitHub repo → **Settings → Secrets and variables → Actions**, add:

   | Secret | Value |
   |---|---|
   | `VPS_HOST` | Your VPS IP or hostname |
   | `VPS_USER` | `kaza-deploy` |
   | `VPS_SSH_KEY` | Contents of `~/.ssh/kaza_deploy_key` (the private key from step 2) |
   | `KAZA_REPO_PATH` | `/opt/kaza-app` |

That's it — push to `main`, watch the **Actions** tab on GitHub for the run, and `docker compose logs -f api` on the VPS if something looks wrong.

**What this does *not* automate, on purpose:** `.env` changes and database schema changes (`schema.sql`). Both can hold real user data or secrets, so both stay manual — edit `.env` and restart (`docker compose restart api`) by hand, and run new migrations yourself after reviewing them.

## API surface

| Route | Auth | Purpose |
|---|---|---|
| `POST /auth/signup` | — | Create account, returns token pair |
| `POST /auth/login` | — | Returns token pair |
| `POST /auth/refresh` | — | Rotates refresh token |
| `POST /auth/logout` | — | Revokes a refresh token |
| `GET/PUT /users/me` | ✓ | Profile |
| `GET/POST /weight` | ✓ | Weight entries (`?days=90`) |
| `GET/POST /workouts` | ✓ | Workout sessions (`?days=90`) |
| `GET/POST /goals` | ✓ | Active goals |
| `POST /goals/:id/complete` | ✓ | Mark goal complete |
| `GET /exercises` | ✓ | Exercise catalog (`?search=&category=&limit=`) |
| `GET /foods` | ✓ | Food catalog (`?search=&cuisine=&limit=`) |
| `GET/POST /nutrition/meals` | ✓ | Meals (`?date=YYYY-MM-DD`) |
| `GET /photos` | ✓ | Progress photos (`?angle=front`) |
| `POST /photos/upload` | ✓ | Upload + AI analysis (base64 JSON body) |
| `POST /ai/workout-recommendation` | ✓ | Claude-generated workout suggestion |
| `POST /ai/nutrition-analysis` | ✓ | Claude analysis of today's logged meals |
| `POST /ai/weight-loss-strategy` | ✓ | Claude-generated pacing/strategy |

All `✓` routes require `Authorization: Bearer <accessToken>`.
