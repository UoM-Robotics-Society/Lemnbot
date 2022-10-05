import itertools
import numpy
import time
import json

import pypot.dynamixel

if __name__ == '__main__':
    ports = pypot.dynamixel.get_available_ports()

    if not ports:
        raise IOError('no port found')

    print('ports found', ports)


    #find mx28s
    print('connecting on first available port:', ports[0])
    dxl_io = pypot.dynamixel.DxlIO(ports[0])

    print('connected!')

    ids = dxl_io.scan([50,51,52,53,54])
    print('found ids:', ids)



    #find xl320s
    print('connecting on first available port:', ports[1])
    dxl_io2 = pypot.dynamixel.Dxl320IO(ports[1])

    print('connected!')

    ids2 = dxl_io2.scan([55,56,57,58])
    print('found ids:', ids2)


    #print(dxl_io.get_present_position([54]))

    #dxl_io.enable_torque(ids)
    #speed = dict(zip([54], itertools.repeat(100)))
    #dxl_io.set_moving_speed(speed)

    #while True:
     #   pos = dict(zip([54], itertools.repeat(127)))
      #  dxl_io.set_goal_position(pos)

#        time.sleep(3)

 #       pos = dict(zip([54], itertools.repeat(-10)))
  #      dxl_io.set_goal_position(pos)

#        time.sleep(3)



