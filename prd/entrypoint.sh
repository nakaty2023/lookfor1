#!/bin/bash
set -e

cd /var/www
DISABLE_DATABASE_ENVIRONMENT_CHECK=1 RAILS_ENV=production bundle exec rails db:migrate:reset
RAILS_ENV=production bundle exec rails db:migrate
RAILS_ENV=production bundle exec rails assets:precompile
RAILS_ENV=production bundle exec rails db:seed

exec "$@"
