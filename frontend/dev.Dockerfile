FROM node:13.14.0
WORKDIR /usr/src/app
COPY package.json ./
RUN yarn install --network-timeout 10000000
RUN yarn global add react-scripts
COPY src src
COPY public public
CMD yarn start

