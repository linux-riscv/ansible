#!/bin/bash

set -euo pipefail

ghtoken="${GH_TOKEN}"
token="null"

cd /home/github/actions-runner

cleanup() {
    if [[ "$token" != "null" ]]; then
        ./config.sh remove --token "$token"
        token="null"
    fi
    rm -rf .runner
    exit
}
trap cleanup EXIT INT

while true; do
    token=$(curl -s -u "$ghtoken"  -X POST -H "Accept: application/vnd.github.v3+json" \
                 "https://api.github.com/repos/linux-riscv/linux-riscv/actions/runners/registration-token" |
                jq ".token" -r)

    if [[ "$token" != "null" ]]; then
        echo "token is $token"
        docker run -it --volume /home/github/ramdisk:/ramdisk debian:bookworm bash -c "rm -rf /ramdisk/build"
        docker run -it --volume /home/github/ramdisk:/ramdisk debian:bookworm bash -c "mkdir /ramdisk/build"
        ./config.sh --unattended --url https://github.com/linux-riscv/linux-riscv --ephemeral --token "$token" --name $(hostname)
        if ! (( $? )); then
            echo "Running..."
            ./run.sh
            token="null"
            echo "run.sh completed with $?"
        else
            echo "Config failed with $?"
        fi
        ./config.sh remove --token "$token"
        rm -rf .runner
    else
        echo "ERROR: Could not get token"
    fi

    sleep 2
done
