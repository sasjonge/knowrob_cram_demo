FROM ros:noetic-ros-core
MAINTAINER Sascha Jongebloed, jongebloed@uni-bremen.de

ENV SWI_HOME_DIR=/usr/lib/swi-prolog
ENV LD_LIBRARY_PATH=/usr/lib/swi-prolog/lib/x86_64-linux:$LD_LIBRARY_PATH

RUN apt-get update && apt-get install -y \
    software-properties-common && \
    apt-add-repository ppa:swi-prolog/stable && \
    apt-get update && apt-get install -y \
    gdb \
    g++ \
    clang \
    cmake \
    make \
    libeigen3-dev \
    libspdlog-dev \
    libraptor2-dev \
    librdf0-dev \
    libgtest-dev \
    libboost-python-dev \
    libboost-serialization-dev \
    libboost-program-options-dev \
    libfmt-dev \
    mongodb-clients \
    libmongoc-1.0-0 \
    libmongoc-dev \
    doxygen \
    graphviz \
    python3 \
    python3-dev \
    python3-pip \
    python3-venv \
    python-is-python3 \
    python3-catkin-pkg \
    python3-catkin-tools \
    git \
    ros-noetic-catkin \
    ros-noetic-tf2-geometry-msgs \
    swi-prolog*

# KnowRob dependencies
RUN apt install -y swi-prolog libspdlog-dev \
    libboost-python-dev libboost-serialization-dev libboost-program-options-dev \
    libraptor2-dev librdf0-dev libgtest-dev \
    libfmt-dev libeigen3-dev libmongoc-dev \
    doxygen graphviz
RUN apt install -y ros-noetic-tf2-geometry-msgs

RUN mkdir /catkin_ws
RUN mkdir /catkin_ws/src

# Build workspace with knowrob
WORKDIR /catkin_ws/src
RUN git clone https://github.com/knowrob/knowrob.git
RUN git clone https://github.com/knowrob/knowrob_ros.git
RUN git clone https://github.com/knowrob/knowrob_designator.git
WORKDIR /catkin_ws
RUN /usr/bin/catkin init
RUN . /opt/ros/noetic/setup.sh && /usr/bin/catkin build

# Build workspace with knowrob_designator
WORKDIR /catkin_ws/src
ADD . /catkin_ws/src/knowrob_cram_demo
WORKDIR /catkin_ws
RUN . /opt/ros/noetic/setup.sh && /usr/bin/catkin build
RUN echo "source /catkin_ws/devel/setup.bash" >> /root/.bashrc

COPY run_knowrob_designator.sh /run_knowrob_designator.sh

ENTRYPOINT ["/run_knowrob_designator.sh"]
