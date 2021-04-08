ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/mock'
require_relative "support/fake_puppet_db"

# Start FakePuppetDB-Server
server_thread = Thread.new do
  Rack::Server.start(app: FakePuppetDB.new, Host: "localhost", Port: 8084)
end
server_thread.join(1)

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def with_temp_file(path, &block)
    begin
      File.unlink(path) if File.exist?(path)
      yield
    ensure
      File.unlink(path) if File.exist?(path)
    end
  end

  def json
    JSON.parse(response.body)
  end
end
