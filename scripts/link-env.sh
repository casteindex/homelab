#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-/srv/homelab}"
DOCKER_DIR="$ROOT/docker"

for f in "$DOCKER_DIR"/*/compose.y*ml "$DOCKER_DIR"/*/docker-compose.y*ml; do
    [ -e "$f" ] || continue

    d=$(dirname "$f")

    if [ ! -e "$d/.env" ] && [ ! -L "$d/.env" ]; then
        ln -s ../../.env "$d/.env"
        echo "creado: $d/.env"
    fi
done
