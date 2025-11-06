ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

  # Setup selected fixtures to avoid loading stale fixture files referencing dropped tables.
  fixtures :users, :courses

    # Add more helper methods to be used by all tests here...
    include Devise::Test::IntegrationHelpers
  end
end
