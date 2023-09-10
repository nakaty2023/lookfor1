FROM ruby:3.1.4-buster

RUN curl -sL https://deb.nodesource.com/setup_20.x | bash - \
    && echo "deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
    && curl -sL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && apt-get update -qq \
    && apt-get install -y build-essential libpq-dev nodejs postgresql-client-15

RUN mkdir -p /var/www/tmp/pids
WORKDIR /var/www
COPY Gemfile /var/www/Gemfile
COPY Gemfile.lock /var/www/Gemfile.lock

RUN bundle config set --global force_ruby_platform true
RUN bundle install --without test development

COPY . /var/www

COPY prd/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

VOLUME /var/www/public
VOLUME /var/www/tmp/

CMD bash -c "bundle exec puma -C config/puma.rb"
