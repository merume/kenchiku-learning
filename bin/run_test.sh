#!/bin/bash
set -e

APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$APP_DIR"

run_in_container() {
  docker compose run --rm --entrypoint "" \
    -e RAILS_ENV="${RAILS_ENV:-test}" \
    -e POSTGRES_HOST="${POSTGRES_HOST:-db}" \
    -e POSTGRES_USER="${POSTGRES_USER:-postgres}" \
    -e POSTGRES_PASSWORD="${POSTGRES_PASSWORD:-password}" \
    app bash -lc "cd /app && bundle exec rspec $*"
}

run_in_container "$@"
