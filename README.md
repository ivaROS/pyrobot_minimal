<a href="https://www.pyrobot.org/"><img class="doc_vid" src="docs/website/website/static/img/pyrobot.svg"></a>

[PyRobot](https://www.pyrobot.org/) is a light weight, high-level interface which provides hardware independent APIs for robotic manipulation and navigation. This repository also contains the low-level stack for [LoCoBot](http://locobot.org), a low cost mobile manipulator hardware platform.

This repository is a fork of the original pyrobot repository but with some of the implementation removed.  The original pyrobot also consisted of autonomy stack modules that were either out of date or did not follow best practice.  They also complicated building of the ROS packages by enlarging the dependency space.  This minimal version strips out as much as possible, keeping only the necessary ingredients and a couple more that are easy to realize as they are based on `MoveIt`.  Ideally they should be removed  since MoveIt API does not fully align with how robot manipulator planning works in practice for kinematically redundant manipulators; even for kinematically sufficient manipulators.


## Installation

Installation of PyRobot under this repository is limited to the final version of ROS1: Noetic.  Testing has been done on Ubuntu 20.04LTS.  As noted in the beginning of the steps below, there is a presumption that Noetic has been installed (usually the `desktop-full` version) and that the Turtlebot2 packages have been installed.  

### Steps Established so Far

**First set of steps that are apt and python related:**<BR>
First get noetic and turtlebot installed (we have our custom [turtlebot_noetic](https://github.com/ivaROS/noetic_turtlebot) script for doing that in one go.<BR>
use `install_base.sh` with internal sudo escalation to install additional packages via `apt-get`. <BR>
use `install_python.sh` to create a local virtual environment (may or may not be critical to next steps). <BR>

**Next prep the ROS workspace:**<BR>
use `install_locosim.sh` to install the bare bones simulation stuff (not for running on actual locobot). <BR>
The shell script should only be run once.  It makes some modifications that may not apply / work when run twice. Some effort was made to be re-execution safe, but there is a `sed` line that overwrites code. It may not be a no-op if run again. <BR>
use wstool to get dynamixel dependencies. in the local ROS workspace try: <BR>
```
wstool init src 
wstool merge -t src src/pyrobot_minimal/pyrobot.rosinstall
wstool update -t src
```
or from within the `src` directory it may be possible to run
```
wstool init 
wstool merge pyrobot_minimal/pyrobot.rosinstall
wstool update 
```
Either way the update should snag some files.  These might already be apt-get-able.  Should check before doing this part. _Note: Looks like ROS noetic has dynamixel SDK and workbench. May not need to install like that._

run catkin build <BR>

### Confirming Build w/LoCoBot

After sourcing `devel/setup.bash`, getting a basic Gazebo simulation up and running should involve the following:
```
roslaunch locobot_gazebo gazbeo_locobot.launch base:=kobuki
rosrun robot_state_publisher robot_state_publisher
roslaunch locobot_gazebo gazebo_locobot_control.launch
```
run in three separate terminals.  Failing to run the first line will lead to `controller_manager` spawn failure for the second line after some timeout period.  It should be obvious after about 1 second that the process is not advancing and will timeout.

To adjust the pose of the robot run the following command lines and see the locobot servomotors adjust:
```
rostopic pub /tilt/command std_msgs/Float64 0.0
rostopic pub /pan/command std_msgs/Float64 0.5
rostopic pub /joint_2_cntrl/command std_msgs/Float64 0.0
rostopic pub /joint_1_cntrl/command std_msgs/Float64 0.0
rostopic pub /joint_3_cntrl/command std_msgs/Float64 0.0
rostopic pub /joint_4_cntrl/command std_msgs/Float64 0.0
rostopic pub /joint_5_cntrl/command std_msgs/Float64 0.0
rostopic pub /joint_6_cntrl/command std_msgs/Float64 "data: -0.02"
rostopic pub /joint_7_cntrl/command std_msgs/Float64 0.02
```
Remember that they can't all be run at once.  Hit Ctrl-C to terminate the previous `rostopic pub` command and execute the next.
The first two adjust the camra pan/tilt.  The camera should be facing left after publishing to the tilt/pan topics. The next 5 control the robot arm joint angles, with Joint 2 going first to pick up the arm from lying on the floor. the second keeps the arm pointing straight ahead. The last one's continue down the chain.  Finally, joints 6 and 7 are for the gripper.  Setting them both to zero closes the gripper.  Setting them as opposite numbers will open the gripper.  Do not go past -0.05 / 0.05 respectively for them, as the "fingers" slide off the rail.

Once the robot arm and camera are set, it is then possible to teleoperate the robot with the keyboard:
```
roslaunch turtlebot_teleop keyboard_teleop.launch
```
Pressing the movement keys should show the robot driving around in the empty world.  good luck developing further from this point!

Lastly, it is possible to test out the camera feeds by sending the camera to look forward and the arm to aim upwards:
```
rostopic pub /pan/command std_msgs/Float64 0.0
rostopic pub /joint_3_cntrl/command std_msgs/Float64 "data: -0.2"
```
In rviz check out the camera view and the arm can be seen.
The rviz launch is the standard `roslaunch locobot_description display.launch`.

### Limitations of Repository

This conversion to an easy Noetic installation is a work in progress.  Current emphasis is on realizing a Gazebo simulation instance for building out a reasonable autonomy stack using best practice and state-of-the-art methods.  As our understanding of the pyrobot/locobot API improves, we'll transition to extending the install scripts to apply to the real robot.  Doing so is not too difficult since the base implementation requires achieving three outcomes (1) control of the kobuki/create base using existing libraries, (2) control of the robot arm using existing libraries, and (3) control of the camera P/T mechanism using existing libraries.  Established processes exist for these steps.

**Warning**: As realsense keeps updating, compatibility issues might occur if you accidentally update
realsense-related packages from `Software Updater` in ubuntu. Therefore, we recommend you not to update
any libraries related to realsense. Check the list of updates carefully when ubuntu prompts software udpates.

### Alternatives to PyRobot and PYRobot_minimal

There is nothing too unique about the PyRobot setup.  It uses a kobuki base standard with the Turtlebot2, thus just installing turtlebot2 package will permit control of the PyRobot.  Just that the Gazebo models are not proper if simulation is important.  It uses a standard Interbotix manipulator setup, [WidowX 250](https://www.trossenrobotics.com/widowx-250), for which [Interbotix provides up to date git repos](https://github.com/Interbotix). Snag those and the arm can be controlled. There exists documentation on the interwebs for this arm ([example](https://github.com/IERoboticsAILab/wx250s_documentation)). Again, permits control and usage of the arm, but no Gazebo model for simulation.  If your development practice require Gazebo simulation, then this alternative is not suitable, but is a good start towards pre-installing the ROS packages needed for PyRobot_minimal to proceed faster.

There is a remote possibility that the Interbotix PyRobot git repo has a configuration compatible with the LoCoBot.  This possibility was not tested due to learning about it later.

## Getting Started
Please refer to [pyrobot.org](https://pyrobot.org/) and [locobot.org](http://locobot.org)

## About PyRobot Development
### The Original PyRobot Team

[Adithya Murali](http://adithyamurali.com/), [Tao Chen](https://taochenshh.github.io), [Dhiraj Gandhi](http://www.cs.cmu.edu/~dgandhi/), Kalyan Vasudev, [Lerrel Pinto](http://www.cs.cmu.edu/~lerrelp/), [Saurabh Gupta](http://saurabhg.web.illinois.edu) and [Abhinav Gupta](http://www.cs.cmu.edu/~abhinavg/). We would also like to thank everyone who has helped PyRobot in any way.

### Citation
```
@article{pyrobot2019,
  title={PyRobot: An Open-source Robotics Framework for Research and Benchmarking},
  author={Adithyavairavan Murali and Tao Chen and Kalyan Vasudev Alwala and Dhiraj Gandhi and Lerrel Pinto and Saurabh Gupta and Abhinav Gupta},
  journal={arXiv preprint arXiv:1906.08236},
  year={2019}
}
```
### License
PyRobot is under MIT license, as found in the LICENSE file.
