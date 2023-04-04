
#!/bin/bash
# Build docker-compose file that overwrites startup command
# with the idle cmd for each specified service eg:
#
# services:
#   $service:
#     command: $idle_cmd
#   ...
#
# Returns path to built file in stdout
#
# Example use: 
# idle_yml="$(build_idle_yml web api)"
# docker-compose -f docker-compose.base.yml -f "$idle_yml"

build_idle_yml() {
  [ $# == 0 ] && return 1 || local services=("$@")
  lflog "Building docker-compose.idle.yml for services: ${services[@]}"
  local idle_msg="[lfcli] Started idle"
  local idle_cmd="sh -c \"echo $idle_msg && tail -f /dev/null\""
  local output_file="$LITEFARM_CLI_BUILD_DIR/docker-compose.idle.yml"

  local content="services:"
  local service; for service in "${services[@]}"; do
    content+="
  ${service}:
    command: $idle_cmd"
  done

  # Ensure build dir created and build file
  mkdir -p "$LITEFARM_CLI_BUILD_DIR"
  echo -e "$content" > "$output_file"

  echo "$output_file"
}

