#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

echo "==> Building Docker images..."
docker compose build

echo "==> Build complete."
