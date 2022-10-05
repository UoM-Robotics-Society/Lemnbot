import ikpy
import numpy as np
from ikpy import plot_utils

my_chain = ikpy.chain.Chain.from_urdf_file("ikpy-master/resources/poppy_arm.URDF")