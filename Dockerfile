FROM ruby:3.1.4-buster

RUN curl -sL https://deb.nodesource.com/setup_20.x | bash -
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN curl -sL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs postgresql-client-15

ENV APP_ROOT /var/www
RUN mkdir -p $APP_ROOT/tmp/pids
WORKDIR $APP_ROOT
COPY Gemfile /var/www/Gemfile
COPY Gemfile.lock /var/www/Gemfile.lock

RUN bundle config set --global force_ruby_platform true
RUN bundle install
