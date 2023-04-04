# Standard argument error
lfraise_invalid_arg() {
  lfraise "Invalid argument: $1"
}

lfraise() {
  echo -e "$(lferrorstyle "Error:") $*" && exit 1
}
