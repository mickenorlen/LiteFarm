#!/bin/bash

# Using npm bin file to run directly as root because:
# - Avoid warning for insufficient access to root home folder
# - npm run also prevents process chaining, so we can't fallback to shell
serve() { # Start server
  pids=($(pidof node))

  if [[ -n ${pids[@]} ]]; then
    # Server is running
    if [[ $1 == "-f" ]]; then
      kill -9 ${pids[@]}
    else
      echo "Server running, add -f to force"
      return
    fi
  fi

  clear
  echo "NODE_ENV: $NODE_ENV" 
  if [[ $NODE_ENV == development ]]; then
    "$(npm bin)/nodemon" --inspect=0.0.0.0:9230 /usr/src/app/src/server.js
  else
    "$(npm bin)/nodemon" /usr/src/app/src/server.js
  fi
}

install() { # Install dependencies
  echo "NODE_ENV: $NODE_ENV"
  npm install
}

migrate() { # Migrate db
  npm run migrate:dev:db
}

source /root/scripts/functions.sh
