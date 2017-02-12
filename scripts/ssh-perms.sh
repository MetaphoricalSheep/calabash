__internal_ssh_perms_usage() {
  output__tell__message "<info>Usage</>"
  output__tell__message "<comment>ssh-perms.sh</>"
  output__tell__message "Sets the permissions for your ~/.ssh folder"
  output__tell__message "<comment>  -s|--silent</> - don't output anything (except errors)"
  output__tell__message "<comment>  -h|--help</>   - display this help section"

  exit 1
}


__internal_ssh_perms_main() {
  local _silent=false

  params="$(getopt -o sh -l silent,help --name "$(basename "$0")" -- "$@")"
  eval set -- "$params"
  unset params

  while true; do
    case "$1" in
      -s|--silent)
        _silent=true
        ;;
      --)
        shift
        break;;
      -h|--help|*)
        __internal_configure_git_usage
        shift
        break;;
    esac
    shift
  done

  if ! "$_silent"; then
    output__tell__fancyTitle "Setting up your ssh permissions" "ssh-perms" "fg=white;bg=c_5"
    output__tell__message "<question>Permissions:</>"
    output__tell__message "<info>~/.ssh/</>       -  <comment>700</>"
    output__tell__message "<info>~/.ssh/*</>      -  <comment>600</>"
    output__tell__message "<info>~/.ssh/*.pub</>  -  <comment>644</>"
  fi

  chmod 700 ~/.ssh/
  chmod 600 ~/.ssh/*
  chmod 644 ~/.ssh/*.pub
}

__internal_ssh_perms_main "$@"
