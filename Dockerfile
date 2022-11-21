FROM ruby:3.1 as builder
RUN apt-get update -qq && apt-get install -y nodejs yarn postgresql-client

ENV BUNDLER_VERSION 2.2.14
ENV APP_PATH /work

ARG RACK_ENV
ARG RAILS_ENV
ARG RAILS_MASTER_KEY

WORKDIR $APP_PATH

COPY Gemfile Gemfile.lock ./

RUN gem install bundler -v $BUNDLER_VERSION
RUN bundle install

#COPY package.json yarn.lock ./
#RUN yarn install

ADD . $APP_PATH

RUN rails assets:precompile

FROM ruby:3.1
RUN mkdir -p /work
WORKDIR /work

ENV RAILS_ENV production

RUN --mount=type=secret,id=_env,dst=/etc/secrets/.env

COPY --from=builder /usr/lib /usr/lib
COPY --from=builder /usr/share/zoneinfo/ /usr/share/zoneinfo/
COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --from=builder /work /work

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]