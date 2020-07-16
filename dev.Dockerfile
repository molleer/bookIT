FROM ruby:2.3.3
#
RUN apt-get update && apt-get install -y \
#Packages
net-tools \
nodejs

RUN apt-get clean

#Install gems
WORKDIR /app
COPY Gemfile* /app/
RUN bundle install

#Upload source

# Database defaults
ENV DATABASE_NAME bookit
ENV DATABASE_HOST 0.0.0.0
ENV DATABASE_USER bookit
ENV DATABASE_PASSWORD password
ENV DATABASE_ADAPTER mysql2

ENV ACCOUNT_ADDRESS http://0.0.0.0:8081
ENV OAUTH_ID fePRJDMy1b7nbo2lDLEfMM1qOZ3SoT6V5iYOslF7eaUFRgv8OCwWrTJzihwYWfJSJ8h2NHG42Vt
ENV OAUTH_SECRET tBIGOmvJ8y7CqAzGEMzhbWJ5d3oYQcUpM4if1FzNEVdw1tSxOScbouCZssyCMNJMXPvwsAXJNLH

# Start server
ENV RAILS_ENV development
ENV RACK_ENV development
ENV SECRET_KEY_BASE secret
ENV PORT 3001
EXPOSE 3001

COPY . /app
RUN useradd ruby
RUN chown -R ruby /app
USER ruby

CMD ["sh", "start.sh"]
