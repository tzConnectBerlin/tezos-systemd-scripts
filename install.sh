#!/bin/sh
# Script to install the systemd scripts.
#
# You must set some environment variables in order to execute this script:
# TEZOS_PATH      - the location of the various executables (tezos-node and friends)
# TEZOS_USER      - the user these should run as
#
# You may also set TEZOS_GROUP -- if not set this will be the primary group of $TEZOS_USER
#
set -e # halt on error
#
#

if [ -z $TEZOS_USER ]; then
    echo "Variable TEZOS_USER is required"
    exit 0
fi

if [ -z $TEZOS_PATH ]; then
    echo "Variable TEZOS_PATH is required"
    exit 0
fi

if [ -z $TEZOS_GROUP ]; then
    TEZOS_GROUP=`id -gn $TEZOS_USER`
fi
echo "TEZOS_GROUP=$TEZOS_GROUP"
mkdir -p converted

for service in *service*; do
    cat $service | sed -e "s@/home/newby@$TEZOS_PATH@g" | sed -e "s@User            = newby@User            = $TEZOS_USER@g" | sed -e "s@Group		= newby@Group		= $TEZOS_GROUP@g" > converted/$service
done
