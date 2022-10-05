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

retract_pos = { 'r_shoulder_y': 23,
                'r_shoulder_x': 0,
                'r_arm_z': -55,
                'r_elbow_y': -174,
                'r_m1':-27,
                'r_m2':-19,
                'r_m3':57,
                'r_m4':2,

                'l_shoulder_y': 8,
                'l_shoulder_x': 48,
                'l_arm_z': 39,
                'l_elbow_y': -170}

point_pos = { 'r_shoulder_y': 18,
                'r_shoulder_x': -6,
                'r_arm_z': 3,
                'r_elbow_y': -158,
                'r_m1':-26,
                'r_m2':-19,
                'r_m3':78,
                'r_m4':51,

                'l_shoulder_y': 8,
                'l_shoulder_x': 48,
                'l_arm_z': 39,
                'l_elbow_y': -170}

hold_violin = { 'l_shoulder_y': 8,
                'l_shoulder_x': 48,
                'l_arm_z': 39,
                'l_elbow_y': -170}

#arm.goto_position(retract_pos, duration=5, wait=True)
for m in arm.r_arm:
    print(m.name,m.present_position)
for m in arm.r_gripper:
    print(m.name,m.present_position)
 #   m.compliant = False

m =0

#arm.goto_position(retract_pos, duration = 3, wait = True)

while True:

    arm.goto_position(retract_pos, duration = 0.5, wait = True)

    arm.goto_position(point_pos, duration= 0.5, wait=True)

#arm.goto_position(hold_violin, duration = 2, wait = True)

for m in arm.r_arm:
    print(m.name,m.present_position)
for m in arm.r_gripper:
    print(m.name,m.present_position)
for m in arm.l_arm:
    print(m.name,m.present_position)



"""

m = 0
while m < 5:
    arm.goto_position(retract_pos, duration=1, control='dummy', wait=True)
    arm.goto_position(point_pos, duration=1, control='dummy' , wait=True)
    m=m+1

arm.goto_position(retract_pos, duration=1, control = 'dummy', wait=True)
arm.goto_position(point_pos, duration=1,control='dummy', wait=True)
arm.goto_position(retract_pos, duration=1, wait=True)
arm.goto_position(point_pos, duration=1, wait=True)

print()
print('IMMEDIATELY AFTER MOVING')


for m in arm.r_arm:
    print(m.name,m.present_position)
for m in arm.r_gripper:
    print(m.name,m.present_position)

time.sleep(3)
print()
print('AFTER SETTLING')


for m in arm.r_arm:
    print(m.name,m.present_position)
for m in arm.r_gripper:
    print(m.name,m.present_position)

#for m in arm.r_gripper:
 #   m.goal_speed = 10
  #  arm.r_m1.compliant = False

#while True:
 #   arm.r_m1.goal_position = 40



print(arm.r_shoulder_x.present_position)
print(arm.r_elbow_y.present_position)
print(arm.r_arm_z.present_position)

print(arm.r_shoulder_x.goal_position)
print(arm.r_elbow_y.goal_position)
print(arm.r_arm_z.goal_position)

while True:
    for m in arm.r_arm:
        m.compliant = True
        #m.goal_speed = 40

#arm.goto_position(rest_pos, duration=1, wait=True)
#arm.goto_position(point_pos,duration=3, wait=True)
#arm.goto_position(rest_pos, duration=3, wait=True)
#arm.goto_position(point_pos,duration=1, wait=True)
#arm.goto_position(rest_pos, duration=1, wait=True)
#arm.goto_position(point_pos,duration=1, wait=True)
#arm.goto_position(retract_pos,duration=1, wait=True)
#arm.goto_position(point_pos,duration=1, wait=True)
#arm.goto_position(retract_pos,duration=0.6, wait=True)
#arm.goto_position(point_pos,duration=0.6, wait=True)
#arm.goto_position(rest_pos, duration=0.4, wait=True)


while True:
    arm.r_shoulder_x.goal_position = -100
    arm.r_arm_z.goal_position = -30
    arm.r_elbow_y.goal_position = -70


#print(arm.r_arm_pan.present_position)

for m in arm.r_arm:
    m.compliant = True
    m.goal_position = 70
    print(m.goal_position)

for m in arm.r_arm:
    m.compliant = True
    m.goal_position = 90
    print(m.name)
    print(m.goal_position)
    print(m.present_position)

with closing(pypot.robot.from_json('poppy_arm_poc.json')) as arm:
    pass
"""