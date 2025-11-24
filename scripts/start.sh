#!/bin/bash
# shellcheck source=scripts/functions.sh
source "/home/steam/server/functions.sh"

cd /7d2d || exit

# if GENERATE_SETTINGS IS FALSE then we will not generate the settings
if [ "$GENERATE_SETTINGS" = "true" ]; then
  LogAction "Compiling Server settings"
  /home/steam/server/compile-server-settings.sh
elif [ "$GENERATE_SETTINGS" = "false" ]; then
  LogWarn "GENERATE_SETTINGS=false, not overwriting settings"
fi

# Archive any existing log files to Logs folder so we tail the right one later
find /7d2d -maxdepth 1 -name "output_log__*.txt" -exec mv {} /7d2d/Logs/ \;

LogAction "Starting server"
su steam -c "/7d2d/startserver.sh -configfile=/7d2d/serverconfig.xml"

LOG_FILE=$(ls /7d2d/output_log__*.txt 2>/dev/null | head -1)
if [ -n "$LOG_FILE" ]; then
    tail -f "$LOG_FILE"
else
    echo "Log file not found, waiting for server process..."
    wait $SERVER_PID
fi