setup() {
  load "$TASK_MASTER_HOME/test/run/bats-support/load"
  load "$TASK_MASTER_HOME/test/run/bats-assert/load"

  export LOCATIONS_FILE=$TASK_MASTER_HOME/test/locations.txt
  export RUNNING_DIR=$(pwd)

  touch $LOCATIONS_FILE
}

teardown() {
  rm $LOCATIONS_FILE
}

@test "Create a bookmark" {
  source_and_set_vars ""  "test_dir"

  task_bookmark

  run output_locations
  assert_output "UUID_test_dir=$TASK_MASTER_HOME/test"
}

@test "Create a distant bookmark" {
  source_and_set_vars ""  "test_dir" "/tmp"

  task_bookmark

  run output_locations
  assert_output "UUID_test_dir=/tmp"
}

@test "Remove a bookmark by name" {
  source_and_set_vars "rm" "bkmk"

  echo UUID_bkmk=/home/btm/project > $LOCATIONS_FILE
  
  task_bookmark

  run output_locations
  assert_output ""
}

@test "List bookmarks" {
  source_and_set_vars "list"
  
  echo UUID_proj=/home/btm/project > $LOCATIONS_FILE
  echo UUID_bkmk=/home/btm/project >> $LOCATIONS_FILE

  run task_bookmark

  assert_output --partial "proj"
  assert_output --partial "bkmk"
}

@test "Remove a non existant bookmark" {
  source_and_set_vars "rm" "bkmk"

  run task_bookmark

  assert_output --partial "not found"
}

source_and_set_vars() {
  source $TASK_MASTER_HOME/lib/builtins/bookmark.sh

  TASK_SUBCOMMAND="$1"
  ARG_NAME="$2"
  ARG_DIR="$3"
}

output_locations() {
  cat $LOCATIONS_FILE
}

