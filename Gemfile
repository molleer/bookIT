source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'

# Use sqlite3 as the database for Active Record
gem 'sqlite3'
gem 'mysql2'

gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'turbolinks'
gem 'jquery-turbolinks'

gem 'compass-rails'
gem 'zurb-foundation', '~> 3.0'

gem 'redcarpet'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'


# Dependencies for bookIT
gem 'nokogiri'
gem 'validates_timeliness', '~> 3.0'
gem 'ri_cal', '~> 0.8.5'
gem 'cancan' # user authorization
gem 'httparty'


# send party reports
gem 'capybara'
gem 'poltergeist'

# logical deletes
gem 'paranoia'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

gem 'web-console', '~> 2.0', group: :development

group :development, :test do
	gem "rspec-rails"
	# gem "rack-mini-profiler"
	gem "better_errors"
	gem "annotate"
	gem "binding_of_caller"
end

group :test do
	gem "factory_girl_rails"
	# gem "capybara" - required higher up
	gem 'rb-fsevent'
	gem 'timecop', '~> 0.7.1'
end


# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
