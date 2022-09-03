arguments_list() {
  LIST_DESCRIPTION="List available tasks"
  LIST_OPTIONS="global:g:bool local:l:bool all:a:bool"
}

task_list() {
  if [[ -z "$ARG_GLOBAL$ARG_LOCAL$ARG_ALL" ]]
  then
    ARG_ALL='T'
  fi
  if [[ ! -z "$ARG_GLOBAL$ARG_ALL" ]]
  then
    echo "Available global tasks:"
    echo
    declare -F  | grep -e 'declare -fr task_' | sed 's/declare -fr task_/     /' | tr '\n' ' '
    echo
    echo
  fi
  if [[ ! -z "$ARG_LOCAL$ARG_ALL" ]]
  then
    echo "Available local tasks:"
    echo
    declare -F  | grep -e "declare -f task_" | sed 's/declare -f task_/     /' | tr '\n' ' '
    echo
    echo
  fi
}

readonly -f arguments_list
readonly -f task_list