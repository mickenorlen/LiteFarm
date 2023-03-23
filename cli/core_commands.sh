#!/bin/bash
# Core commands are always included
cmd=$1 && shift

case $cmd in
  web) # Start webapp dev server
    lfcli dev -s web -i api -f "$@";;
  api) # Start api dev server
    lfcli dev -s api -i web -f "$@";;
  help) # Print command help
    show_help;;
  config) # Print loaded config
    show_config;;
  *)
    return 123
esac
