#!/usr/bin/env bash

echo $(pwd)

echo $(readlink -f "$0")
echo $(dirname "$(readlink -f "$0")")

exit 0