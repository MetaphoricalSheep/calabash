__internal_update_os_usage() {
  output__tell__message "<info>Usage</>"
  output__tell__message "<comment>update-os</>"
  output__tell__message "Updates your Linux distro."
  output__tell__message "<comment>  -d|--dist-upgrade</>  - run dist-upgrade"
  output__tell__message "<comment>  -s|--silent</>        - don't output anything (except errors)"
  output__tell__message "<comment>  -n|--no-loader</>     - don't show the loader"
  output__tell__message "<comment>  -h|--help</>          - display this help section"

  exit 1
}


__internal_update_os_main() {
  local _silent=false
  local _dist_upgrade=false
  local _no_loader=false

  params="$(getopt -o dsnh -l dist-upgrade,silent,no-loader,help --name "$(basename "$0")" -- "$@")"
  eval set -- "$params"
  unset params

  while true; do
    case "$1" in
      -s|--silent)
        _silent=true
        ;;
      -d|--dist-upgrade)
        _dist_upgrade=true
        ;;
      -n|--no-loader)
        _no_loader=true
        ;;
      --)
        shift
        break;;
      -h|--help|*)
        __internal_update_os_usage
        shift
        break;;
    esac
    shift
  done
  
  if ! "$_silent"; then
    output__tell__fancyTitle "update your Linux distro" "update-os" "fg=white;bg=c_166"
  fi

  check_root
  
  local _cmd="sudo sh -c -- 'apt-get update -y && apt-get upgrade -y && apt-get autoremove -y && apt-get autoclean -y'"

  if [[ "$_dist_upgrade" == true ]]; then
    _cmd+=" && apt-get dist-upgrade -y"
  fi

  if [[ "$_silent" == true ]]; then
    eval "$_cmd" >> /dev/null
  elif [[ "$_no_loader" == true ]]; then
    eval "$_cmd"
  else
    eval "$_cmd" >> /dev/null 2>&1 &
    output__tell__message "<comment>  ➜  Updating</>"
    output__tell__loader 18
    output__cursor__forward 18
    output__tell__message "<info>[ Done ]</>"
  fi
}

__internal_update_os_main "$@"
