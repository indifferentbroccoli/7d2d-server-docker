<!-- markdownlint-disable-next-line -->
![marketing_assets_banner](https://github.com/user-attachments/assets/b8b4ae5c-06bb-46a7-8d94-903a04595036)
[![GitHub License](https://img.shields.io/github/license/indifferentbroccoli/7d2d-server-docker?style=for-the-badge&color=6aa84f)](https://github.com/indifferentbroccoli/7d2d-server-docker/blob/main/LICENSE)
[![GitHub Release](https://img.shields.io/github/v/release/indifferentbroccoli/7d2d-server-docker?style=for-the-badge&color=6aa84f)](https://github.com/indifferentbroccoli/7d2d-server-docker/releases)
[![GitHub Repo stars](https://img.shields.io/github/stars/indifferentbroccoli/7d2d-server-docker?style=for-the-badge&color=6aa84f)](https://github.com/indifferentbroccoli/7d2d-server-docker)
[![Docker Pulls](https://img.shields.io/docker/pulls/indifferentbroccoli/7d2d-server-docker?style=for-the-badge&color=6aa84f)](https://hub.docker.com/r/indifferentbroccoli/7d2d-server-docker)

Game server hosting

Fast RAM, high-speed internet

Eat lag for breakfast

[Try our 7 Days to Die Server hosting!](https://indifferentbroccoli.com/7-days-to-die-server-hosting)

# 7 Days to Die Server Docker

> [!IMPORTANT]
> Using Docker Desktop with WSL2 on Windows will result in a very slow download!

## Server Requirements

| Resource | Minimum | Recommended |
|----------|---------|-------------|
| CPU      | 2 cores | 4+ cores    |
| RAM      | 8GB     | 12GB+       |
| Storage  | 15GB    | 30GB        |

## How to use

> [!IMPORTANT]
> .env settings will override the current settings in the `serverconfig.xml` file
> If you do not want that to happen, set GENERATE_SETTINGS=false

Copy the .env.example file to a new file called .env file. Then use either `docker compose` or `docker run`

> [!IMPORTANT]
> Please make sure to set a strong server password!

### Docker compose

> [!WARNING]
> When you want to shutdown the server, use `docker-compose down` to save the game and stop the server
> If you do not do this, the server may not save the game and you may lose progress.

Starting the server with Docker Compose:

```yaml
services:
  7d2d-server:
    image: indifferentbroccoli/7d2d-server-docker
    restart: unless-stopped
    container_name: 7d2d-server
    stop_grace_period: 30s
    ports:
      - '26900:26900/tcp'
      - '26900:26900/udp'
      - '26901:26901/udp'
      - '26902:26902/udp'
      - '8080:8080/tcp'
      - '8081:8081/tcp'
    environment:
      PUID: 1000
      PGID: 1000
      GENERATE_SETTINGS: true
    env_file:
      - .env.example
    volumes:
      - ./7d2d/server-data:/7d2d
      - ./7d2d/server-files:/home/steam/.local

```

Then run:

```bash
docker-compose up -d
```

### Docker Run

```bash
docker run -d \
    --restart unless-stopped \
    --name 7d2d-server \
    --stop-timeout 30 \
    -p 26900:26900/tcp \
    -p 26900:26900/udp \
    -p 26901:26901/udp \
    -p 26902:26902/udp \
    -p 8080:8080/tcp \
    -p 8081:8081/tcp \
    -e GENERATE_SETTINGS=true \
    --env-file .env \
    -v ./7d2d/server-data:/7d2d \
    -v ./7d2d/server-files:/home/steam/.local
    indifferentbroccoli/7d2d-server-docker
```

## Environment Variables

See the [.env.example](.env.example) file for all available environment variables.

### Building the image

You can build the image from the Dockerfile using the following command:

```bash
docker build -t indifferentbroccoli/7d2d-server-docker .
```


#### init.sh

Entrypoint of the container. This script will check if the server is installed and if not, it will install it.
Also has a term_handler function to catch SIGTERM signals to gracefully stop the server.
Features basic checks that will confirm if the server can be started.

#### start.sh

Starts the server with the settings from the .env file.
Will also call the `compile-server-settings.sh` script to generate the server configuration.

#### install.scmd

Installs the server. This script will download the server files using SteamCMD and extract them to the server directory.

#### functions.sh

Contains functions that are used in the other scripts including logging utilities and system checks.

#### compile-server-settings.sh

Generates the `serverconfig.xml` file from the .env file.