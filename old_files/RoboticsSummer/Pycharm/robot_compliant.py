import itertools
import numpy
import time
import json
from contextlib import closing

import pypot.dynamixel
import pypot.robot

from pypot.robot import from_json


arm = pypot.robot.from_json('poppy_arm_poc.json')

arm.compliant = True


print(arm.motors)