#!/bin/sh

RUNNING_CONTAINER_ID=`docker ps -q -f "label=image=mydotnetlabo"`
if [ -n "$RUNNING_CONTAINER_ID" ]
then
    docker stop $RUNNING_CONTAINER_ID
    if [ $? -ne 0 ]
    then
        echo "failed docker stop command." 1>&2
        exit 1
    fi
fi

CONTAINER_ID=`docker ps -a -q -f "label=image=mydotnetlabo"`
if [ -n "$CONTAINER_ID" ]
then
    docker rm $CONTAINER_ID
    if [ $? -ne 0 ]
    then
        echo "failed docker rm command." 1>&2
        exit 1
    fi
fi

NOWDATE=`date +%Y%m%d%H%M%S`

docker build -t mydotnetlabo:$NOWDATE .
if [ $? -ne 0 ]
then
    echo "failed docker build command." 1>&2
    exit 1
fi

docker run -d -p 8080:5000 -t mydotnetlabo:$NOWDATE
if [ $? -ne 0 ]
then
    echo "failed docker run command." 1>&2
    exit 1
fi

exit 0