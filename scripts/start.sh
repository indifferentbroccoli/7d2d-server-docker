#!/bin/bash
# shellcheck source=scripts/functions.sh
source "/home/steam/server/functions.sh"

cd /7d2d || exit 1

if [ ! -f /7d2d/serverconfig.xml ]; then
    LogError "serverconfig.xml not found in /7d2d"
    exit 1
fi

if [ "$GENERATE_SETTINGS" = "true" ]; then
  LogAction "Compiling Server settings"
  /home/steam/server/compile-server-settings.sh
elif [ "$GENERATE_SETTINGS" = "false" ]; then
  LogWarn "GENERATE_SETTINGS=false, not overwriting settings"
fi

mkdir -p /7d2d/Logs
chown steam:steam /7d2d/Logs
find /7d2d -maxdepth 1 -name "output_log__*.txt" -exec mv {} /7d2d/Logs/ \;

LogAction "Starting server"
su steam -c "/7d2d/startserver.sh -configfile=/7d2d/serverconfig.xml" &
SERVER_PID=$!

sleep 5
LOG_FILE=$(ls /7d2d/output_log__*.txt 2>/dev/null | head -1)
if [ -n "$LOG_FILE" ]; then
    LogInfo "Tailing $LOG_FILE"
    tail -n +1 -f --pid="$SERVER_PID" "$LOG_FILE" &
else
    LogWarn "Log file not found, waiting for the server process"
fi

wait "$SERVER_PID"
