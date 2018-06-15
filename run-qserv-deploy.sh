#!/bin/sh

# Wrapper for the Qserv deploy container
# Check for needed variables
# @author Benjamin Roziere <benjamin.roziere@clermont.in2p3.fr>

set -e

DIR=$(cd "$(dirname "$0")"; pwd -P)

usage() {
    cat << EOD

Usage: `basename $0`

  Run a docker container with all the Qserv deployment tools inside.

  Pre-requisites: CLOUD env variable must be defined and exported.

EOD
}

if [ -z "$CLOUD" ]; then
    >&2 echo "ERROR: You must define and export CLOUD env variable"
    exit 1
fi

CLUSTER_CONFIG_DIR="$HOME/.lsst/qserv-cluster/$CLOUD"
SSH_DIR="$HOME/.ssh"

if [ ! -d "$CLUSTER_CONFIG_DIR" ]; then
    >&2 echo "ERROR: Incorrect CLUSTER_CONFIG_DIR parameter: \"$CLUSTER_CONFIG_DIR\""
    exit 1
fi

MOUNTS="-v $CLUSTER_CONFIG_DIR:/root/.qserv -v $SSH_DIR:/root/.ssh"

echo "Starting Qserv deploy on cluster $CLOUD..."

if [ "$QSERV_DEV" = true ]; then
    echo "Running in development mode"
    MOUNTS="$MOUNTS -v $DIR:/root/"
fi

docker run -it --rm -l cloud=$CLOUD -l config-path=$CLUSTER_CONFIG_DIR $MOUNTS qserv-deploy