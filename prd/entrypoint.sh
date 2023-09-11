#!/bin/bash
set -e

cd /var/www
RAILS_ENV=production bundle exec rails db:migrate
RAILS_ENV=production bundle exec rails assets:precompile

exec "$@"
