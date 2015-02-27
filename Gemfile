source 'https://rubygems.org'
ruby '2.1.5'

gem 'rails', '~> 4.1.6'

#
# PLATFORM SPECIFIC
#
# OSX
gem 'rb-fsevent', group: [:development, :test]        # monitor file changes without hammering the disk
gem 'terminal-notifier-guard', group: [:development]  # notify terminal when specs run
gem 'terminal-notifier', group: [:development]
# LINUX
# gem 'rb-inotify', :group => [:development, :test]   # monitor file changes without hammering the disk


# Monitoring
gem 'rack-timeout', '~> 0.1.0beta4'
gem 'newrelic_rpm'
gem 'airbrake', '~> 3.2.1' # use with airbrake.io or errbit
# gem 'airbrake_user_attributes'  # use with self-hosted errbit; see config/initializers/airbrake.rb
gem 'rack-google-analytics'
# Consider switching to rake-tracker gem instead of Google gem
# gem 'rack-tracker'

# Data
gem 'pg'
# gem 'mysql2'
gem 'dalli' # memcached
# gem 'schema_plus' # add better index and foreign key support
gem 'jbuilder'
gem 'rake', '>=10.3.2'

# Assets
gem 'sass-rails'
gem 'haml-rails'
gem 'simple_form'
gem 'uglifier'
gem 'headjs-rails'
gem "gritter", "1.1.0"

# Random
gem 'mailboxer', git: 'git://github.com/ging/mailboxer.git'
gem 'rails4-autocomplete'
gem 'acts_as_votable', '~> 0.10.0'
gem 'acts-as-taggable-on'
gem "paperclip", :git => "git://github.com/thoughtbot/paperclip.git"

# Javascript
gem 'jquery-rails'
gem 'turbolinks'
gem 'jquery-turbolinks'
gem 'jquery-ui-rails'
gem 'nprogress-rails'
gem 'modernizr-rails'
gem 'twitter-bootstrap-rails-confirm'

# CoffeeScript
# Not needed in production if precompiling assets
gem 'coffee-rails'
# Uncomment if node.js is not installed
# gem 'therubyracer', platforms: :ruby

# Design
gem "autoprefixer-rails"
gem 'js-routes'
gem 'draper', '~> 1.3'
# gem 'bourbon'
# gem 'neat'
# gem 'country_select'
# gem 'compass-rails' # Add your application.css.scss @import "compass";

# # rake css_lint:run
# # rake css_lint:generate_config
# gem 'ruby_css_lint'

# Email
gem 'premailer-rails'

# Authentication
gem 'devise'
gem 'cancancan', '~> 1.9'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'omniauth-github'
gem 'omniauth-linkedin'
gem 'omniauth-google-oauth2'
# gem 'omniauth-persona'

# Admin
gem 'rails_admin'

# Workers
gem 'sidekiq'
gem 'devise-async'
gem 'sinatra', require: false

# Utils
gem 'addressable'
gem 'settingslogic'

group :development do
  # Docs
  gem 'sdoc', require: false    # bundle exec rake doc:rails

  # Errors
  gem 'better_errors'
  gem 'binding_of_caller'     # extra features for better_errors
  # gem 'meta_request'          # for rails_panel chrome extension

  # Deployment
  # gem 'capistrano'

  # Guard
  gem 'guard-rspec'
  # gem 'guard-livereload'
  # gem 'rack-livereload'
end

group :development, :test do
  # Use spring or zeus
  gem 'spring'                  # keep application running in the background
  gem 'spring-commands-rspec'
  # gem 'zeus'                  # required in gemfile for guard

  # Debugging
  # gem 'pry'                   # better than irb
  # gem 'byebug'                # ruby 2.0 debugger with built-in pry
  gem 'pry-rails'               # adds rails specific commands to pry
  gem 'pry-byebug'              # add debugging commands to pry
  gem 'pry-stack_explorer'      # navigate call stack
  # gem 'pry-rescue'            # start pry session on uncaught exception
  # gem 'pry-doc'               # browse docs from console
  # gem 'pry-git'               # add git support to console
  # gem 'pry-remote'            # connect remotely to pry console
  # gem 'coolline'              # sytax highlighting as you type
  # gem 'coderay'               # use with coolline
  gem 'awesome_print'           # pretty pring debugging output

  # Testing
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'ffaker'
  # gem 'capybara-webkit'
  # gem 'poltergeist'           # alternative to capybara-webkit
  # gem 'capybara-firebug'
  # gem 'launchy'               # save_and_open_page support for rspec
  # gem 'zeus-parallel_tests'   # speed up lengthy tests

  # Logging
  gem 'quiet_assets'
end

group :test do
  gem 'minitest'                # include minitest to prevent require 'minitest/autorun' warnings

  # Helpers
  gem 'shoulda-matchers'
  gem 'database_cleaner'
  # gem 'timecop'               # Mock Time

  # Coverage
  gem 'simplecov', require: false
  # gem 'coveralls', :require => false

  gem 'rspec-sidekiq'
  gem 'rspec-activemodel-mocks'
end

group :production do
  gem 'memcachier'              # heroku add-on for auto config of dalli
  gem 'unicorn'
  gem 'rails_12factor'          # https://devcenter.heroku.com/articles/rails4
end

