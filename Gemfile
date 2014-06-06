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
  gem "database_cleaner"
  gem "launchy"
  gem 'capybara-email'
end

group :test, :development, :production do
  gem 'fabrication'
  gem 'faker'
end


group :production do
  gem 'pg'
  gem 'rails_12factor'
end

