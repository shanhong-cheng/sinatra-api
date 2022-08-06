require_relative '../app'
require 'rack/test'
require 'minitest/autorun'

include Rack::Test::Methods

def app
  Sinatra::Application
end