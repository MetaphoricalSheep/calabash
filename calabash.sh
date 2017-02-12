#!/usr/bin/env bash

# Your project description here

# Enable unofficial strict mode
set -euo pipefail
IFS=$'\n\t'


# Including unabashed framework
__DIR__=$(dirname $(readlink -f "${BASH_SOURCE[0]}"))
. "$__DIR__"/.unabashed/unabashed.sh


__PROJECT__=calabash
__SCRIPTS__=()


usage() {
  output__tell__message "<info>Usage</>"
  output__tell__message "<comment>$__PROJECT__ <cmd> [cmd params]"
  output__tell__message "Call calabash with the cmd you would like to execute"
  output__tell__message "<comment>$__PROJECT__ <cmd> --help"
  output__tell__message "Display usage of the specified cmd."

  exit 1
}

output__tell__fancyTitle "A collection of scripts to make your life easier." "$__PROJECT__" "fg=white;bg=c_22"

params="$(getopt -o sh -l silent,help --name "$(basename "$0")" -- "$@")"

if [ $? != 0 ]; then
    usage
fi


eval set -- "$params"
unset params

SILENT=false

while true; do
  case "$1" in
    -s|--silent)
      SILENT=true
      ;;
    --)
      shift
      break;;
    -h|--help|*)
      usage
      shift
      break;;
  esac
  shift
done


__internal_get_scripts() {
  for file in `find "./scripts/" -maxdepth 1 -name '*.sh'`; do
    __SCRIPTS__+=("$file")
  done
}


__internal_list_scripts() {
  output__tell__message "<comment>Available scripts:</>"
  for script in ${__SCRIPTS__[*]}; do
    output__tell__message "<info>    -  $(basename "$script")</>"
  done
}


main() {
  __internal_get_scripts

  if helpers__empty "${1:-}"; then
    __internal_list_scripts
    exit 0
  fi

  local _cmd=$1

  for script in ${__SCRIPTS__[*]}; do
    if [[ "$script" == *"$_cmd" ]]; then
      . ./scripts/"$_cmd"
      exit 0
    fi
  done
      
  output__tell__error "The script you are trying to run does not exist!"
  __internal_list_scripts
  exit 1
}


main "$@"
