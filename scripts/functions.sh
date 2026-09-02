#!/bin/bash

#================
# Log Definitions
#================
export LINE='\n'                        # Line Break
export RESET='\033[0m'                  # Text Reset
export WhiteText='\033[0;37m'           # White

# Bold
export RedBoldText='\033[1;31m'         # Red
export GreenBoldText='\033[1;32m'       # Green
export YellowBoldText='\033[1;33m'      # Yellow
export CyanBoldText='\033[1;36m'        # Cyan
#================
# End Log Definitions
#================

LogInfo() {
  Log "$1" "$WhiteText"
}
LogWarn() {
  Log "$1" "$YellowBoldText"
}
LogError() {
  Log "$1" "$RedBoldText"
}
LogSuccess() {
  Log "$1" "$GreenBoldText"
}
LogAction() {
  Log "$1" "$CyanBoldText" "====" "===="
}
Log() {
  local message="$1"
  local color="$2"
  local prefix="$3"
  local suffix="$4"
  printf "$color%s$RESET$LINE" "$prefix$message$suffix"
}

install() {

  if [ -f /7d2d/startserver.sh ] && [ "$FORCE_UPDATE" != "true" ]; then
    LogInfo "Server files already present, skipping update (set FORCE_UPDATE=true to override)"
    return 0
  fi

  LogAction "Starting server install"
  LogInfo "Installing 7 Days to Die Dedicated Server (branch: ${GAME_VERSION:-public})"

  local beta=()
  if [ -n "$GAME_VERSION" ]; then
    beta=(-beta "$GAME_VERSION")
    [ -n "$GAME_VERSION_PASSWORD" ] && beta+=(-betapassword "$GAME_VERSION_PASSWORD")
  fi

  /depotdownloader/DepotDownloader \
    -app 294420 \
    "${beta[@]}" \
    -dir /7d2d \
    -validate

  if [ ! -f /7d2d/startserver.sh ]; then
    LogError "DepotDownloader finished but /7d2d/startserver.sh is missing, the install failed"
    return 1
  fi

  chmod +x /7d2d/startserver.sh /7d2d/7DaysToDieServer.x86_64 2>/dev/null
  chown -R steam:steam /7d2d

  LogSuccess "Server install complete"
}

# Attempt to shutdown the server gracefully
# Returns 0 if it is shutdown
# Returns 1 if it is not able to be shutdown
shutdown_server() {
  local return_val=0
  LogAction "Attempting graceful server shutdown"

  local pid
  pid=$(pgrep -f "7DaysToDieServer.x86_64")

  if [ -n "$pid" ]; then
    kill -SIGTERM "$pid"

    local count=0
    while [ $count -lt 30 ] && kill -0 "$pid" 2>/dev/null; do
      sleep 1
      count=$((count + 1))
    done

    if kill -0 "$pid" 2>/dev/null; then
      LogWarn "Server did not shutdown gracefully, forcing shutdown"
      return_val=1
    else
      LogSuccess "Server shutdown gracefully"
    fi
  else
    LogWarn "Server process not found"
    return_val=1
  fi

  return "$return_val"
}

cpu_check(){
  if [[ $(lscpu | grep 'Model name:' | sed 's/Model name:[[:space:]]*//g') = "Common KVM processor" ]]; then
    LogWarn " Your CPU model is configured as \"Common KVM processor\". This may cause issues with the server."
    return 1
  else
    return 0
  fi
}

memory_check() {
  RAMAVAILABLE=$(awk '/MemAvailable/ {printf( "%d\n", $2 / 1024000 )}' /proc/meminfo)
  if [ "$RAMAVAILABLE" -lt "8" ]; then
    LogWarn "You have less than 8GB of RAM available. This may cause issues with the server."
    return 1
  else
    return 0
  fi
}