FROM node:10.15

RUN mkdir -p /usr/src/app/
RUN chown -R node /usr/src/app

USER node

WORKDIR /usr/src/app

COPY package.json .
COPY package-lock.json .

RUN npm install

COPY . .

EXPOSE 4000

CMD ["npm", "run", "dev"]