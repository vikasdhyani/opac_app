require 'rubygems'
require 'spork'

Spork.prefork do
  if ENV['COVERAGE'] == 'on'
    require 'simplecov'
    require 'simplecov-rcov'
    SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
    SimpleCov.start
  end

  require 'factory_girl'
  Spork.trap_class_method(FactoryGirl, :find_definitions)

  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'

  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    config.mock_with :rspec
    config.fixture_path = "#{::Rails.root}/spec/fixtures"
    config.use_transactional_fixtures = true
    config.include Devise::TestHelpers, :type => :controller
  end
end

Spork.each_run do
end

