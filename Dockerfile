 # syntax=docker/dockerfile:1
FROM gradle:8.9.0-jdk17 AS builder
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src

RUN gradle wasmJsBrowserDistribution --no-daemon

FROM nginx:alpine
COPY --from=builder /home/gradle/src/composeApp/build/dist/wasmJs/productionExecutable/ /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

# The first stage of the Dockerfile uses the  gradle:8.4.0-jdk17  image to build the project. The  wasmJsBrowserDistribution  task is executed to build the project. The second stage of the Dockerfile uses the  nginx:alpine  image to serve the built project. The  productionExecutable  directory is copied to the  /usr/share/nginx/html  directory.
# The  productionExecutable  directory contains the following files:
# index.html