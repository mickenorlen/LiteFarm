#!/bin/bash

# Static base variables 
export LITEFARM_REPO_PATH="$(dirname $(cd $(dirname "$0") && pwd))"
export LITEFARM_CLI_DIR="$LITEFARM_REPO_PATH/cli"
export LITEFARM_CLI_DOCKER_DIR="$LITEFARM_CLI_DIR/docker"
# Make lfcli callable for internal scripts
lfcli() { "$LITEFARM_CLI_DIR/lfcli" "$@"; }; export -f lfcli

# These variables can be overwritten by developers
# Add your own commands by specifying a command file path
# Use core_commands.sh as a template  
export LITEFARM_CLI_USER_COMMANDS_PATH="${LITEFARM_CLI_USER_COMMANDS_PATH}"
# Default docker env can be changed. Useful when working with staging/production
export LITEFARM_DOCKER_DEFAULT_ENV=${LITEFARM_DOCKER_DEFAULT_ENV-dev}
# Default service can be changed from web to eg api
export LITEFARM_DOCKER_DEFAULT_SERVICE=${LITEFARM_DOCKER_DEFAULT_SERVICE-web}
# Always include adminer db manager at localhost:8080
export LITEFARM_DOCKER_START_ADMINER=${LITEFARM_DOCKER_START_ADMINER-false}


