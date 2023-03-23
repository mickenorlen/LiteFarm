cmd=$1 && shift

# Fall back to running docker script if found
if [[ -f "$LITEFARM_CLI_DOCKER_DIR/$cmd" ]]; then
  if docker ps > /dev/null 2>&1; then
    "$LITEFARM_CLI_DOCKER_DIR/$cmd" "$@"
  else
    echo "Cannot connect to the Docker daemon. Is the service running?"
  fi
elif [[ -z $cmd ]]; then
  echo "Empty command, see help"
else
  echo "Unknown command, see help"
fi
