#!/bin/bash
set -e

echo "Starting entrypoint script..."
source ${ROS_WS}/devel/setup.bash
roscore &
roslaunch --wait rvizweb rvizweb.launch config_file:=${ROS_WS}/src/knowrob_cram_demo/binder/rviz_configs/pr2_config.json &
sleep 5
roslaunch --wait knowrob_cram_demo knowrob.launch &
cp ${ROS_WS}/src/knowrob_cram_demo/binder/webapps.json ${ROS_WS}/src/rvizweb/webapps/app.json

jupyter lab workspaces import ${ROS_WS}/src/knowrob_cram_demo/binder/knowrob_cram_demo.jupyterlab-workspace

xvfb-run exec "$@"