#!/bin/bash
app_dir="/usr/src/app"
# Run npm bin file directly instead of using npm run because:
# - Avoid warnings for insufficient access to root home folder
# - npm run also prevents process chaining
# - Makes sense to run bash commands directly as we are already in bash
pnpm_run() { "$(pnpm bin)/$1" "${@:2}"; }

serve() { # Start server
  pids=($(pidof node))

  if [ -n "${pids[*]}" ]; then # Server is running
    if [ "$1" == "-f" ]; then
      kill -9 ${pids[@]}
    else
      echo "Server running, add -f to force" && return 1
    fi
  fi

  CYPRESS_COVERAGE=TRUE pnpm_run vite --host
}

  # Install dependencies
install() { pnpm install; }

  # Precompile assets
precompile() { NODE_OPTIONS=--max_old_space_size=3000 pnpm_run tsc && pnpm_run vite build; }
