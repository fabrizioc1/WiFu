# Add this projects 'lib' directory to load path
lib = File.expand_path('../lib/', __FILE__)
$: << lib unless $:.include?(lib)
require 'bundler/setup'
require 'wifi_packet'
require 'spec/shared/wifi_packet_matchers'
require 'spec/shared/wifi_packet_examples'
#TODO: Test with MRI 1.9 
#require 'simplecov'

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  #config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  #config.use_transactional_fixtures = true
end