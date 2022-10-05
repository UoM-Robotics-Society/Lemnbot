from pypot.dynamixel import autodetect_robot

my_arm = autodetect_robot()

for m in my_arm.motors:
    print(m.present_position)

