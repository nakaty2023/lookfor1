#!/bin/bash
set -e

cd /var/www
rm -f /var/www/tmp/pids/server.pid
RAILS_ENV=production bundle exec rails db:migrate
RAILS_ENV=production bundle exec rails assets:precompile
RAILS_ENV=production bundle exec rails db:seed

exec "$@"
