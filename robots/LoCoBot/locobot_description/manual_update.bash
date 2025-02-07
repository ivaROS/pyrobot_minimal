rosparam set /robot_description "\"$(cat /home/jpeng303/container_test/docker/pyrobot/pyrobot_minimal/robots/LoCoBot/locobot_description/urdf/interbotix_locobot_description_modified.urdf | sed "s/\"/\\\\\"/g" | sed "s^package://^file:///home/jpeng303/container_test/docker/pyrobot/pyrobot_minimal/robots/LoCoBot/^g" | sed -z "s/\\n/\\\\n/g")\""
rosrun robot_state_publisher robot_state_publisher
