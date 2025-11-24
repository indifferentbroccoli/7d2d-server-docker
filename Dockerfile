FROM cm2network/steamcmd:root

RUN apt-get update && apt-get install -y --no-install-recommends \
    xmlstarlet \
    gettext-base \
    procps \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

LABEL maintainer="support@indifferentbroccoli.com" \
      name="indifferentbroccoli/7d2d-server-docker" \
      github="https://github.com/indifferentbroccoli/7d2d-server-docker" \
      dockerhub="https://hub.docker.com/r/indifferentbroccoli/7d2d-server-docker"

ENV HOME=/home/steam \
    SERVER_PORT=26900 \
    TELNET_PORT=8081 \
    WEB_DASHBOARD_PORT=8080 \
    PUID=1000 \
    PGID=1000 \
    GENERATE_SETTINGS=true

COPY ./scripts /home/steam/server/

COPY branding /branding

RUN mkdir -p /7d2d && \
    chmod +x /home/steam/server/*.sh

WORKDIR /home/steam/server

 HEALTHCHECK --start-period=5m \
    CMD pgrep -f "7DaysToDieServer" > /dev/null || exit 1

EXPOSE 26900/tcp 26900/udp 26901/udp 26902/udp 8080/tcp 8081/tcp

ENTRYPOINT ["/home/steam/server/init.sh"]
