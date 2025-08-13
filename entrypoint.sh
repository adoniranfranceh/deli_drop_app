#!/bin/bash
set -e

rm -f tmp/pids/server.pid

./bin/rails db:prepare
echo "Verificando gems..."
bundle check || bundle install

exec "$@"
