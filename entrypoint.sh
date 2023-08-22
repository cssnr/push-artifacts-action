#!/usr/bin/env bash
#set -e

#echo "0: ${0}"
#echo "1: ${1}"
#echo "2: ${2}"

echo "Starting: Push Artifacts"

echo "INPUT_PATH: ${INPUT_PATH}"
ls -lAhR "${INPUT_PATH}"

echo "Running: sync.sh"
bash /scripts/sync.sh
