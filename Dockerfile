FROM ruby:3.2.3-slim

# Set global environments required for application
ENV SECRET_KEY_BASE a8d941453453f2d5c88c3a2132e114f00eb966062e0ce01ebf1e4b80d2249669d527dc7cd19e321315be13d6694c1f67d98dd52599ad15dc5708deedaef9000c

# Update host repository and install postgresql-client
RUN apt-get update && apt-get install -y git postgresql-client make gcc libpq-dev

WORKDIR /app

COPY Gemfile ./
COPY Gemfile.lock ./

RUN gem install bundler -v 2.4 --no-document
RUN bundle install

COPY . ./

# Add a script to be executed every time the container starts.
COPY .dockerdev/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
EXPOSE 3000
ENTRYPOINT ["entrypoint.sh"]
