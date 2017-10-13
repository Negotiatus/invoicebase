ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)

# Prevent database truncation if the environment is production.
abort("The Rails environment is running in production mode!") if Rails.env.production?

require "spec_helper"
require "rspec/rails"
require "rspec/autorun"
require "devise"

# Ensure that migrations are up-to-date.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # Instead of using the DatabaseCleaner gem, we can wrap everything in a
  # database transaction for faster performance and still ensure our database is
  # clean after every test.
  config.use_transactional_fixtures = true

  # In case a spec type hasn't been defined, RSpec can attempt to figure it out
  # for us.
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end

# Configuration for shoulda_matchers gem.
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
