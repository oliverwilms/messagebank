#!/bin/bash
cp -fv /ICS/iris.key /usr/irissys/mgr/iris.key
# copy IRIS.DAT from /ghostdb if it does not exist
FILE=/voldata/irisdb/MBKDATA/IRIS.DAT
if [ -f "$FILE" ]; then
    echo "$FILE exists."
else 
    cp -Rpfv /ghostdb/* /voldata/
fi
exit $?
