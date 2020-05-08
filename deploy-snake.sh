#!/bin/bash
THIS_DIR=$(dirname $0)
REMOTE_HOST=thisisagreat.site
REMOTE_USER=sssnake
REMOTE_SERVER="${REMOTE_USER}@${REMOTE_HOST}"
SNAKE_NAME=$1
# These are the default files we use, if you add more, you'll need
# to extend this script to scp more files accross.
THIS_SERVER=${THIS_DIR}/app
THIS_START=${THIS_DIR}/start-server.sh
THIS_GEMFILE=${THIS_DIR}/Gemfile
if [[ $1 == "-h" || $1 == "--help" ]]; then
    echo "Usage: $(basename $0) name_of_snake"
    echo "  Used to copy BattleSnake files to remote server: ${REMOTE_SERVER}"
    echo "  Options:"
    echo "      name_of_snake : The name of the snake, which will equate to it's directory name."
    exit 0
elif [[ $# == 0 || "${SNAKE_NAME}" == "" ]]; then
    # If no arguments, or empty string name.
    echo "You must pass the unique name for your snake." >&2
    exit 1
elif [[ ! ( "${SNAKE_NAME}" =~ ^[a-zA-Z0-9\_\-]+$ ) ]]; then
    echo "Please only use word, number, '-', or '_' characters for the snakes name." >&2
    exit 1
fi
REMOTE_DIR="/home/${REMOTE_USER}/${SNAKE_NAME}/"
ssh ${REMOTE_SERVER} ls -ld "${REMOTE_DIR}"
SSH_RESULT=$?
if [[ ${SSH_RESULT} == 2 ]]; then
    echo "Remote snake directory does not exist, attempting to create it..."
    # This error code means the directory does not exist.
    ssh ${REMOTE_SERVER} mkdir "${REMOTE_DIR}"
    if [[ $? != 0 ]]; then
        echo "Unable to create remote directory: ${REMOTE_DIR}" >&2
        exit 1
    else
        echo "Created remote snake directory: ${REMOTE_DIR}"
    fi
elif [[ ${SSH_RESULT} != 0 ]]; then
    echo "Unable to connect to ${REMOTE_SERVER}, error code: '${SSH_RESULT}'" >&2
    exit 1
else
    echo "Remote snake directory exists, copying files to server directory: ${REMOTE_DIR}"
fi
#scp ${THIS_SERVER} ${THIS_START} ${THIS_GEMFILE} ${REMOTE_SERVER}:${REMOTE_DIR}
scp -r ${THIS_SERVER} ${THIS_START} ${THIS_GEMFILE} ${REMOTE_SERVER}:${REMOTE_DIR}