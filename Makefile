test: DATABASE_URI=mongodb://user:pass@localhost/test?retryWrites=true&authSource=test
pry server: DATABASE_URI=mongodb://root:example@localhost/?retryWrites=true
test:
	MONGODB_LOGGER_LEVEL=ERROR RACK_ENV=test bundle exec rake test
dev:
	MONGODB_LOGGER_LEVEL=ERROR RACK_ENV=development bundle exec puma -p 3000
production:
	MONGODB_LOGGER_LEVEL=ERROR RACK_ENV=production bundle exec puma -p 3000
pry:
	MONGODB_LOGGER_LEVEL=ERROR bundle exec pry
