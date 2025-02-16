#!/bin/sh
XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
sudo touch $XAUTH
sudo xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

docker run --privileged -it --rm \
    --env DISPLAY=$DISPLAY \
    --env QT_X11_NO_MITSHM=1 \
    --net=host \
    --runtime=nvidia \
    --volume=$XSOCK:$XSOCK:rw \
    --volume=$XAUTH:$XAUTH:rw \
    --volume /dev:/dev:rw \
    --env="XAUTHORITY=${XAUTH}" \
    --env=TERM=xterm-256color \
    ros_humble:latest \
    bash
