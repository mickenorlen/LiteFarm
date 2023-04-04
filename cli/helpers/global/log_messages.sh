#!/bin/bash
#
# Log messages are classified as diagnostic output and redirected to stderr
# https://unix.stackexchange.com/a/331620
#
# This is important to avoid polluting stdout, eg: 
#
# services="$(lfcli -v compose config --services)"
# echo $services # Does not include log messages in captured output
#
lflog() {
  local msg cmds=($lf_call_trace)
  # Indent command name based on call trace depth
  local indent n; for (( n=0; n<$((${#cmds[@]} - 1)); n++)); do
    indent+=" "
  done

  # Aligns message 20 characters in and redirect log output to stderr. 
  echo -e "$(printf "%-20s %s" "$indent$(lftitle ${cmds[-1]})" "$(lfmsg "$*")")" >&2
}

# Special log style for logging called commands like docker-compose
lflog_cmd() { lflog "$(lfcmdstyle "$*")"; }
# Special log style for lfcli call log, only shown for nested calls
lflog_cli_call() { [[ -n "$lf_call_trace" ]] && lflog "$(lfclistyle "lfcli $*")"; }
# Dedicated debug logging makes it easier to see, find and clean out when done
lfdebug() { lflog "$(lfdebugstyle "[Debug] $*")"; }
lfwarn() { lflog "$(lfwarnstyle "Warning: $*")"; }

# Text formats
lftitle() { echo -e "$lfbold$*$lfnormal"; }
lfsubtitle() { echo -e "$lfbold$lfblue$*$lfnormal"; }
lfmsg() { echo -e "$lfblue$*$lfnormal"; }
lfcmdstyle() { echo -e "$lfnormal$*"; }
lfclistyle() { echo -e "$lfgreen$*$lfnormal";}
lferrorstyle() { echo -e "$lfbold$lfred$*$lfnormal"; }
lfwarnstyle() { echo -e "$lfyellow$*$lfnormal"; }
lfcommentstyle() { echo -e "$lfgrey$*$lfnormal"; }
lfdebugstyle() { echo -e "$lfbold$lfblue$*$lfnormal"; }
lfbold='\033[1m'
lfblue='\e[34m'
lfnormal='\033[0m'
lfgreen='\e[36m'
lforange='\e[32m'
lfred='\e[31m'
lfgrey='\e[38m'
