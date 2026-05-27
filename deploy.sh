#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

echo "==> Building images..."
docker compose build

echo "==> Starting services..."
docker compose up -d

echo "==> Waiting for health check..."
sleep 2

if curl -sf http://127.0.0.1:8080/health > /dev/null; then
  echo "==> Deploy OK: http://127.0.0.1:8080/"
else
  echo "==> Health check failed. Logs:"
  docker compose logs --tail=30
  exit 1
fi
