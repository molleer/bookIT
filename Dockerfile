FROM ruby:2.3.3
RUN apt-get update && apt-get install -y \
    #Packages
    net-tools \
    nodejs 

#Install phantomjs
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    ca-certificates \
    bzip2 \
    libfontconfig \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    curl \
    && mkdir /tmp/phantomjs \
    && curl -L https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 \
    | tar -xj --strip-components=1 -C /tmp/phantomjs \
    && cd /tmp/phantomjs \
    && mv bin/phantomjs /usr/local/bin \
    && cd \
    && apt-get purge --auto-remove -y \
    curl \
    && apt-get clean \
    && rm -rf /tmp/* /var/lib/apt/lists/*



#Install gems
RUN mkdir /app
WORKDIR /app
COPY Gemfile* /app/
RUN bundle install
RUN apt-get clean

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

ENV ACCOUNT_ADDRESS https://gamma.chalmers.it


#In production, Host is set to naboo.chlamers.it
# Start server
ENV RAILS_ENV production
ENV RACK_ENV production
ENV SECRET_KEY_BASE secret
ENV PORT 3000
EXPOSE 3000

RUN rake assets:precompile

CMD ["sh", "start.sh"]
