ARG RUBY_VERSION=3.1.2-jemalloc

FROM quay.io/evl.ms/fullstaq-ruby:${RUBY_VERSION}-slim

RUN apt-get update -qq && apt-get install -y build-essential postgresql-client libpq-dev

RUN gem install bundler -v 2.1.4

ENV RAILS_ENV production

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle config build.nokogiri --use-system-libraries

RUN bundle check || bundle install --quiet

COPY . ./ 