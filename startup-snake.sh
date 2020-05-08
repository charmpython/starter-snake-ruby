#!/bin/bash
THIS_DIR=$(dirname $0)
if [[ $1 == "-h" || $1 == "--help" ]]; then
    echo "Usage: $(basename $0)"
    echo "  Start the BattleSnake server in the current directory."
    exit 0
fi
THIS_SERVER=${THIS_DIR}/app/app.rb
set -e
if [[ ! -f ${THIS_SERVER} ]]; then
    echo "Unable to find server file at: '$(readlink -f ${THIS_SERVER})'" >&2
    echo "Make sure you've deployed your snake server." >&2
    exit 1
fi
ruby ${THIS_SERVER} 