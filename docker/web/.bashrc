#!/bin/bash
# Prefer function over alias as they are callable from docker-compose with
# eg: bash -c '. /root/.bashrc; serve'

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

  pnpm dev
}

install() { # Install dependencies
  pnpm install;
}

precompile() { # Precompile assets
  pnpm run build; 
}

source /root/scripts/functions.sh
