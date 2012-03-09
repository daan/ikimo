from ikimo import *

import pygame

pygame.init()

print "number of joysticks:", pygame.joystick.get_count()


j = pygame.joystick.Joystick(0)
j.init()
print 'Initialized Joystick : %s' % j.get_name()
try:
    while True:
        pygame.event.pump()
        for i in range(0, j.get_numaxes()):
            if j.get_axis(i) != 0.00:
                print 'Axis %i reads %.2f' % (i, j.get_axis(i))
        for i in range(0, j.get_numbuttons()):
            if j.get_button(i) != 0:
                print 'Button %i reads %i' % (i, j.get_button(i))
except KeyboardInterrupt:
    j.quit()

#
#i = Ikimo()
#i.open('/dev/cu.kcSerial-KC-SPP')
#

