FROM tindy2013/subconverter:latest
COPY files/ /base/
EXPOSE 25500

# ---- Dependencies ----
FROM node:12-alpine AS dependencies
WORKDIR /app
COPY package.json ./
RUN yarn install

# ---- Build ----
FROM dependencies AS build
WORKDIR /app
COPY . /app
RUN yarn build

FROM nginx:1.16-alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD [ "nginx", "-g", "daemon off;" ]