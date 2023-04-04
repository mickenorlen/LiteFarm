#!/bin/bash
validate_service() {
  lflog "Validating service: $1"
  local service="$1"
  local services=($(lfcli compose config --services))

  if [[ -z $service ]]; then
    local error="No service provided"
  elif [[ " ${services[*]} " != *" $service "* ]]; then
    local error="Undefined service: $service"
  fi

  [[ -z $error ]] || lfraise "$error. Defined services: ${services[*]}"  
}

# Takes space separated service strings of services and supported services
validate_service_supported() {
  [[ -z "$1" ]] && lfraise "No service provided"
  local service services=($1) supported_services=($2)

  for service in ${services[@]}; do
    if [[ " ${supported_services[*]} " != *" $service "* ]]; then 
      lfraise "Unsupported services: $service. Supported services: ${supported_services[@]}"
    fi
  done; return
}
