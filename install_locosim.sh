#!/usr/bin/env bash

helpFunction()
{
   echo ""
   echo -e "\t-l Decides the type of LoCoBot hardware platform. Available Options: cmu or interbotix"
   exit 1 # Exit script after printing help
}

while getopts "t:p:l:" opt
do
   case "$opt" in
      l ) LOCOBOT_PLATFORM="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$LOCOBOT_PLATFORM" ]; then
   echo "Some or all of the parameters are empty";
   helpFunction
fi

if [ $LOCOBOT_PLATFORM != "cmu" ] && [ $LOCOBOT_PLATFORM != "interbotix" ]; then
	echo "Invalid LoCoBot hardware platform type";
   helpFunction
fi

PYTHON_VERSION="3"
ubuntu_version="$(lsb_release -r -s)"
ROS_NAME="noetic"
echo "Ubuntu $ubuntu_version detected. ROS-$ROS_NAME chosen for installation.";

echo "$INSTALL_TYPE installation type is chosen for LoCoBot."
echo "Python $PYTHON_VERSION chosen for pyRobot installation."
echo "$LOCOBOT_PLATFORM hardware platform chosen for LoCoBot."

trap "exit" INT TERM ERR
trap "kill 0" EXIT
start_time="$(date -u +%s)"

# STEP 5 - Setup catkin workspace
echo "Setting up robot software..."
PYROBOTMIN_PATH=$(dirname "${BASH_SOURCE[0]}")
LOCOBOT_PATH=$PYROBOTMIN_PATH/robots/LoCoBot
LOCOBOT_URDF_PATH=$LOCOBOT_PATH/locobot_description/urdf
LOCOBOT_MOVEIT_PATH=$LOCOBOT_PATH/locobot_moveit_config/config
LOCOBOT_CONTROL_SRC=$LOCOBOT_PATH/locobot_control/src

if [ ! -f "$LOCOBOT_URDF_PATH/locobot_description.urdf" ]; then
  ln $LOCOBOT_URDF_PATH/${LOCOBOT_PLATFORM}_locobot_description.urdf $LOCOBOT_URDF_PATH/locobot_description.urdf
fi
if [ ! -f "$LOCOBOT_MOVEIT_PATH/locobot.srdf" ]; then
  ln $LOCOBOT_MOVEIT_PATH/${LOCOBOT_PLATFORM}_locobot.srdf $LOCOBOT_MOVEIT_PATH/locobot.srdf
fi
echo "Creating hard links.  Better to have be flag in launch file"

if [ $LOCOBOT_PLATFORM == "cmu" ]; then
  sed -i 's/\(float restJnts\[5\] = \)\(.*\)/\1{0, -0.3890, 1.617, -0.1812, 0.0153};/' \
        $LOCOBOT_CONTROL_SRC/locobot_controller.cpp
fi
if [ $LOCOBOT_PLATFORM == "interbotix" ]; then
  sed -i 's/\(float restJnts\[5\] = \)\(.*\)/\1{0, -1.30, 1.617, 0.5, 0};/'  \
        $LOCOBOT_CONTROL_SRC/locobot_controller.cpp
fi

echo "Sim installation tweaks complete."
