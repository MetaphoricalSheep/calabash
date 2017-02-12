__internal_configure_git_usage() {
  output__tell__message "<info>Usage</>"
  output__tell__message "<comment>configure-git.sh</>"
  output__tell__message "Configures aliases for git and sets your email address and name."
  output__tell__message "Email address and name is read from the config file."
  output__tell__message "Specified email address or name will take priority."
  output__tell__message "<comment>  -s|--silent</> - don't output anything (except errors)"
  output__tell__message "<comment>  -e|--email</>  - override the email address config."
  output__tell__message "<comment>  -n|--name</>   - override the name config."
  output__tell__message "<comment>  -h|--help</>   - display this help section"

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
          output__tell__error "-e|--email requires an email address as parameter."
          exit 1 
        fi
        _email="${2:-}"
        shift
        ;;
      -n|--name)
        if helpers__empty "${2:-}"; then
          output__tell__error "-n|--name requires a name as parameter."
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
    output__tell__error "Please specify a name and email address in the config file or by using -e|--email and -n|--name parameters."
    output__tell__message "<info>NOTE:</> <comment>Do not change the *.default.yml files as these will be overwritten when you update unabashed."
    exit 1
  fi

  if ! "$_silent"; then
    output__tell__fancyTitle "Setting up your git." "configure-git" "fg=white;bg=blue"
    output__tell__message "<question>Setting up aliases:</>"
    output__tell__message "<info>git branch</>        - <comment>git br</>"
    output__tell__message "<info>git checkout</>      - <comment>git co</>"
    output__tell__message "<info>git commit</>        - <comment>git ci</>"
    output__tell__message "<info>git status</>        - <comment>git st</>"
    output__tell__message "<info>git reset HEAD --</> - <comment>git unstage</>"
    output__tell__message "<info>git log -1 HEAD</>   - <comment>git last</>"
    output__tell__message "<info>git user.email</>    - <comment>$_email</>"
    output__tell__message "<info>git user.name</>     - <comment>$_name</>"
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
