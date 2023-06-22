FROM node:16.12.0-alpine3.14 AS builder

USER node
RUN mkdir -p /home/node/app
WORKDIR /home/node/app

# install packages
COPY --chown=node:node src/package*.json ./
RUN npm i

# copy src code
COPY --chown=node:node ./src .


FROM node:16.12.0-alpine3.14

USER node
RUN mkdir -p /home/node/app
WORKDIR /home/node/app

COPY --from=builder /home/node/app/ ./

# expose
EXPOSE 3000

# entrypoint
# ENTRYPOINT node index.js