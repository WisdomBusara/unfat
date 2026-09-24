#!/usr/bin/env bash
# Runs ON the VPS — invoked by the deploy-backend GitHub Actions workflow
# over SSH. Safe to run by hand too: bash backend/deploy/deploy.sh
#
# Assumes the repo is already cloned on the VPS and backend/.env already
# exists there (see backend/README.md "Continuous Deployment" section for
# one-time setup). This script never touches .env or the database schema —
# both are deliberately manual steps.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
BACKEND_DIR="$REPO_ROOT/backend"

echo "==> Pulling latest main..."
cd "$REPO_ROOT"
git fetch origin main
git reset --hard origin/main

if [ ! -f "$BACKEND_DIR/.env" ]; then
  echo "ERROR: $BACKEND_DIR/.env is missing. Create it once from .env.example before deploying." >&2
  exit 1
fi

echo "==> Rebuilding and restarting the API container..."
cd "$BACKEND_DIR"
docker compose up -d --build api

echo "==> Waiting for health check..."
sleep 5
if curl -sf http://127.0.0.1:8080/ > /dev/null; then
  echo "==> Deploy succeeded, API is responding."
else
  echo "==> WARNING: API did not respond on :8080 after restart. Check: docker compose logs api" >&2
  exit 1
fi
