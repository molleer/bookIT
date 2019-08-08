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
ENV DATABASE_HOST db
ENV DATABASE_USER bookit
ENV DATABASE_PASSWORD password
ENV DATABASE_ADAPTER mysql2

ENV ACCOUNT_ADDRESS http://localhost:8081
ENV OAUTH_ID 1RbbpBxHO2TCkHObrVFnsVsC5kLyjMLDFc6koNxNJ33it1pdHK1hBSbbWOxRKSyGj6OAHskavXo
ENV OAUTH_SECRET TTSAq4XuBq8lhIbzgw1AjD7mZX2ZwDe4YJrhOo87saORbaKb5rP6JvYA1zIawBrv5mIzLJLWrmM

# Start server
ENV RAILS_ENV development
ENV RACK_ENV development
ENV SECRET_KEY_BASE secret
ENV PORT 3000
EXPOSE 3001

COPY . /app
RUN useradd ruby
RUN chown -R ruby /app
USER ruby

CMD ["sh", "start.sh"]
