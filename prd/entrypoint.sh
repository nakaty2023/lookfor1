#!/bin/bash
set -e

cd /var/www
RAILS_ENV=production bundle exec rails db:migrate:reset
RAILS_ENV=production bundle exec rails assets:precompile

exec "$@"
