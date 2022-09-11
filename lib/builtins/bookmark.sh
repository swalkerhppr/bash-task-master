arguments_bookmark() {
  SUBCOMMANDS='|rm|list'
  BOOKMARK_DESCRIPTION="Add a bookmark to the current location."
  BOOKMARK_OPTIONS="dir:d:str name:n:str"
  RM_DESCRIPTION="Remove a bookmark"
  LIST_DESCRIPTION="List available bookmarks"
}

task_bookmark() {
  if [[ -z "$ARG_DIR" ]]
  then
    ARG_DIR=$RUNNING_DIR
  fi
  if [[ -z "$ARG_NAME" ]]
  then
    ARG_NAME=$(basename "$(readlink -f "$ARG_DIR")")
  fi
  if [[ "$TASK_SUBCOMMAND" == "list" ]]
  then
    echo "Bookmarks:"
    sed 's/UUID_\(.*\)=.*/    \1/' "$LOCATIONS_FILE" | tr '\n' ' '
    echo
    echo
  elif [[ "$TASK_SUBCOMMAND" == "rm" ]]
  then
    if grep -q "UUID_$ARG_NAME=" "$LOCATIONS_FILE"
    then
      awk "/UUID_$ARG_NAME=/ { next } { print }" "$LOCATIONS_FILE" > "$LOCATIONS_FILE.upd"
      mv "$LOCATIONS_FILE"{.upd,}
      echo "Removed bookmark: $ARG_NAME"
    else
      echo "Bookmark $ARG_NAME not found"
    fi
  else
    echo "Saving location to $LOCATIONS_FILE as $ARG_NAME"
    echo "UUID_$ARG_NAME=$ARG_DIR" >> "$LOCATIONS_FILE"
  fi
}

readonly -f task_bookmark
readonly -f arguments_bookmark
