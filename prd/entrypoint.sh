#!/bin/bash
set -e

cd /var/www

RAILS_ENV=production bundle exec rails assets:precompile
RAILS_ENV=production bundle exec rails db:migrate

exec "$@"
