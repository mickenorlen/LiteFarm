#!/bin/bash
app_dir="/usr/src/app"
# Run npm bin file directly instead of using npm run because:
# - Avoid warnings for insufficient access to root home folder
# - npm run also prevents process chaining
# - Makes sense to run bash commands directly as we are already in bash
npm_run() { "$(npm bin)/$1" "${@:2}"; }

install() { echo "NODE_ENV: $NODE_ENV" && npm install; } # Install dependencies
migrate() { npm_run knex migrate:latest --knexfile="$app_dir/.knex/knexfile.js"; } # Migrate db
migrate_rollback() { npm_run knex migrate:rollback --knexfile="$app_dir/.knex/knexfile.js"; } # Rollback db

# Start server
serve() {
  pids=($(pidof node))
  
  if [ -n "${pids[*]}" ]; then # Server is running
    if [ "$1" == "-f" ]; then
      kill -9 ${pids[@]}
    else
      echo "Server running, add -f to force" && return 1
    fi
  fi

  clear; echo "NODE_ENV: $NODE_ENV"

  if [[ $NODE_ENV == development ]]; then
    npm_run nodemon --inspect=0.0.0.0:9230 /usr/src/app/src/server.js
  else
    npm_run nodemon /usr/src/app/src/server.js
  fi
}

# https://superuser.com/a/1667623
clear() ( # Clear screen while preserving scrollback
  [ "$#" != 0 ] && command clear "$@" && exit
  h="$(tput lines 2>/dev/null)"
  until [ "$h" -le 0 ]; do printf '\n' && h=$((h-1)); done
  command clear -x
)
