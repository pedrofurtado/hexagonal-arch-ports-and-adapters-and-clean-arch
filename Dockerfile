FROM ruby:3.3.0
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential \
                                               libpq-dev \
                                               libsqlite3-dev \
                                               libvips \
                                               default-libmysqlclient-dev
EXPOSE 3000
WORKDIR /app
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install
COPY . .
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
