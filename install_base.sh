#!/usr/bin/env bash

# Python installs required for pyrobot and locobot.
# Ripped from pyrobot: https://github.com/facebookresearch/pyrobot

if [ -z "$BASH_VERSION" ]; then
    echo "$0 must be run from bash!"
    exit 1
fi

if (sudo -v) then
    echo "User has sudo access."
else
    echo "User requires sudo access to run this script."
    exit 1
fi

install_packages() 
{
	pkg_names=("$@")
	for package_name in "${pkg_names[@]}"; 
	do
		if [ $(dpkg-query -W -f='${Status}' $package_name 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
		    sudo apt-get -y install $package_name
		else
		    echo "${package_name} is already installed";
		fi
	done
}

ubuntu_version="$(lsb_release -r -s)"
PYTHON_VERSION="3"
PYTHON_SUBVER="8"
ROS_NAME="noetic"

#===== INSTALL DEBIAN PACKAGES =====

# IS NEEDED? sudo apt-get update

# GENERAL ROS DEPENDENCIES
sudo apt-get -y install ros-$ROS_NAME-kdl-* ros-$ROS_NAME-trac-ik*

# Realsense stuff
sudo apt-get -y install ros-$ROS_NAME-librealsense2 ros-$ROS_NAME-realsense2-*

# Dynamixel stuff
sudo apt-get -y install ros-$ROS_NAME-dynamixel-*

# PYTHON DEPENDENCIES
echo "Python $PYTHON_VERSION needed for pyRobot installation."
sudo apt-get -y install python3-virtualenv
sudo apt-get -y install software-properties-common
sudo apt-get -y install python3-tk python3-sip python3-pip 
sudo apt-get -y install python3-dev python3-numpy python3-yaml 
sudo apt-get -y install python3-catkin-tools python3-catkin-pkg-modules 

#NOT IN 20.04LTS.
#sudo apt-get -y install ros-$ROS_NAME-orocos-kdl ros-$ROS_NAME-python-orocos-kdl 
# NOTE PYTHON KDL USES URCHIN NOW NOT OROCOS KDL!

# FROM LOCOBOT INSTALL
sudo apt-get -y install python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool 
sudo apt-get -y build-essential

# echo "May need to run what follows.  I don't think so though. See if can avoid doing."
# echo "sudo rosdep init"
# echo "rosdep update"
# 
# exit

# STEP 3 - Install ROS debian dependencies
declare -a ros_package_names=(
	"ros-$ROS_NAME-dynamixel-motor" 
	"ros-$ROS_NAME-moveit" 
	"ros-$ROS_NAME-trac-ik"
	"ros-$ROS_NAME-ar-track-alvar"
	"ros-$ROS_NAME-move-base"
	"ros-$ROS_NAME-ros-control"
	"ros-$ROS_NAME-gazebo-ros-control"
	"ros-$ROS_NAME-ros-controllers"
	"ros-$ROS_NAME-navigation"
	"ros-$ROS_NAME-rgbd-launch"
	"ros-$ROS_NAME-kdl-parser-py"
	"ros-$ROS_NAME-orocos-kdl"
	"ros-$ROS_NAME-python-orocos-kdl"
  	"ros-$ROS_NAME-ddynamic-reconfigure"
    "ros-$ROS_NAME-ros-control"
    "ros-$ROS_NAME-ros-controllers"
    "ros-$ROS_NAME-cv-bridge"
	#"ros-$ROS_NAME-libcreate"
	)

install_packages "${ros_package_names[@]}"


#exit

# FROM LOCOBOT INSTALL



# STEP 1 - Install basic dependencies
declare -a package_names=(
	"vim" 
	"git" 
	"terminator"
	"screen"
	"openssh-server" 
	"libssl-dev" 
	"libusb-1.0-0-dev"
	"libgtk-3-dev" 
	"libglfw3-dev"
	)
install_packages "${package_names[@]}"


