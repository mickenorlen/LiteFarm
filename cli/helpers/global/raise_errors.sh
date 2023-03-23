#!/bin/bash
# Standard argument error
lfraise() {
  echo -e "$(lferrorstyle "Error:") $@" && exit 1
}

lfraise_invalid_arg() {
  lfraise "Invalid argument: $@"
}
