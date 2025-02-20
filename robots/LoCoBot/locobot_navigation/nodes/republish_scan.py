#!/usr/bin/env python3
"""Cut out the parts of the laserscan which don't have useful information.
Replace them with NAN."""

import rospy
from sensor_msgs.msg import LaserScan

import numpy as np

# TODO: Cut out points blocked by the arm too.
# TODO 2: Can we fill in the dead points? It messes up PG.
def main():
    rospy.init_node('lidar_scan_republisher')
    data_filename = rospy.get_param('~lidar_suppression_mask')

    raw_bad_mask = np.load(data_filename)
    extend = 20
    bad_mask = np.logical_or(raw_bad_mask, np.roll(raw_bad_mask, extend))
    bad_mask = np.logical_or(bad_mask, np.roll(raw_bad_mask, -extend))

    pub = rospy.Publisher("/scan", LaserScan)
    
    def scan_callback(msg):
        scan_arr = np.array(msg.ranges)
        scan_arr[np.isnan(scan_arr)] = np.inf
        scan_arr[bad_mask] = np.nan

        out_msg = LaserScan()
        out_msg.header.seq = msg.header.seq
        out_msg.header.stamp = msg.header.stamp
        out_msg.header.frame_id = msg.header.frame_id
        out_msg.angle_min = msg.angle_min
        out_msg.angle_max = msg.angle_max
        out_msg.angle_increment = msg.angle_increment
        out_msg.time_increment = msg.time_increment
        out_msg.scan_time = msg.scan_time
        out_msg.range_min = msg.range_min
        out_msg.range_max = msg.range_max
        out_msg.ranges = scan_arr
        out_msg.intensities = msg.intensities
        pub.publish(out_msg)

    sub = rospy.Subscriber("/scan_raw", LaserScan, scan_callback)
    rospy.spin()

if __name__ == "__main__":
    main()

