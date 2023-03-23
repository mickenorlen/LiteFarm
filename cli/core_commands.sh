#!/bin/bash
# Core commands are always included
cmd=$1 && shift
case $cmd in
  help) # Print command help
    show_help;;
  config) # Print loaded config
    show_config;;
  *)
    return 1
esac
