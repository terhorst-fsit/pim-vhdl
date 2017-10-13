#!/bin/bash

ORIG=$PWD
source bin/env.sh
RESULT=$?

if [ $RESULT -ne 0 ]; then
    echo "script failed, aborting"
fi


cd tb
all.sh
RESULT=$?
cd $ORIG
exit $RESULT
