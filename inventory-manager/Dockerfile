FROM ruby:3.1.4-alpine3.19 as base

RUN apk update --no-cache \
  && apk upgrade --no-cache \
  && apk add --no-cache \
  postgresql

FROM ruby:3.1.4-alpine3.19 as builder

RUN apk add --update --no-cache \
    build-base \
    postgresql-dev

ENV APP_HOME /inventory-manager
WORKDIR $APP_HOME

COPY Gemfile* ./
ENV RAILS_ENV production
RUN  gem install bundler \
  && bundle config set without 'development test' \
  && bundle install --jobs=4

COPY . $APP_HOME
RUN rm -rf $APP_HOME/tmp/*

FROM base

ENV RAILS_ENV=production
ENV APP_USER=shoe_store
ENV APP_GROUP=shoe_store
ENV RAILS_LOG_TO_STDOUT="true"

RUN adduser -D $APP_USER

USER $APP_USER

ENV APP_HOME /inventory-manager
WORKDIR $APP_HOME

COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=builder --chown=$APP_USER:$APP_GROUP $APP_HOME $APP_HOME

RUN mkdir -p tmp/pids && rm -rf vendor/

CMD [ "bin/rails", "s" ]
