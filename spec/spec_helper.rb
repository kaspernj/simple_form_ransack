ENV["RAILS_ENV"] ||= "test"
require_relative "dummy/config/environment"

require "rspec/rails"
require "capybara/rspec"
require "capybara/rails"
require "ransack"
require "simple_form"
require "country_select"
require "sqlite3"

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.filter_rails_from_backtrace!
  config.infer_spec_type_from_file_location!

  config.before(:each) do
    Capybara.reset_sessions!
  end
end
