#!/bin/bash
source "/home/steam/server/functions.sh"

config=/7d2d/serverconfig.xml

SERVER_MAX_PLAYER_COUNT=${SERVER_MAX_PLAYER_COUNT:-$SERVER_MAX_PLAYERS}
WEB_DASHBOARD_PORT=${WEB_DASHBOARD_PORT:-$CONTROL_PANEL_PORT}

skipped=()

apply_setting() {
    local property=$1
    local value=$2
    if [ -z "$value" ]; then value="${!property}"; fi
    if [ -z "$value" ]; then return; fi
    case "$property" in
        ServerDescription|ServerLoginConfirmationText)
            value=$(printf '%s' "$value" | sed -e 's/\\\\n/\n/g' -e 's/\\n/\n/g') ;;
    esac
    if grep -q "property name=\"$property\"" "$config"; then
        xmlstarlet ed -L -u "//property[@name='$property']/@value" -v "$value" "$config"
    else
        skipped+=("$property")
    fi
}

apply_setting "ServerName"                         "$SERVER_NAME"
apply_setting "ServerDescription"                  "$SERVER_DESCRIPTION"
apply_setting "ServerWebsiteURL"                   "$SERVER_WEBSITE_URL"
apply_setting "ServerPassword"                     "$SERVER_PASSWORD"
apply_setting "ServerLoginConfirmationText"        "$SERVER_LOGIN_CONFIRMATION_TEXT"
apply_setting "Region"                             "$REGION"
apply_setting "Language"                           "$LANGUAGE"
apply_setting "ServerPort"                         "$SERVER_PORT"
apply_setting "ServerVisibility"                   "$SERVER_VISIBILITY"
apply_setting "ServerDisabledNetworkProtocols"     "$SERVER_DISABLED_NETWORK_PROTOCOLS"
apply_setting "ServerMaxWorldTransferSpeedKiBs"    "$SERVER_MAX_WORLD_TRANSFER_SPEED_KIBS"
apply_setting "ServerMaxPlayerCount"               "$SERVER_MAX_PLAYER_COUNT"
apply_setting "ServerReservedSlots"                "$SERVER_RESERVED_SLOTS"
apply_setting "ServerReservedSlotsPermission"      "$SERVER_RESERVED_SLOTS_PERMISSION"
apply_setting "ServerAdminSlots"                   "$SERVER_ADMIN_SLOTS"
apply_setting "ServerAdminSlotsPermission"         "$SERVER_ADMIN_SLOTS_PERMISSION"
apply_setting "WebDashboardEnabled"                "$WEB_DASHBOARD_ENABLED"
apply_setting "WebDashboardPort"                   "$WEB_DASHBOARD_PORT"
apply_setting "WebDashboardUrl"                    "$WEB_DASHBOARD_URL"
apply_setting "EnableMapRendering"                 "$ENABLE_MAP_RENDERING"
apply_setting "TelnetEnabled"                      "$TELNET_ENABLED"
apply_setting "TelnetPort"                         "$TELNET_PORT"
apply_setting "TelnetPassword"                     "$TELNET_PASSWORD"
apply_setting "TelnetFailedLoginLimit"             "$TELNET_FAILED_LOGIN_LIMIT"
apply_setting "TelnetFailedLoginsBlocktime"        "$TELNET_FAILED_LOGINS_BLOCKTIME"
apply_setting "TerminalWindowEnabled"              "$TERMINAL_WINDOW_ENABLED"
apply_setting "AdminFileName"                      "$ADMIN_FILE_NAME"
apply_setting "ServerAllowCrossplay"               "$SERVER_ALLOW_CROSSPLAY"
apply_setting "EACEnabled"                         "$EAC_ENABLED"
apply_setting "IgnoreEOSSanctions"                 "$IGNORE_EOS_SANCTIONS"
apply_setting "HideCommandExecutionLog"            "$HIDE_COMMAND_EXECUTION_LOG"
apply_setting "MaxUncoveredMapChunksPerPlayer"     "$MAX_UNCOVERED_MAP_CHUNKS_PER_PLAYER"
apply_setting "PersistentPlayerProfiles"           "$PERSISTENT_PLAYER_PROFILES"
apply_setting "MaxChunkAge"                        "$MAX_CHUNK_AGE"
apply_setting "SaveDataLimit"                      "$SAVE_DATA_LIMIT"
apply_setting "GameWorld"                          "$GAME_WORLD"
apply_setting "WorldGenSeed"                       "$WORLD_GEN_SEED"
apply_setting "WorldGenSize"                       "$WORLD_GEN_SIZE"
apply_setting "GameName"                           "$GAME_NAME"
apply_setting "GameMode"                           "$GAME_MODE"
apply_setting "CameraRestrictionMode"              "$CAMERA_RESTRICTION_MODE"
apply_setting "SandboxCode"                        "$SANDBOX_CODE"
apply_setting "GameDifficulty"                     "$GAME_DIFFICULTY"
apply_setting "BlockDamagePlayer"                  "$BLOCK_DAMAGE_PLAYER"
apply_setting "BlockDamageAI"                      "$BLOCK_DAMAGE_AI"
apply_setting "BlockDamageAIBM"                    "$BLOCK_DAMAGE_AI_BM"
apply_setting "XPMultiplier"                       "$XP_MULTIPLIER"
apply_setting "PlayerSafeZoneLevel"                "$PLAYER_SAFE_ZONE_LEVEL"
apply_setting "PlayerSafeZoneHours"                "$PLAYER_SAFE_ZONE_HOURS"
apply_setting "BuildCreate"                        "$BUILD_CREATE"
apply_setting "DayNightLength"                     "$DAY_NIGHT_LENGTH"
apply_setting "DayLightLength"                     "$DAY_LIGHT_LENGTH"
apply_setting "BiomeProgression"                   "$BIOME_PROGRESSION"
apply_setting "StormFreq"                          "$STORM_FREQ"
apply_setting "DeathPenalty"                       "$DEATH_PENALTY"
apply_setting "DropOnDeath"                        "$DROP_ON_DEATH"
apply_setting "DropOnQuit"                         "$DROP_ON_QUIT"
apply_setting "BedrollDeadZoneSize"                "$BEDROLL_DEAD_ZONE_SIZE"
apply_setting "BedrollExpiryTime"                  "$BEDROLL_EXPIRY_TIME"
apply_setting "AllowSpawnNearFriend"               "$ALLOW_SPAWN_NEAR_FRIEND"
apply_setting "MaxSpawnedZombies"                  "$MAX_SPAWNED_ZOMBIES"
apply_setting "MaxSpawnedAnimals"                  "$MAX_SPAWNED_ANIMALS"
apply_setting "ServerMaxAllowedViewDistance"       "$SERVER_MAX_ALLOWED_VIEW_DISTANCE"
apply_setting "MaxQueuedMeshLayers"                "$MAX_QUEUED_MESH_LAYERS"
apply_setting "EnemySpawnMode"                     "$ENEMY_SPAWN_MODE"
apply_setting "EnemyDifficulty"                    "$ENEMY_DIFFICULTY"
apply_setting "ZombieFeralSense"                   "$ZOMBIE_FERAL_SENSE"
apply_setting "ZombieMove"                         "$ZOMBIE_MOVE"
apply_setting "ZombieMoveNight"                    "$ZOMBIE_MOVE_NIGHT"
apply_setting "ZombieFeralMove"                    "$ZOMBIE_FERAL_MOVE"
apply_setting "ZombieBMMove"                       "$ZOMBIE_BM_MOVE"
apply_setting "BloodMoonFrequency"                 "$BLOOD_MOON_FREQUENCY"
apply_setting "BloodMoonRange"                     "$BLOOD_MOON_RANGE"
apply_setting "BloodMoonWarning"                   "$BLOOD_MOON_WARNING"
apply_setting "BloodMoonEnemyCount"                "$BLOOD_MOON_ENEMY_COUNT"
apply_setting "LootAbundance"                      "$LOOT_ABUNDANCE"
apply_setting "LootRespawnDays"                    "$LOOT_RESPAWN_DAYS"
apply_setting "AirDropFrequency"                   "$AIR_DROP_FREQUENCY"
apply_setting "AirDropMarker"                      "$AIR_DROP_MARKER"
apply_setting "PartySharedKillRange"               "$PARTY_SHARED_KILL_RANGE"
apply_setting "PlayerKillingMode"                  "$PLAYER_KILLING_MODE"
apply_setting "LandClaimCount"                     "$LAND_CLAIM_COUNT"
apply_setting "LandClaimSize"                      "$LAND_CLAIM_SIZE"
apply_setting "LandClaimDeadZone"                  "$LAND_CLAIM_DEAD_ZONE"
apply_setting "LandClaimExpiryTime"                "$LAND_CLAIM_EXPIRY_TIME"
apply_setting "LandClaimDecayMode"                 "$LAND_CLAIM_DECAY_MODE"
apply_setting "LandClaimOnlineDurabilityModifier"  "$LAND_CLAIM_ONLINE_DURABILITY_MODIFIER"
apply_setting "LandClaimOfflineDurabilityModifier" "$LAND_CLAIM_OFFLINE_DURABILITY_MODIFIER"
apply_setting "LandClaimOfflineDelay"              "$LAND_CLAIM_OFFLINE_DELAY"
apply_setting "DynamicMeshEnabled"                 "$DYNAMIC_MESH_ENABLED"
apply_setting "DynamicMeshLandClaimOnly"           "$DYNAMIC_MESH_LAND_CLAIM_ONLY"
apply_setting "DynamicMeshLandClaimBuffer"         "$DYNAMIC_MESH_LAND_CLAIM_BUFFER"
apply_setting "DynamicMeshMaxItemCache"            "$DYNAMIC_MESH_MAX_ITEM_CACHE"
apply_setting "TwitchServerPermission"             "$TWITCH_SERVER_PERMISSION"
apply_setting "TwitchBloodMoonAllowed"             "$TWITCH_BLOOD_MOON_ALLOWED"
apply_setting "QuestProgressionDailyLimit"         "$QUEST_PROGRESSION_DAILY_LIMIT"

chown steam:steam "$config"

if [ ${#skipped[@]} -gt 0 ]; then
    LogWarn "${#skipped[@]} settings are not in this version's serverconfig.xml and were skipped:"
    LogWarn "  ${skipped[*]}"
    LogWarn "  Gameplay settings are set through SANDBOX_CODE on this game version."
fi

LogSuccess "Server settings applied to $config"
