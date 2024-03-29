FROM ruby:3.3.0
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential \
                                               libpq-dev \
                                               libsqlite3-dev \
                                               libvips \
                                               default-libmysqlclient-dev
EXPOSE 3000
EXPOSE 3001
WORKDIR /app
COPY . .
