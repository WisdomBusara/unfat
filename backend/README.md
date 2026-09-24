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

Then load the schema:

```bash
psql -U kaza -d kaza -h localhost -f schema.sql
```

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
| `GET/POST /nutrition/meals` | ✓ | Meals (`?date=YYYY-MM-DD`) |
| `GET /photos` | ✓ | Progress photos (`?angle=front`) |
| `POST /photos/upload` | ✓ | Upload + AI analysis (base64 JSON body) |
| `POST /ai/workout-recommendation` | ✓ | Claude-generated workout suggestion |
| `POST /ai/nutrition-analysis` | ✓ | Claude analysis of today's logged meals |
| `POST /ai/weight-loss-strategy` | ✓ | Claude-generated pacing/strategy |

All `✓` routes require `Authorization: Bearer <accessToken>`.
