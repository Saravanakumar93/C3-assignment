FROM node:14-alpine

# app directory
WORKDIR /usr/src/app

# Copying both package.json AND package-lock.json 
# Installing app dependencies

COPY package*.json ./

RUN npm install

# Bundle app source
COPY . .

EXPOSE 8080

CMD [ "node", "server.js" ]