#!/bin/bash

REPOSITORY="$(cd "$(dirname "$0")" && cd ../.. ; pwd -P )"

if [[ ! $GOPATH = *"$REPOSITORY"* ]]; then
  export GOPATH="$REPOSITORY"
  # echo >&2 "GOPATH for this shell is now $GOPATH";
fi

exec env GOPATH=$GOPATH $@
