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

arm.compliant = True
'''
while True:
    print(arm.r_m1.present_position)
    time.sleep(0.5)
'''''
for m in arm.r_gripper:
    print(m.name, m.present_position)

for m in arm.r_arm:
    print(m.name, m.present_position)

for m in arm.l_arm:
    print(m.name, m.present_position)

'''
while True:
    print(arm.r_m4.present_position)
    time.sleep(0.5)

for m in arm.r_gripper:
    print(m.name,m.present_position)
    m.compliant = False
'''