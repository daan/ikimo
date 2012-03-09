
import serial
import glob


def byteToString( i ) :
  """convert a 0-255 value to a 3 digit string"""
  i = min( 255, i )
  i = max( 0, i )
  s = str(i)
  s = "000"[0:-len(s)] + s
  return s

def listControllers():
  """return a list of suitable devices"""
  return glob.glob('/dev/cu.*')

class Ikimo :
  """a class for serial communication with Ikimo Robot Controller"""
  ser = None

  def open( self, device, baud=192600 ) :
    """open a link to an ikimo device. default baudrate is 192600"""
    self.ser = serial.Serial( device, baud, timeout=0, parity=serial.PARITY_NONE, stopbits=1, bytesize = 8 )
    self.ser.flushInput()
    self.ser.flushOutput()
    print "serial link active"

  def waitForResponse(self) :
    "read characters from serial until a CR is found."
    response = ""  
    # here something waiting for an !
    while self.ser.inWaiting():
      c = self.ser.read(1)
      if c == '\r':
        return response
      response += c

  def sendCmd( self, cmd, options, values ) :
    # if values is not a string convert it to a string.
    if type(values) != type(" ") :  
      values = byteToString( values )
    if type(options) != type(" ") :
      options = str( options )
    cmd = "!" + cmd + options + values + "\r"
    print cmd
    self.ser.write(cmd)
    print self.waitForResponse()

  def sendCmd2( self, cmd, values ):
    if type(values) != type(" ") :
      values = byteToString(values)
    cmd = "!" + cmd + values + "\r"
    print cmd
    self.ser.write(cmd)


  def dcClockWise( self, which ):
    self.sendCmd("DC", which, "CLW")
  
  def dcCCW( self, which ) :
    self.sendCmd("DC", which, "CCW")
  
  def dcStop( self, which ) :
    self.sendCmd("DC", which, "STP")
  
  def dcBreak( self, which) :
    self.sendCmd("DC", which, "BRK")
  
  def dcSpeed( self, which, speed ) :  
    self.sendCmd( "SP", which, speed )

  def readAnalog( self, which ) :
    return self.sendCmd( "AN", which, "?RD" )

  def servoAngle( self, which, angle ) :
    self.send( "SV", which, angle )



  def fwd( self, speed ) :
    self.sendCmd2( "FWD", speed )
  
  def rev( self, speed ) :
    self.sendCmd2( "REV", speed )
   
  def stl( self, value ) :
    self.sendCmd2( "STL", value )

  def str( self, value ) :
    self.sendCmd2( "STR", value )


   