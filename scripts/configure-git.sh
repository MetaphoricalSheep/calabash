__internal_configure_git_usage() {
  tellMessage "<info>Usage</>"
  tellMessage "<comment>configure-git.sh</>"
  tellMessage "Configures aliases for git and sets your email address and name."
  tellMessage "Email address and name is read from the config file."
  tellMessage "Specified email address or name will take priority."
  tellMessage "<comment>  -s|--silent</> - don't output anything (except errors)"
  tellMessage "<comment>  -e|--email</>  - override the email address config."
  tellMessage "<comment>  -n|--name</>   - override the name config."
  tellMessage "<comment>  -h|--help</>   - display this help section"

  exit 1
}

__internal_configure_git_main() {
  local _silent=false
  local _email="${git__email:-}"
  local _name="${git__name:-}"

  params="$(getopt -o she:n: -l silent,help,email:,name: --name "$(basename "$0")" -- "$@")"
  eval set -- "$params"
  unset params

  while true; do
    case "$1" in
      -s|--silent)
        _silent=true
        ;;
      -e|--email)
        if helpers__empty "${2:-}"; then
          tellError "-e|--email requires an email address as parameter."
          exit 1 
        fi
        _email="${2:-}"
        shift
        ;;
      -n|--name)
        if helpers__empty "${2:-}"; then
          tellError "-n|--name requires a name as parameter."
          exit 1 
        fi
        _name="${2:-}"
        shift
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

  if helpers__empty "${_name:-}" || helpers__empty "${_email:-}"; then
    tellError "Please specify a name and email address in the config file or by using -e|--email and -n|--name parameters."
    tellMessage "<info>NOTE:</> <comment>Do not change the *.default.yml files as these will be overwritten when you update unabashed."
    exit 1
  fi

  if ! "$_silent"; then
    tellFancyTitle "Setting up your git." "configure-git" "fg=white;bg=blue"
    tellMessage "<question>Setting up aliases:</>"
    tellMessage "<info>git branch</>        - <comment>git br</>"
    tellMessage "<info>git checkout</>      - <comment>git co</>"
    tellMessage "<info>git commit</>        - <comment>git ci</>"
    tellMessage "<info>git status</>        - <comment>git st</>"
    tellMessage "<info>git reset HEAD --</> - <comment>git unstage</>"
    tellMessage "<info>git log -1 HEAD</>   - <comment>git last</>"
    tellMessage "<info>git user.email</>    - <comment>$_email</>"
    tellMessage "<info>git user.name</>     - <comment>$_name</>"
  fi

  git config --global alias.co checkout
  git config --global alias.br branch
  git config --global alias.ci commit
  git config --global alias.st status
  git config --global alias.unstage 'reset HEAD -- '
  git config --global alias.last 'log -1 HEAD'

  git config --global user.email "$_email"
  git config --global user.name "$_name"
  git config --global push.default simple
}

__internal_configure_git_main "$@"
