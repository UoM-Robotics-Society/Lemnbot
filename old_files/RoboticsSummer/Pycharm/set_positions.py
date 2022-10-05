import itertools
import numpy
import time
import json
from contextlib import closing

import pypot.dynamixel
import pypot.robot

from pypot.robot import from_json
from threading import Thread


arm = pypot.robot.from_json('poppy_longarm.json')

print(arm.motors)

arm.power_up()

for m in filter(lambda  m: hasattr(m, 'pid'), arm.motors):
    m.pid= (1.9, 5, 0)

for m in arm.r_gripper:
    m.pid=(4, 2, 0)

retract_pos = { 'r_shoulder_y': -18,
                'r_shoulder_x': -121,
                'r_arm_z': 12,
                'r_elbow_y': -107,
                'r_m1':-52,
                'r_m2':-66,
                'r_m3':28,
                'r_m4':15}

point_pos = { 'r_shoulder_y': -31,
                'r_shoulder_x': -121,
                'r_arm_z': 22,
                'r_elbow_y': -174,
                'r_m1':-58,
                'r_m2':-75,
                'r_m3':45,
                'r_m4':47}

arm.goto_position(retract_pos, duration = 4, wait = True)

while True:
    option = input('set position of r_shoulder_y\n')
    arm.r_shoulder_y.goal_position = option

    option = input('set position of r_shoulder_x\n')
    arm.r_shoulder_x.goal_position = option

    option = input('set position of r_arm_z\n')
    arm.r_arm_z.goal_position = option

    option = input('set position of r_elbow_y\n')
    arm.r_elbow_y.goal_position = option

    option = input('set position of r_m1\n')
    arm.r_m1.goal_position = option

    option = input('set position of r_m2\n')
    arm.r_m2.goal_position = option

    option = input('set position of r_m3\n')
    arm.r_m3.goal_position = option

    option = input('set position of r_m4\n')
    arm.r_m4.goal_position = option



