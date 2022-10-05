import itertools
import numpy
import time
import json
from contextlib import closing

import pypot.dynamixel
import pypot.robot
from pypot.primitive.move import MoveRecorder, Move, MovePlayer

from pypot.robot import from_json


arm = pypot.robot.from_json('poppy_arm_poc.json')

move_recorder = MoveRecorder(arm, 50, arm.motors)

arm.compliant = True

print('Recording in 2 seconds!')
time.sleep(1)
print('1')
time.sleep(1)

move_recorder.start()
time.sleep(10)
move_recorder.stop()

print('Saving move')
with open('test.move', 'w') as f:
    move_recorder.move.save(f)

time.sleep(5)

print('Prepare to release arm')

arm.compliant = False

rest_pos = {'r_shoulder_x': -80,
            'r_elbow_y': -100,
            'r_arm_z': 0}

arm.goto_position(rest_pos, duration=1, wait=True)
time.sleep(5)

with open('test.move') as f:
    m = Move.load(f)

print('Playing move in 2 seconds!')
time.sleep(1)
print('1')
time.sleep(1)

arm.compliant = False

move_player = MovePlayer(arm, m)
move_player.start()
