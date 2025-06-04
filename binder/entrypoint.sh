#!/bin/bash
set -e

echo "Starting entrypoint script..."
source ${ROS_WS}/devel/setup.bash
roslaunch --wait knowrob_cram_demo knowrob.launch &
sleep 5
roslaunch --wait rvizweb rvizweb.launch config_file:=${ROS_WS}/src/pycram/binder/rviz_configs/pr2_config.json &
cp ${ROS_WS}/src/knowrob_cram_demo/binder/webapps.json ${ROS_WS}/src/rvizweb/webapps/app.json

xvfb-run exec "$@"