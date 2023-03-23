#!/bin/bash
show_help() {
  local separation=15
  local indent=" "
  local msg=()

  msg+="$(title "User commands" "- $LITEFARM_CLI_COMMANDS_PATH" )\n"
  msg+="$(help_commands "$LITEFARM_CLI_COMMANDS_PATH" $separation $indent)"
  msg+="$(title "Core cli helpers")\n"
  msg+="$(help_commands "$LITEFARM_CLI_DIR/core_commands.sh" $separation $indent)"
  msg+="$(title "Core docker scripts")\n"
  msg+="$(help_docker $separation $indent)"

  echo -e "${msg[*]}"
}

show_config() {
  local msg=()
  msg+="LITEFARM_CLI_COMMANDS_PATH       $LITEFARM_CLI_COMMANDS_PATH\n"
  msg+="LITEFARM_DOCKER_DEFAULT_ENV      $LITEFARM_DOCKER_DEFAULT_ENV\n"
  msg+="LITEFARM_DOCKER_DEFAULT_SERVICE  $LITEFARM_DOCKER_DEFAULT_SERVICE\n"
  msg+="LITEFARM_DOCKER_START_ADMINER    $LITEFARM_DOCKER_START_ADMINER"

  echo -e "${msg[*]}"
}

help_commands() {
  local cmd_lines="$(cat "$1" | grep "^\s*[a-z0-9]*) #")"
  local cmds=($(echo "${cmd_lines[@]}" | cut -d ')' -f1 | xargs))
  local comments=(); readarray -t comments <<< "$(echo "${cmd_lines[@]}" | cut -d '#' -f2-)"
  local msg=()

  for i in $(seq 0 ${#cmds[@]}); do
    # sub_msg=( "${cmds[i]}" "${comments[i]:1}" )
    local msg+="$(printf "%-${2}s %s %.*s" "${indent}${cmds[i]}" "${comments[i]:1}")\n"
  done

  echo "${msg[*]}"
}

# Show info about docker commands
help_docker() {
  local docker="$LITEFARM_DOCKER_CLI_DIR"
  # https://stackoverflow.com/questions/48384979/sorting-find-command-by-filename
  local files=($(find $docker -maxdepth 1 -type f -printf '%f\t%p\n' | sort -k1 | cut -d$'\t' -f2))

  local file; for file in "${files[@]}"; do
    local sub_msg=("$(basename $file)") # name of file
    local sub_msg+=("$(sed -n '2p' "$file" | sed 's/^[# ]*//g')") # Just grabbing second line
    local msg+="$(printf "%-${1}s %s %.*s" "${indent}${sub_msg[@]}")\n"
  done

  echo "${msg[*]::-2}"
}

fallback_to_docker_scripts() {
  local cmd=$1 && shift

  # Fall back to running docker script if found
  if [[ -f "$LITEFARM_DOCKER_CLI_DIR/$cmd" ]]; then
    "$LITEFARM_DOCKER_CLI_DIR/$cmd" "$@"
  elif [[ -z $cmd ]]; then
    echo "Empty command, see help"
  else
    echo "Unknown command, see help"
  fi
}
