#!/usr/bin/env bash

helpFunction()
{
   echo "No help. Just run"
   exit 1 # Exit script after printing help
}

ubuntu_version="$(lsb_release -r -s)"
PYTHON_VERSION = "3"
PYTHON_SUBVER  = "8"
ROS_NAME = "noetic"

echo "Needs to have sudoer access."

#===== INSTALL DEBIAN PACKAGES =====

# IS NEEDED? sudo apt-get update

# GENERAL ROS DEPENDENCIES
sudo apt-get -y install ros-$ROS_NAME-kdl-* ros-$ROS_NAME-trac-ik*
sudo apt-get -y install ros-$ROS_NAME-cv-bridge

# PYTHON DEPENDENCIES
echo "Python $PYTHON_VERSION needed for pyRobot installation."
sudo apt-get -y install python3-virtualenv
sudo apt-get -y install software-properties-common
sudo apt-get -y install python3-tk 
sudo apt-get -y install python3-dev python3-numpy python3-yaml 
sudo apt-get -y install python3-catkin-tools python3-catkin-pkg-modules 

#NOT IN 20.04LTS.
#sudo apt-get -y install ros-$ROS_NAME-orocos-kdl ros-$ROS_NAME-python-orocos-kdl 
# NOTE PYTHON KDL USES URCHIN NOW NOT OROCOS KDL!
