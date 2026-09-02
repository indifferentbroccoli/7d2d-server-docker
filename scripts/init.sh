#!/bin/bash
# shellcheck source=scripts/functions.sh
source "/home/steam/server/functions.sh"

LogAction "Set file permissions"

# if the user has not defined a PUID and PGID, throw an error and exit
if [ -z "${PUID}" ] || [ -z "${PGID}" ]; then
    LogError "PUID and PGID not set. Please set these in the environment variables."
    exit 1
else
    usermod -o -u "${PUID}" steam
    groupmod -o -g "${PGID}" steam
fi

chown -R steam:steam /7d2d /home/steam/

cat /branding

LogAction "Checking for compatibility issues"
if cpu_check && memory_check; then
    LogSuccess "Compatibility checks passed"
fi

install || exit 1

# shellcheck disable=SC2317
term_handler() {
    if ! shutdown_server; then
        kill -SIGTERM "$killpid"
    fi

    # Block until start.sh is gone so the game finishes saving before we exit
    tail --pid="$killpid" -f /dev/null 2>/dev/null
}

trap 'term_handler' SIGTERM

# Start the server
./start.sh &

killpid="$!"
wait "$killpid"