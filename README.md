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
      FORCE_UPDATE: ${FORCE_UPDATE:-false}
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

Server and container settings. Game settings are in
[.env.example](.env.example).

| Variable | Default | Description |
|----------|---------|-------------|
| `PUID` | `1000` | User ID the server runs as |
| `PGID` | `1000` | Group ID the server runs as |
| `GENERATE_SETTINGS` | `true` | Apply the .env settings to `serverconfig.xml` on start |
| `FORCE_UPDATE` | `false` | Re-run DepotDownloader even when the server is already installed |
| `GAME_VERSION` | *(empty)* | Steam branch to install, e.g. `latest_experimental`. Empty installs the public branch |
| `GAME_VERSION_PASSWORD` | *(empty)* | Password for a private branch, if one is required |
| `SERVER_NAME` | `My Game Host` | Name shown in the server browser |
| `SERVER_DESCRIPTION` | `A 7 Days to Die server` | Description shown in the server browser. `\n` becomes a line break |
| `SERVER_WEBSITE_URL` | *(empty)* | Website link shown in the server browser |
| `SERVER_PASSWORD` | *(empty)* | Password required to join |
| `SERVER_LOGIN_CONFIRMATION_TEXT` | *(empty)* | Message players must confirm before joining |
| `SERVER_PORT` | `26900` | Game port. Also uses the next two UDP ports |
| `SERVER_VISIBILITY` | `2` | `0` not listed, `1` friends only, `2` public |
| `SERVER_DISABLED_NETWORK_PROTOCOLS` | `SteamNetworking` | Protocols to disable, comma separated |
| `SERVER_MAX_WORLD_TRANSFER_SPEED_KIBS` | `512` | World transfer speed cap in KiB/s |
| `SERVER_MAX_PLAYER_COUNT` | `8` | Maximum players |
| `SERVER_RESERVED_SLOTS` | `0` | Slots reserved for players with permission |
| `SERVER_RESERVED_SLOTS_PERMISSION` | `100` | Permission level needed for a reserved slot |
| `SERVER_ADMIN_SLOTS` | `0` | Slots reserved for admins on top of the player count |
| `SERVER_ADMIN_SLOTS_PERMISSION` | `0` | Permission level needed for an admin slot |
| `SERVER_ALLOW_CROSSPLAY` | `false` | Allow crossplay clients |
| `SERVER_MAX_ALLOWED_VIEW_DISTANCE` | `12` | Maximum view distance a client may request |
| `REGION` | `NorthAmericaEast` | Region the server is listed under |
| `LANGUAGE` | `English` | Server language |
| `WEB_DASHBOARD_ENABLED` | `true` | Enable the web dashboard |
| `WEB_DASHBOARD_PORT` | `8080` | Web dashboard port |
| `WEB_DASHBOARD_URL` | *(empty)* | External URL of the dashboard, if behind a proxy |
| `ENABLE_MAP_RENDERING` | `true` | Render the map for the web dashboard |
| `TELNET_ENABLED` | `true` | Enable the telnet console |
| `TELNET_PORT` | `8081` | Telnet port |
| `TELNET_PASSWORD` | *(empty)* | Telnet password. Empty allows local connections only |
| `TELNET_FAILED_LOGIN_LIMIT` | `10` | Failed telnet logins before an IP is blocked |
| `TELNET_FAILED_LOGINS_BLOCKTIME` | `10` | How long a blocked telnet IP stays blocked, in seconds |
| `TERMINAL_WINDOW_ENABLED` | `true` | Show the server terminal window |
| `ADMIN_FILE_NAME` | `serveradmin.xml` | Admin file name, relative to the saves folder |
| `EAC_ENABLED` | `true` | Enable Easy Anti-Cheat |
| `IGNORE_EOS_SANCTIONS` | `false` | Ignore Epic Online Services sanctions |
| `HIDE_COMMAND_EXECUTION_LOG` | `0` | `0` show all, `1` hide telnet/control panel, `2` also hide remote, `3` hide all |

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

#### functions.sh

Contains functions that are used in the other scripts including logging
utilities, system checks, the DepotDownloader install and graceful shutdown.

#### compile-server-settings.sh

Applies the .env settings to `/7d2d/serverconfig.xml` with `xmlstarlet`, one
`apply_setting` line per property.