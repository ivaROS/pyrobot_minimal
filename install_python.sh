#!/usr/bin/env bash

helpFunction()
{
   echo "No help. Just run"
   exit 1 # Exit script after printing help
}

ubuntu_version="$(lsb_release -r -s)"
PYTHON_VERSION="3"
PYTHON_SUBVER="8"
ROS_NAME="noetic"

#===== INSTALL DEBIAN PACKAGES =====

# Make a virtual env to install other dependencies (with pip)
virtualenv_name="pyenv/pyrobot"
VIRTUALENV_FOLDER=~/${virtualenv_name}
if [ ! -d "$VIRTUALENV_FOLDER" ]; then
	virtualenv -p /usr/bin/python3.$PYTHON_SUBVER $VIRTUALENV_FOLDER
	source ~/${virtualenv_name}/bin/activate
	pip install catkin_pkg pyyaml empy rospkg
	python -m pip install --upgrade numpy
	pip install .

    pip install --upgrade cryptography
    python -m easy_install --upgrade pyOpenSSL

	deactivate
#sudo pip install --upgrade pip==20.3
fi

exit

# DO NOT RUN YET!
source ~/${virtualenv_name}/bin/activate
echo "Setting up PyRobot Catkin Ws..."
PYROBOT_PYTHON3_WS=~/ros_pyrobot

if [ ! -d "$PYROBOT_PYTHON3_WS/src" ]; then
	mkdir -p $PYROBOT_PYTHON3_WS/src
	cd $PYROBOT_PYTHON3_WS/src

	if [ $ROS_NAME == "kinetic" ]; then
		git clone -b indigo-devel https://github.com/ros/geometry
		git clone -b indigo-devel https://github.com/ros/geometry2
		git clone -b python3_patch https://github.com/kalyanvasudev/vision_opencv.git
	else
		git clone -b melodic-devel https://github.com/ros/geometry
		git clone -b melodic-devel https://github.com/ros/geometry2
		git clone -b python3_patch_melodic https://github.com/kalyanvasudev/vision_opencv.git
	fi
		
	git clone -b patch-1 https://github.com/kalyanvasudev/ros_comm.git

	cd ..
		
	# Install all the python 3 dependencies

	# Build
	catkin_make --cmake-args -DPYTHON_EXECUTABLE=$(which python) -DPYTHON_INCLUDE_DIR=/usr/include/python3.6m -DPYTHON_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython3.6m.so
		
	echo "alias load_pyrobot_env='source $VIRTUALENV_FOLDER/bin/activate && source $PYROBOT_PYTHON3_WS/devel/setup.bash'" >> ~/.bashrc
fi
deactivate
