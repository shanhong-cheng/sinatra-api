require 'mongoid'

mongo_log_level = ENV['MONGODB_LOGGER_LEVEL'] ? Logger::SEV_LABEL.find_index(ENV['MONGODB_LOGGER_LEVEL']) : :info

Mongoid.configure do |config|
  config.clients.default = {
    uri: ENV['DATABASE_URI'],
    options: {
      connect_timeout: 15,
      wait_queue_timeout: 15,
    },
  }

  config.raise_not_found_error = false
  config.log_level = mongo_log_level
end