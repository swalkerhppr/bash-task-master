#!/bin/bash

cd $(dirname $0)

run/bats/bin/bats task-runner.bats lib/*.bats lib/builtins/*.bats lib/drivers/*.bats
