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
    --volume $(pwd)/../mocap_kalman_filter:/home/isa/catkin_ws/src/mocap_kalman_filter:rw \
    --volume $(pwd)/../cf21_bridge_ros2:/home/isa/catkin_ws/src/cf21_bridge_ros2:rw \
    --env="XAUTHORITY=${XAUTH}" \
    --env=TERM=xterm-256color \
    ros_humble:latest \
    bash
