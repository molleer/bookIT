FROM node:10.15

RUN mkdir -p /usr/src/app/
RUN chown -R node /usr/src/app

USER node

WORKDIR /usr/src/app

COPY package.json .

RUN yarn install

EXPOSE 3000

CMD yarn start