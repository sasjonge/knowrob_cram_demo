FROM intel4coro/base-notebook:20.04-noetic-vnc
ENV ROS_WS=${HOME}/workspace/ros
ENV OVERLAY_WS=${ROS_WS}

USER root

RUN echo "binder no cache"

# This steps seem to be necessary for now, TODO: check if this is still needed
# ─── STEP A: Remove any pre-existing ROS list files ─────────────────────────────────
RUN rm -f /etc/apt/sources.list.d/*ros*.list
# ─── STEP B: Update Ubuntu repos, install curl and gnupg2, and fetch the new ROS key ──
RUN apt-get update && \
    apt-get install -y curl gnupg2 lsb-release && \
    mkdir -p /usr/share/keyrings && \
    curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key \
      -o /usr/share/keyrings/ros-archive-keyring.gpg
# ─── STEP C: Recreate ros-latest.list so it points at our new keyring, then update ───
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] \
      http://packages.ros.org/ros/ubuntu focal main" \
      > /etc/apt/sources.list.d/ros-latest.list && \
    apt-get update
# ─── STEP D: Now that APT trusts packages.ros.org, install python3-pip, vcstool, etc. ──
RUN apt-get install -y \
      python3-pip \
      python3-vcstool \
      git \
      default-jre \
      python3-catkin-tools && \
    pip3 install --upgrade pip


RUN apt-get update && apt-get install graphviz graphviz-dev -y && pip3 install pip --upgrade

USER ${NB_USER}
RUN mkdir -p $OVERLAY_WS/src
RUN vcs import --input https://raw.githubusercontent.com/Tigul/pycram-1/knowrob-demo/rosinstall/pycram-https.rosinstall --skip-existing $OVERLAY_WS/src
RUN rosdep update && rosdep install --from-paths $OVERLAY_WS/src --ignore-src -r -y

USER root
RUN pip3 install --upgrade pip
WORKDIR $OVERLAY_WS/src/pycram
RUN pip3 install -r requirements.txt
EXPOSE 11311

USER root

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
    wget \
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
    ros-noetic-xacro \
    ros-noetic-convex-decomposition \
    ros-noetic-ivcon \
    swi-prolog*

# KnowRob dependencies
RUN apt install -y swi-prolog libspdlog-dev \
    libboost-python-dev libboost-serialization-dev libboost-program-options-dev \
    libraptor2-dev librdf0-dev libgtest-dev \
    libfmt-dev libeigen3-dev libmongoc-dev \
    doxygen graphviz
RUN apt install -y ros-noetic-tf2-geometry-msgs

USER ${NB_USER}
# Download konclude
WORKDIR $HOME
RUN wget https://github.com/sasjonge/semantic-map-lab/raw/refs/heads/dev/konclude/Konclude
# Install konclude
COPY --chown=${NB_USER}:users konclude ${HOME}/konclude
RUN chmod +x ${HOME}/konclude/Konclude
ENV  PATH=${PATH}:${HOME}/konclude

# Install SOMA DFL reasoner library
WORKDIR $HOME
RUN pip3 install inflection
RUN git clone https://github.com/sasjonge/ease_lexical_resources.git 
ENV  PYTHONPATH=${PYTHONPATH}:${HOME}/konclude:/home/jovyan/ease_lexical_resources/src:/home/jovyan/ease_lexical_resources/src/dfl
WORKDIR $HOME/ease_lexical_resources/
WORKDIR $HOME/ease_lexical_resources/src
RUN pip3 install -e .

USER ${NB_USER}


# Build workspace with knowrob
WORKDIR $OVERLAY_WS/src
RUN git clone https://github.com/knowrob/knowrob.git
RUN git clone https://github.com/knowrob/knowrob_ros.git
RUN git clone https://github.com/knowrob/knowrob_designator.git -b add_designator_parsing
COPY --chown=${NB_USER}:users . ${OVERLAY_WS}/src/knowrob_cram_demo
COPY --chown=${NB_USER}:users binder/me ${OVERLAY_WS}/src/me

# pr2_common at a specific commit
RUN git clone https://github.com/PR2/pr2_common.git \
 && cd pr2_common \
 && git checkout b34703bcca2b07cadbc3777d3c504c232a0c0c28
WORKDIR $OVERLAY_WS
RUN /usr/bin/catkin init
RUN . /opt/ros/noetic/setup.sh && /usr/bin/catkin build -j32 -l32
RUN echo "source $OVERLAY_WS/devel/setup.bash" >> ~/.bashrc
# Export Konclude Path
RUN echo "export KONCLUDE_PATH=${HOME}/konclude/Konclude" >> ~/.bashrc

WORKDIR $OVERLAY_WS/src/knowrob_cram_demo

RUN pip install service_identity
RUN pip install netifaces

# Jupyter Config
COPY --chown=${NB_USER}:users binder/jupyter-config.json /opt/conda/share/jupyter/lab/settings/overrides.json

RUN git config --global --add safe.directory ${PWD}
COPY --chown=${NB_USER}:users binder/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
RUN pip install https://raw.githubusercontent.com/yxzhan/jupyterlab-rviz/master/dist/jupyterlab_rviz-0.3.1.tar.gz
RUN mkdir -p /home/${NB_USER}/.ipython/profile_default/startup/

RUN curl https://raw.githubusercontent.com/sunava/pycram/revision-binder-all-robots/binder/01-import.py -o /home/${NB_USER}/.ipython/profile_default/startup/01-import.py

WORKDIR $OVERLAY_WS/src/knowrob_cram_demo

ENTRYPOINT ["/entrypoint.sh"]
