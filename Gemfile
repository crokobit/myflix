source 'https://rubygems.org'
ruby '2.0.0'

gem 'bootstrap-sass'
gem 'coffee-rails'
gem 'rails'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'bootstrap_form', github: "bootstrap-ruby/rails-bootstrap-forms"
gem 'bcrypt-ruby', '~> 3.1.2'
gem 'sidekiq'
gem 'unicorn'
gem 'redis'
gem 'paratrooper'
gem 'carrierwave'
gem 'mini_magick'
gem "figaro"
gem 'stripe'
gem 'draper'
gem 'stripe_event'
gem 'fog'
gem 'newrelic_rpm'

group :development do
  gem 'sqlite3'
  gem 'pry'
  gem 'pry-nav'
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
  gem 'letter_opener'
end

group :test, :development do
  gem 'rspec-rails'
  gem 'capybara'
  gem 'shoulda-matchers'
  gem 'rspec-console'
  gem "launchy"
  gem 'capybara-email'
  gem 'selenium-webdriver'
  gem 'database_cleaner'
  gem "capybara-webkit"
end

group :test do
  gem 'vcr'
  gem 'webmock'
end

group :test, :development, :production do
  gem 'fabrication'
  gem 'faker'
end


group :production do
  gem 'pg'
  gem 'rails_12factor'
  gem 'sentry-raven' 
end

