#!/bin/bash
set -e

APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$APP_DIR"

shell_quote() {
  local quoted=""
  for arg in "$@"; do
    printf -v arg '%q' "$arg"
    quoted+="$arg "
  done
  printf '%s' "$quoted"
}

run_in_container() {
  local cmd="$1"
  shift
  local args
  args=$(shell_quote "$@")
  docker compose run --rm --entrypoint "" \
    -e RAILS_ENV="${RAILS_ENV:-development}" \
    -e POSTGRES_HOST="${POSTGRES_HOST:-db}" \
    -e POSTGRES_USER="${POSTGRES_USER:-postgres}" \
    -e POSTGRES_PASSWORD="${POSTGRES_PASSWORD:-password}" \
    app bash -lc "cd /app && $cmd $args"
}

usage() {
  cat <<EOF
Usage: $(basename "$0") [command]

Commands:
  create          Create the test database using Rails database.yml
  load     Load the Rails schema into the database
  apply    Apply Ridgepole schema from app/db/schemas/Schemafile
  dry-run   Show Ridgepole changes without applying them

Examples:
  bin/migrate.sh create
  bin/migrate.sh load
  bin/migrate.sh apply
  bin/migrate.sh dry-run
EOF
}

if [[ $# -lt 1 ]]; then
  usage
  exit 1
fi

export POSTGRES_USER="${POSTGRES_USER:-postgres}"
export POSTGRES_PASSWORD="${POSTGRES_PASSWORD:-password}"
export POSTGRES_HOST="${POSTGRES_HOST:-db}"
export RAILS_ENV="${RAILS_ENV:-development}"

if [[ "$1" == "-t" ]]; then
  export RAILS_ENV=test
  shift
fi

if [[ $# -lt 1 ]]; then
  usage
  exit 1
fi

COMMAND="$1"
shift

case "$COMMAND" in
  create)
    run_in_container "bundle exec rails db:create" "$@"
    ;;
  load)
    run_in_container "bundle exec rails db:schema:load" "$@"
    ;;
  apply)
    run_in_container "bundle exec ridgepole -c config/database.yml --apply -f db/schemas/Schemafile --env $RAILS_ENV" "$@"
    ;;
  dry-run)
    run_in_container "bundle exec ridgepole -c config/database.yml --dry-run -f db/schemas/Schemafile --env $RAILS_ENV" "$@"
    ;;
  *)
    echo "Unknown command: $COMMAND"
    usage
    exit 1
    ;;
esac
