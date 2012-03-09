from ikimo import *
import time


i = Ikimo()
i.open('/dev/cu.kcSerial-KC-SPP')

while 1:

  print "go forward"
  i.fwd(100)
  i.stl(15)
  time.sleep(3)


  print "go backward"
  i.rev(100)
  i.str(15)
  time.sleep(3)

time.sleep(5)

while 1:
  i.fwd(50)
  i.str(10)
  time.sleep(2)

  i.rev(50)
  i.stl(10)
  time.sleep(2)
 


while 1:
  i.fwd(50)
  i.str(10)
  time.sleep(2)

  i.fwd(50)
  i.stl(10)
  time.sleep(2)

  i.dcBreak(0 )
  time.sleep(1)
  i.rev(50)
  i.str(10)
  time.sleep(2)

  i.rev(50)
  i.stl(10)
  time.sleep(2)


