
FROM ruby:3.2-slim

RUN apt-get update -qq && apt-get install -y build-essential

WORKDIR /app

COPY Gemfile ./

RUN bundle install

COPY . .


CMD ["ruby", "main.rb"]
