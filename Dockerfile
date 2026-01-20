# syntax=docker/dockerfile:1

FROM ruby:3.4.6-alpine AS base

WORKDIR /app

# Install build dependencies for native gems
RUN apk add --no-cache build-base

# Copy Gemfile and install dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle config set --local without 'development' && \
    bundle install --jobs 4 --retry 3

# Copy application code
COPY lib/ ./lib/

# Set entrypoint to run the bowling application
ENTRYPOINT ["ruby", "lib/main.rb"]

# Default help message when no arguments provided
CMD []
