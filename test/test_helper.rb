require "simplecov"
require "simplecov-cobertura"

SimpleCov.start do
  add_group "Models", "app/models"
  add_group "Controllers", "app/controllers"
  add_group "Blueprints", "app/blueprints"
  add_group "Services", "app/services"
  add_group "Concerns", ["app/controllers/concerns", "app/models/concerns"]

  add_filter "/test/"
  add_filter "/lib/"
  add_filter "/config/"
  add_filter "Gemfile"
  add_filter "app/mailers/"
  add_filter "app/channels/"
  add_filter "app/jobs/"
end

SimpleCov.at_exit do
  SimpleCov.result.format!
end

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "mocha/minitest"

module ActiveSupport
  class TestCase
    parallelize(workers: 1)
    fixtures :all

    def parse_response_body
      ActiveSupport::JSON.decode(response.body)
    end
  end
end
