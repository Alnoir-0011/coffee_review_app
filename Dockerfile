FROM ruby:3.2.2
RUN apt-get update -qq && apt-get install -y postgresql-client nodejs npm vim
RUN mkdir /myapp
WORKDIR /myapp
ADD Gemfile /myapp/Gemfile
ADD Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
ADD . /myapp
