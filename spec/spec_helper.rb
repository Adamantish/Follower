$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'follow_service'
require 'rack/test'
require 'database_cleaner'
require 'pry-byebug'

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end



RSpec.configure do |config|

  config.before(:each) do
    # request.env['Accept'] = "stuff"
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

end