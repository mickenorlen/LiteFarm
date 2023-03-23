#!/bin/bash
title() {
  local msg="$(bold)$1$(normal)"
  [[ -n $2 ]] && msg+="$(italic) $2$(normal)"
  echo -e "$msg"
}

bold() {
  echo '\033[1m'
}

italic() {
	echo '\e[3m'
}

normal() {
	echo '\033[0m'
}
