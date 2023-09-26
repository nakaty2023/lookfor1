#!/bin/bash
set -e

cd /var/www
RAILS_ENV=production DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rails db:migrate:reset
RAILS_ENV=production bundle exec rails db:seed
RAILS_ENV=production bundle exec rails assets:precompile

exec "$@"
