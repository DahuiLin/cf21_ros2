FROM osrf/ros:humble-desktop

# root user
ENV USERNAME isa
ENV HOME /home/$USERNAME

ENV NVIDIA_VISIBLE_DEVICES ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

RUN useradd -m $USERNAME && \
    echo "$USERNAME:$USERNAME" | chpasswd && \
    usermod --shell /bin/bash $USERNAME && \
    usermod -aG sudo $USERNAME && \
    mkdir -p /etc/sudoers.d && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME && \
    # Replace 1000 with your user/group id
    usermod --uid 1000 $USERNAME && \
    groupmod --gid 1000 $USERNAME


RUN apt-get update && \
    apt-get install -q -y --no-install-recommends \
    wget apt-utils sudo curl python3-vcstool \
		git\
        sudo \
        python3-pip \
        ipython3 \
        python3-dev \
        python3-numpy \
        python3-scipy \
        python3-matplotlib \
        python3-wheel \
        python3-setuptools \
        swig \
	&& apt-get clean -q -y \
	&& apt-get autoremove -q -y \
	&& rm -rf /var/lib/apt/lists/*



# set python3.8 as default
# RUN sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1

RUN apt-get update && \
    apt-get install -y \
    cmake \
    liblapack-dev \
    libblas-dev \
    libboost-all-dev \
    libflann-dev \
    libusb-1.0-0-dev \
    libqhull-dev \
    libboost-all-dev \
    libpcl-dev \
    gcc \
    g++ \
    gfortran \
    git \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install -y wget && \
    wget https://github.com/Kitware/CMake/releases/download/v3.21.0/cmake-3.21.0-linux-x86_64.sh && \
    chmod +x cmake-3.21.0-linux-x86_64.sh && \
    ./cmake-3.21.0-linux-x86_64.sh --skip-license --prefix=/usr/local && \
    rm cmake-3.21.0-linux-x86_64.sh

USER $USERNAME
WORKDIR $HOME

RUN sudo apt-get update \
&& git clone https://github.com/casadi/casadi.git \
&& cd casadi \
&& mkdir build \
&& cd build \
&& cmake -DWITH_PYTHON3=ON -DWITH_PYTHON=ON -DWITH_QPOASES=ON -DWITH_LAPACK=ON -DWITH_BUILD_REQUIRED=ON .. \
&& sudo make install -j4

RUN sudo apt-get update \
&& git clone https://github.com/acados/acados.git \
&& cd acados && git submodule update --init --recursive \
&& mkdir -p build && cd build \
&& cmake .. \
&& sudo make install -j4 

RUN sudo apt-get update \
&& pip3 install -e $HOME/acados/interfaces/acados_template

RUN sudo apt-get update \
&& git clone https://github.com/OctoMap/octomap.git \
&& cd $HOME/octomap/octomap \
&& mkdir build && cd build \
&& cmake .. \	
&& sudo make install -j4

RUN sudo apt-get update \
&& cd $HOME/octomap/dynamicEDT3D \
&& mkdir build && cd build \
&& cmake .. \
&& sudo make install -j4

RUN sudo apt install -y libxcb-xinerama0 libxcb-cursor0 \
&& pip3 install --upgrade pip

RUN sudo apt-get update \
&& git clone https://github.com/bitcraze/crazyflie-lib-python.git \
&& cd $HOME/crazyflie-lib-python \
&& pip3 install -e .

# RUN sudo apt-get update \
# && git clone https://github.com/PointCloudLibrary/pcl.git \
# && cd $HOME/pcl \
# && mkdir build && cd build \
# && cmake .. 
# && sudo make install -j7

# COPY repos/ros-requirements.txt /tmp
# RUN sudo apt-get update && \
#     sudo apt-get install -q -y --no-install-recommends \
#     $(cat /tmp/ros-requirements.txt | xargs) && \
#     sudo apt-get clean -q -y && \
#     sudo apt-get autoremove -q -y && \
#     sudo rm -rf /var/lib/apt/lists/* && \
#     sudo rm /tmp/ros-requirements.txt
    
RUN /bin/bash -c "echo 'source /opt/ros/humble/setup.bash' >> $HOME/.bashrc"

RUN mkdir -p $HOME/catkin_ws/src
WORKDIR $HOME/catkin_ws/

ENV ACADOS_SOURCE_DIR=${HOME}/acados
ENV CASADI_SOURCE_DIR=${HOME}/casadi
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:"${CASADI_SOURCE_DIR}/build/lib"
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:"${ACADOS_SOURCE_DIR}/lib"

