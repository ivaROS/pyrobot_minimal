cmake_minimum_required(VERSION 3.0.2)
project(locobot_bringup)

find_package(catkin REQUIRED)

catkin_package()

install(DIRECTORY config
    DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
)

install(DIRECTORY scripts
    DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
)
