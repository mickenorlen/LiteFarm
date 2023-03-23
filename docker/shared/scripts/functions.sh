#!/bin/bash
help() { # List available functions
  cat /root/.bashrc /root/scripts/functions.sh | grep -v "^\(#\|\.\|source\|\s*$\)"
}

# https://superuser.com/a/1667623
clear() ( # Clear screen while preserving scrollback
   if [ "$#" -ne 0 ]; then
      command clear "$@"
      exit
   fi
   h="$(tput lines 2>/dev/null)"
   if [ "$?" -eq 0 ]; then
      until [ "$h" -le 0 ]; do
         printf '\n'
         h=$((h-1))
      done
   fi
   command clear -x
)
