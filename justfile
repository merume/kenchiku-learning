default:
    just --list
# DB 起動
db:
  docker compose up -d db
# 開発環境にridgepoleを適用
apply-dev:
  docker compose run --rm app bundle exec ridgepole -c config/database.yml --apply -f db/schemas/Schemafile
# テスト環境にridgepoleを適用
apply-test:
  docker compose run --rm app bundle exec ridgepole -c config/database.yml --apply -f db/schemas/Schemafile --env test
# テストを実行
test *args:
  docker compose run --rm app bundle exec rspec {{args}}
# rails consoleを起動
console:
  docker compose run --rm app bundle exec rails console
# rails serverを起動
server:
  docker compose up -d app
# bashを起動
bash:
  docker compose run --rm app bash