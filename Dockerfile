FROM ruby:2.4

ENV APP_PATH /google_services

RUN mkdir -p $APP_PATH

WORKDIR $APP_PATH

ADD Gemfile $APP_PATH/Gemfile

ADD Gemfile.lock $APP_PATH/Gemfile.lock

RUN bundle install

ADD . $APP_PATH
