#!/bin/bash
lfcli() {
  lflog_cli_call "$*"

  local cmd="$1" && shift 
  [[ -z "$cmd" ]] && lfraise "Empty command, see help"
  
  local cmd_file="$(lf_get_cmd_file "$cmd")"
  local cmd_type="$(lf_is_opt "$1" && echo option || echo command)"
  [[ -z $cmd_file ]] && lfraise "Unknown $cmd_type: $cmd. See help"

  if lf_is_opt "$cmd"; then
    lf_call_opt_and_continue "$cmd_file" "$@"
  else
    lf_call_cmd "$cmd" "$cmd_file" "$@"
  fi
}

# Get corresponding script file for command or option
lf_get_cmd_file() { local dirs; lf_get_cmd_dirs dirs; find "${dirs[@]}" -mindepth 1 -type f -name "$1" -print -quit; }
# Command argument is an option if starts with -
lf_is_opt() { [ "${1:0:1}" == - ]; }
# Source options script in a subshell, then call lfcli again without option
lf_call_opt_and_continue() { ( source "$@"; lfcli "${@:2}" ); }

# Call script in an detached subshell with its own isolated call trace
# This ensure it will only have access exported variables and functions
# https://stackoverflow.com/a/51903792
lf_call_cmd() {
  local cmd="$1" file="$2" args=("${@:3}")
  
  if [[ "$(realpath --relative-to="$LITEFARM_CLI_COMMANDS_DIR" "$file")" == "docker"* ]] && \
    ! docker ps > /dev/null 2>&1; then 
    echo inner?
    lfraise "Start docker service to run a docker command"
  fi

  if [[ -x "$file" ]]; then
    ( lf_update_call_trace "$cmd" && "$file" "${args[@]}" )
  else
    lfraise "Command file missing executable permissions. Add it with:\n  chmod +x \"$file\"" 
  fi
}

# Store call trace in a space separated string
lf_update_call_trace() { lf_call_trace=($lf_call_trace $1); export "${lf_call_trace[*]}"; }

# As arrays cannot be exported in bash. We instead export a function
# that assigns the appropriate array of command directories to a given variable.
# The order of the command directories determines priority in case of duplicate cmds
# Having the core commands last makes it possible to overwrite commands 
lf_get_cmd_dirs() {
  declare -n assign_ref="$1"
  [ -n "$LITEFARM_USER_COMMANDS_DIR" ] && assign_ref+=("$LITEFARM_USER_COMMANDS_DIR")
  assign_ref+=("$LITEFARM_CLI_COMMANDS_DIR")
}
