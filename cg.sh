#!/bin/bash

cd "$(dirname "$0")"

infra_path="infra/go/src/Cloudground"
dir_hash_path="dir.hash"
dep_hash_path="dep.hash"

function dep_ensure {
    local dep_hash=$(sha1sum Gopkg.toml | cut -d ' ' -f 1)
    if [ -f ${dep_hash_path} ] ; then
        if [ "$(cat ${dep_hash_path})" == "$dep_hash" ] ; then
            echo "Dependencies are installed"
        else
            echo "Cloudground dependencies have changed, reinstalling"
            ./gow.sh dep ensure
            echo ${dep_hash} > ${dep_hash_path}
        fi
    else
        echo "Installing dependencies"
        ./gow.sh dep ensure
        echo ${dep_hash} > ${dep_hash_path}
    fi
}

function run {
    local dir_hash=$(find . -type f ! -path ./vendor ! -name "Cloudground.*" ! -name "${dir_hash_path}" ! -name "${dep_hash_path}" -print0 | sort -z | xargs -0 sha1sum | sha1sum | cut -d ' ' -f 1)
    if [ -f ${dir_hash_path} ] ; then
        if [ "$(cat ${dir_hash_path})" == "$dir_hash" -a "$(ls Cloudground* 1> /dev/null 2>&1; echo $?)" == "0" ] ; then
            # echo "Executing without compilation"
            ./Cloudground $@
        else
            dep_ensure
            echo "Cloudground infra source has changed (or no binary was found), recompiling and executing"
            ./gow.sh go build
            echo ${dir_hash} > ${dir_hash_path}
            ./Cloudground $@
        fi
    else
        dep_ensure
        echo "Compiling and executing"
        ./gow.sh go build
        echo ${dir_hash} > ${dir_hash_path}
        ./Cloudground $@
    fi
}

pushd ${infra_path} > /dev/null
    run $@
popd > /dev/null
