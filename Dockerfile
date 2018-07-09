FROM ruby:2.3.3
RUN apt-get update && apt-get install -y \
#Packages
net-tools \
nodejs

RUN apt-get clean

#Install gems
RUN mkdir /app
WORKDIR /app
COPY Gemfile* /app/
RUN bundle install

#Upload source
COPY . /app
RUN useradd ruby
RUN chown -R ruby /app
USER ruby

# Database defaults
ENV DATABASE_NAME bookIT
ENV DATABASE_HOST db
ENV DATABASE_USER bookIT
ENV DATABASE_PASSWORD password
ENV DATABASE_ADAPTER mysql2
#In production, Host is set to naboo.chlamers.it
# Start server
ENV RAILS_ENV production
ENV RACK_ENV production
ENV SECRET_KEY_BASE secret
ENV PORT 3000
EXPOSE 3000


CMD ["sh", "start.sh"]
