
# Compose Multiplatform Web + Docker

## Overview

This project demonstrates how to build and deploy a **Kotlin Multiplatform (Compose for Web) application** using **Docker** and **Nginx**. It leverages **Gradle** to compile the application into WebAssembly (Wasm) and serves it through an Nginx container.

## Features

-   🚀 **Compose Multiplatform Web** powered by Kotlin
-   📦 **Dockerized** for easy deployment
-   ⚡ **Nginx** as a lightweight web server
-   🛠 **Docker Compose** setup for simplified container management

----------

## Setup & Usage

### Prerequisites

Ensure you have the following installed:

-   [Docker](https://docs.docker.com/get-docker/)
-   [Docker Compose](https://docs.docker.com/compose/install/)
-   [Gradle](https://gradle.org/install/)

### Building and Running the Container

1.  **Clone the repository**

    ```sh
    git clone https://github.com/yourusername/ComposeDockWeb.git
    cd ComposeDockWeb
    
    ```

2.  **Build and Run the Application**

    ```sh
    docker-compose up --build -d
    
    ```

    This will:

  -   Build the Kotlin Compose Web project
  -   Package it into a container
  -   Serve it via Nginx on port **8000**
3.  **Access the Web App** Open a browser and go to:

    ```
    http://localhost:8000
    
    ```

4.  **Stopping the Containers**

    ```sh
    docker-compose down
    
    ```


----------

## Project Structure

```
📂 ComposeDockWeb
├── 📄 Dockerfile               # Builds the Kotlin Wasm app and sets up Nginx
├── 📄 docker-compose.yml       # Defines services, ports, and networks
├── 📂 src                      # Kotlin source code for Compose Web
├── 📂 build                    # Gradle build artifacts (generated)
└── 📄 README.md                # Documentation

```

----------

## Docker Configuration

### Dockerfile

```dockerfile
# syntax=docker/dockerfile:1
FROM gradle:8.9.0-jdk17 AS builder
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
RUN gradle wasmJsBrowserDistribution --no-daemon

FROM nginx:alpine
COPY --from=builder /home/gradle/src/composeApp/build/dist/wasmJs/productionExecutable/ /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

```

-   **Stage 1 (Builder):** Uses a Gradle image to compile the Kotlin Compose Web app to Wasm.
-   **Stage 2 (Nginx):** Serves the built static files using an Nginx container.

### Docker Compose

```yaml
version: '3.9'
services:
  kotlin-wasm-app:
    networks:
      - frontend
    container_name: test-app
    hostname: test-app
    restart: always
    build: .
    ports:
      - "8000:80"
    volumes:
      - ./:/codex

networks:
  frontend:
    name: custom_network
    driver: bridge

```

-   Defines a **service** (`kotlin-wasm-app`) that:
  -   Uses a custom **network** (`custom_network`)
  -   Maps **port 8000** on the host to **port 80** in the container
  -   Auto-restarts if it crashes
