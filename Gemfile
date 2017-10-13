source "https://rubygems.org"

gem "rails", "~> 5.1.2"
gem "pg"
# Use Puma as the app server
gem "puma", "~> 3.7"
# Use SCSS for stylesheets
gem "sass-rails", "~> 5.0"
# Use Uglifier as compressor for JavaScript assets
gem "uglifier", ">= 1.3.0"

gem "figaro"

# Turbolinks makes navigating your web application faster. Read more:
# https://github.com/turbolinks/turbolinks
gem "turbolinks", "~> 5"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.5"

gem "delayed_job_active_record"

gem "slack-notifier"

gem "paperclip", "~> 5.0.0"

gem "devise"
gem "omniauth-google-oauth2"

gem "httparty"
gem "fullcontact"

gem "fuzzy_match"
gem "amatch"

gem "will_paginate"

group :production, optional: true do
  gem "unicorn"
end

group :development do
  gem "web-console", ">= 3.3.0" # Access an IRB console on exception pages or by
                                # using <%= console %> anywhere in the code.
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "annotate"
  gem "bullet"
  gem "better_errors"
end

group :test, optional: true do
  gem "rspec-rails", "~> 3.6"
  gem "rspec-retry"
  gem "factory_girl_rails"
  gem "launchy"
  gem "fuubar"
  gem "hashdiff"
  gem "simplecov", require: false
  gem "shoulda-matchers", "~> 3.1.2"
  gem "rspec_junit_formatter"
end

group :test, :development, optional: true do
  gem "pry"
  gem "pry-byebug"
  gem "faker"
end
