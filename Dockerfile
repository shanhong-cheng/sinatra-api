FROM ruby:2.7.5
MAINTAINER scheng@anchorusd.com

ARG BUILD_RACK_ENV development
ENV RACK_ENV=$BUILD_RACK_ENV

RUN apt-get update && apt-get install -y \
  build-essential \
  nodejs \
  libsodium-dev

RUN mkdir -p /app
WORKDIR /app

ENV PORT 9292

EXPOSE $PORT

COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs 20 --retry 5

COPY . ./

ENTRYPOINT ["bundle", "exec"]

CMD ["puma"]
