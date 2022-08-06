require 'sinatra'
require "sinatra/json"
require 'sinatra/param'
require 'dotenv/load'
require 'mongoid'
require 'bcrypt'
require 'json'
require_relative './models'
require_relative './db'

def authenticated_api_user
  raw_bearer_authorization_value = request.env['HTTP_AUTHORIZATION'].gsub('Basic ', '')

  unless raw_bearer_authorization_value
    halt 401, {message: 'Missing API Key', error: :not_authorized}.to_json
  end

  bearer_authorization_value = Base64.decode64(raw_bearer_authorization_value)

  username, password = bearer_authorization_value.split(':')
  unless username
    halt 401, {message: 'Malformed API Key', error: :not_authorized}.to_json
  end
  user = User.where(username: username).first
  unless user
    halt 401, {message: 'Username not found', error: :not_authorized}.to_json
  end

  unless user.password == password
    halt 401, {message: 'Username or password not matching', error: :not_authorized}.to_json
  end

  @user = user
  user
end

set :raise_sinatra_param_exceptions, true

error Sinatra::Param::InvalidParameterError do
  { error: "#{env['sinatra.error'].param} is invalid", message: "#{env['sinatra.error'].message}" }.to_json
end

require_relative './api/account'
require_relative './api/employee'
