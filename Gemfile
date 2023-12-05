source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.4"

gem "rails", "7.0.4"
gem "sprockets-rails"
gem "puma", "~> 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap", require: false
gem "sassc-rails"
gem "image_processing", "~> 1.2"
gem 'nokogiri'
gem 'whenever', require: false
gem "selenium-webdriver"
gem "devise"
gem 'devise-i18n'
gem 'bootstrap'
gem 'jquery-rails'
gem 'geocoder'
gem 'active_storage_validations'
gem 'pg'
gem "faker"
gem 'ransack'
gem 'rufus-scheduler'

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'rspec-rails'
  gem "factory_bot_rails"
  gem 'dotenv-rails'
end

group :development do
  gem "web-console"
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-performance', require: false
  gem 'bullet'
  gem "rails-erd"
end

group :test do
  gem "capybara"
end

group :production do
  gem "aws-sdk-s3", require: false
end
