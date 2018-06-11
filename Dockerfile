FROM node:8-alpine
ENV NPM_CONFIG_LOGLEVEL warn
ENV NPM_REGISTRY https://registry.npm.taobao.org
ARG VERSION=latest
RUN addgroup -g 1001 composer
RUN adduser -u 1001 -G composer -s /bin/sh -D composer
RUN apk add --no-cache make gcc g++ python git libc6-compat

# Run as the composer user ID.
USER composer

RUN npm set registry $NPM_REGISTRY
RUN npm config set prefix '/home/composer/.npm-global'
RUN npm install --production -g pm2 composer-playground@0.19.6
RUN npm cache clean --force
#RUN rm -rf /home/composer/.config /home/composer/.node-gyp /home/composer/.npm
#RUN apk del make gcc g++ python git


# Add global composer modules to the path.
ENV PATH /home/composer/.npm-global/bin:$PATH

# Run in the composer users home directory.
WORKDIR /home/composer

# Run supervisor to start the application.
CMD [ "pm2-docker", "composer-playground" ]

# Expose port 8080.
EXPOSE 8080
