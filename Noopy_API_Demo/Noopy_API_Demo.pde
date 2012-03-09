/*

 Noopy API sample code 
 Noopy Robot platform is a high level Arduino Clone Robot Interface board make 
 by InMojo.  This robot platform driver provides high level commands for driving DC 
 motors,  Servo motors, Analog Sensor read, SPI, I2C and many more. 
 
 Noopy API is made on top of the Noopy Robot class so that it is more easy to control 
 the sensors/actuators in the board without having to code from the begining. 
 
 Author: Charith Fernanado http://www.inmojo.com charith@inmojo.com 
 License: Released under the Creative Commons Attribution Share-Alike 3.0 License. 
 http://creativecommons.org/licenses/by-sa/3.0
 Target:  Arduino
 
 
 Library Instructions: (for details please refer API manual)
 ROBOT.BLUETOOTH_SETUP(char btName[11], unsigned long btCurrentBaudRate, unsigned long btNewBaudRate) 
 ROBOT.DC_MOTOR_CONTROL(int motorID, char status[4], int speed)
 SERVO_MOTOR_CONTROL(int motorID, int angle)
 NOOPY_API_LEVEL1(command, options, value)
 
 */

#include <NoopyAPI.h>
#include <Servo.h>

// Serial formatter directives
int incomingByte = 0;
int availableSerialBuffer = 0; 

int globalSpeed = 250; 
int dc1Speed = globalSpeed;
int dc2Speed = globalSpeed;
int dc3Speed = globalSpeed;
int dc4Speed = globalSpeed;
int rotSpeed = 175;
int servoAngle = 250; 

Servo servo1;  // create servo object 1 
Servo servo2;  // create servo object 2
Servo servo3;  // create servo object 3
Servo servo4;  // create servo object 4

int pos = 0;

// Function definition starts here......


void NOOPY_API_LEVEL1(char command[3], char option[2], char value[4]){
  int MOTOR_ID = int(option[0])-48; 

  if ((String)command == "DC"){
    //CLW, CCW. STP, BRK
    NOOPY.DC_MOTOR_CONTROL(MOTOR_ID, value, globalSpeed); 
    Serial.print("DC_MOTOR");
    Serial.print(MOTOR_ID);
    Serial.print(":");
    Serial.print((String)value);
    Serial.print(":");
    Serial.println(globalSpeed);

  }

  else if ((String)command == "SV"){
    int angle; 
    angle = 100*(value[0]-48) + 10*(value[1]-48) + value[2]-48; 
    SERVO_MOTOR_CONTROL(MOTOR_ID, angle); 
    Serial.print("SERVO_MOTOR");
    Serial.print(MOTOR_ID);
    Serial.print(":");
    Serial.println(angle);

  }

  else if ((String)command == "SP"){
    if((String)option == "G"){
      globalSpeed = 100*(value[0]-48) + 10*(value[1]-48) + value[2]-48; 
      Serial.print("Global Speed");
      Serial.print(":"); 
      Serial.println(globalSpeed);
    }
    else if((String)option == "1"){
      globalSpeed = 100*(value[0]-48) + 10*(value[1]-48) + value[2]-48; 
      Serial.print("DC1 Speed");
      Serial.print(":"); 
      Serial.println(dc1Speed);
    }
    else if((String)option == "2"){
      globalSpeed = 100*(value[0]-48) + 10*(value[1]-48) + value[2]-48; 
      Serial.print("DC2 Speed");
      Serial.print(":"); 
      Serial.println(dc2Speed);
    }
    else if((String)option == "3"){
      globalSpeed = 100*(value[0]-48) + 10*(value[1]-48) + value[2]-48; 
      Serial.print("DC3 Speed");
      Serial.print(":"); 
      Serial.println(dc3Speed);
    }
    else if((String)option == "4"){
      globalSpeed = 100*(value[0]-48) + 10*(value[1]-48) + value[2]-48; 
      Serial.print("DC4 Speed");
      Serial.print(":"); 
      Serial.println(dc4Speed);
    }
    else if((String)option == "R"){
      globalSpeed = 100*(value[0]-48) + 10*(value[1]-48) + value[2]-48; 
      Serial.print("Rotation Speed");
      Serial.print(":"); 
      Serial.println(rotSpeed);
    }
    else{
      Serial.println("err");
      return;
    }
  }

  else if (((String)command == "AN") && ((String)value == "?RD")){
    int analog_port = int(option[0])-48; 
    Serial.print("AN");
    Serial.print(analog_port);
    Serial.print(":"); 
    switch (analog_port){
    case 0:
      Serial.println(analogRead(AN0));
      break;
    case 1:  
      Serial.println(analogRead(AN1));
      break;
    case 2:
      Serial.println(analogRead(AN2));
      break;
    case 3:
      Serial.println(analogRead(AN3));
      break;
    case 4:
      Serial.println(analogRead(AN4));
      break;
    case 5:
      Serial.println(analogRead(AN5));
      break;
    default:
      Serial.println("err");
      return;
    }

  }

}

Motor Configuration 



(1)0| |0(2)
    | |
    | |
(3)0| |0(4)





void setMotorDaniel(int left, int right)
{
  Serial.print("left "); Serial.print(left); Serial.print(" right: "); Serial.println(right);
  
  if(left < 0) {
    NOOPY.DC_MOTOR_CONTROL(1, "CLW", -left); 
    NOOPY.DC_MOTOR_CONTROL(3, "CLW", -left); 
  } else {
    NOOPY.DC_MOTOR_CONTROL(1, "CCW", left); 
    NOOPY.DC_MOTOR_CONTROL(3, "CCW", left); 
  }
  if(right < 0) {
    NOOPY.DC_MOTOR_CONTROL(2, "CLW", -right); 
    NOOPY.DC_MOTOR_CONTROL(4, "CLW", -right); 
  } else {
    NOOPY.DC_MOTOR_CONTROL(2, "CCW", right); 
    NOOPY.DC_MOTOR_CONTROL(4, "CCW", right); 
  }
}


void NOOPY_API_LEVEL2(char command[3], char option[2], char value[4]){
  if (((String)command == "FW") && ((String)option == "D")){
    int robotSpeed; 
    robotSpeed = abs( 100*(value[0]-48) + 10*(value[1]-48) + value[2]-48 );
    Serial.print("forward "); Serial.println(robotSpeed);
    if( robotSpeed < 256 ) {
      setMotorDaniel( robotSpeed, robotSpeed ); 
      globalSpeed = robotSpeed; 
      Serial.print("MOV-FWD:");
      Serial.println(robotSpeed);
    } else {
      Serial.print("MOV-FWD:ERR");
    }
  }  
  else if (((String)command == "RE") && ((String)option == "V")){
    int robotSpeed; 
    robotSpeed = abs( 100*(value[0]-48) + 10*(value[1]-48) + value[2]-48 );
    robotSpeed = - robotSpeed; // because it is reverse.
    Serial.print("reverse "); Serial.println(robotSpeed);
 
    if( robotSpeed > -256 ) {
      setMotorDaniel( robotSpeed, robotSpeed ); 
      globalSpeed = robotSpeed; 
      Serial.print("MOV-REV:");
      Serial.println(-robotSpeed);
    } else {
      Serial.print("MOV-REV:ERR");
    }  
  }
  else if (((String)command == "ST") && ((String)option == "L")){
    int steerSpeed; 
    steerSpeed = abs(100*(value[0]-48) + 10*(value[1]-48) + value[2]-48);
    if(( (globalSpeed + steerSpeed) < 256 ) and ( (globalSpeed - steerSpeed) > -256 )) {
      setMotorDaniel( globalSpeed+steerSpeed, globalSpeed-steerSpeed);
      Serial.print("Steer-LEFT:");
      Serial.println(steerSpeed);
    }
    else
      Serial.println("Can't Steer, Reduce Steer");
  }
  else if (((String)command == "ST") && ((String)option == "R")){
    int steerSpeed; 
    steerSpeed = abs(100*(value[0]-48) + 10*(value[1]-48) + value[2]-48); 
    steerSpeed = -steerSpeed;
    if(( (globalSpeed + steerSpeed) < 256 ) and ((globalSpeed - steerSpeed) > -256 )) {
      setMotorDaniel( globalSpeed+steerSpeed, globalSpeed-steerSpeed);
      Serial.print("Steer-LEFT:");
      Serial.println(-steerSpeed);
    }
    else
      Serial.println("Can't Steer, Reduce Steer");
  }
  else if (((String)command == "RT") && ((String)option == "L")){
    int robotRotAngle; 
    robotRotAngle = 100*(value[0]-48) + 10*(value[1]-48) + value[2]-48; 
    if(robotRotAngle <= 360){
      NOOPY.DC_MOTOR_CONTROL(1, "CLW", rotSpeed); 
      NOOPY.DC_MOTOR_CONTROL(2, "CLW", rotSpeed); 
      NOOPY.DC_MOTOR_CONTROL(3, "CLW", rotSpeed); 
      NOOPY.DC_MOTOR_CONTROL(4, "CLW", rotSpeed); 
      delay(11*robotRotAngle);
      NOOPY.DC_MOTOR_CONTROL(1, "BRK", 0); 
      NOOPY.DC_MOTOR_CONTROL(2, "BRK", 0); 
      NOOPY.DC_MOTOR_CONTROL(3, "BRK", 0); 
      NOOPY.DC_MOTOR_CONTROL(4, "BRK", 0); 
      Serial.print("ROT-LEFT:");
      Serial.println(robotRotAngle);
    }
    else{
      NOOPY.DC_MOTOR_CONTROL(1, "CLW", rotSpeed); 
      NOOPY.DC_MOTOR_CONTROL(2, "CLW", rotSpeed); 
      NOOPY.DC_MOTOR_CONTROL(3, "CLW", rotSpeed); 
      NOOPY.DC_MOTOR_CONTROL(4, "CLW", rotSpeed); 
      Serial.print("ROT-LEFT-CONT"); 
    }

  }

  else if (((String)command == "RT") && ((String)option == "R")){
    int robotRotAngle; 
    robotRotAngle = 100*(value[0]-48) + 10*(value[1]-48) + value[2]-48; 
    if(robotRotAngle <= 360){
      NOOPY.DC_MOTOR_CONTROL(1, "CCW", rotSpeed); 
      NOOPY.DC_MOTOR_CONTROL(2, "CCW", rotSpeed); 
      NOOPY.DC_MOTOR_CONTROL(3, "CCW", rotSpeed); 
      NOOPY.DC_MOTOR_CONTROL(4, "CCW", rotSpeed); 
      delay(11*robotRotAngle);
      NOOPY.DC_MOTOR_CONTROL(1, "BRK", 0); 
      NOOPY.DC_MOTOR_CONTROL(2, "BRK", 0); 
      NOOPY.DC_MOTOR_CONTROL(3, "BRK", 0); 
      NOOPY.DC_MOTOR_CONTROL(4, "BRK", 0); 
      Serial.print("ROT-RIGHT:");
      Serial.println(robotRotAngle);
    }
    else{
      NOOPY.DC_MOTOR_CONTROL(1, "CCW", rotSpeed); 
      NOOPY.DC_MOTOR_CONTROL(2, "CCW", rotSpeed); 
      NOOPY.DC_MOTOR_CONTROL(3, "CCW", rotSpeed); 
      NOOPY.DC_MOTOR_CONTROL(4, "CCW", rotSpeed); 
      Serial.print("ROT-RIGHT-CONT"); 
    }
  }

  else if (((String)command == "BR") && ((String)option == "K")){
    int robotStopDelay; 
    robotStopDelay = 100*(value[0]-48) + 10*(value[1]-48) + value[2]-48; 
    delay(robotStopDelay);
    NOOPY.DC_MOTOR_CONTROL(1, "BRK", 0); 
    NOOPY.DC_MOTOR_CONTROL(2, "BRK", 0); 
    NOOPY.DC_MOTOR_CONTROL(3, "BRK", 0); 
    NOOPY.DC_MOTOR_CONTROL(4, "BRK", 0); 
    Serial.print("BRAKE:");
    Serial.println(robotStopDelay);
  }

  else if (((String)command == "ST") && ((String)option == "P")){
    int robotStopDelay; 
    robotStopDelay = 100*(value[0]-48) + 10*(value[1]-48) + value[2]-48; 
    delay(robotStopDelay);
    NOOPY.DC_MOTOR_CONTROL(1, "STP", 0); 
    NOOPY.DC_MOTOR_CONTROL(2, "STP", 0); 
    NOOPY.DC_MOTOR_CONTROL(3, "STP", 0); 
    NOOPY.DC_MOTOR_CONTROL(4, "STP", 0); 
    Serial.print("STOP:");
    Serial.println(robotStopDelay);
  }

  else if (((String)command == "AC") && ((String)option == "C")){
    if((String)value == "RDX"){
      Serial.print("KXM52-X: ");
      Serial.print(((analogRead(AN0)-512)*5)/(1023*0.66));
      Serial.println("mg");
      return; 
    }
    if((String)value == "RDY"){
      Serial.print("KXM52-Y: ");
      Serial.print(((analogRead(AN1)-512)*5)/(1023*0.66));
      Serial.println("mg");
      return; 
    }
    if((String)value == "RDZ"){
      Serial.print("KXM52-Z: ");
      Serial.print(((analogRead(AN2)-512)*5)/(1023*0.66));
      Serial.println("mg");
      return; 
    }
    if((String)value == "RDA"){
      Serial.print("KXM52-X: ");
      Serial.print(((analogRead(AN0)-512)*5)/(1023*0.66));
      Serial.print("mg, ");
      Serial.print("Y: ");
      Serial.print(((analogRead(AN1)-512)*5)/(1023*0.66));
      Serial.print("mg, ");
      Serial.print("Z: ");
      Serial.print(((analogRead(AN2)-512)*5)/(1023*0.66));
      Serial.println("mg");
      return; 
    }
  }

  else if (((String)command == "BN") && ((String)option == "D")){
    if((String)value == "?RD"){
      Serial.print("FS22 Bend: ");
      Serial.print(((float)analogRead(AN0)*5.0/1023)-1.0);
      Serial.println("V");
      return; 
    }
  }

  else if (((String)command == "DI") && ((String)option == "S")){
    if((String)value == "?RD"){
      int tmp = analogRead(AN0);
      if (tmp < 3){
        Serial.print("GP2Y distance: ");
        Serial.println("invalid");
        return;
      }
      else{

        Serial.print("GP2Y distance: ");
        Serial.print((1023*((float)tmp-220)/(5*2000)));
        Serial.println("mm");
      }  
      return; 
    }
  }

}

void SERVO_MOTOR_CONTROL(int motorID, int angle)   
{
  servo1.attach(SERVO1_PWM);     
  servo2.attach(SERVO2_PWM); 

  switch (motorID){
  case 1:
    servo1.write(angle); 
    break;
  case 2:
    servo2.write(angle); 
    break;
  case 3:
    servo3.write(angle); 
    break;
  case 4:
    servo4.write(angle); 
    break;

    delay(10);
  }

}

void setup()                    // run once, when the sketch starts
{
  NOOPY.BLUETOOTH_SETUP("Noopy-V2", 115200, 19200);
  Serial.begin(19200);  
}


void loop(){
  int i, j, k; 
  char command[3];  // 2 Byte
  char options[2];  // 1 Byte
  char value[4];    // 3 byte


  while(Serial.read() != '!'){
    digitalWrite(statusLED, LOW);   // sets the LED off
  }

  while (Serial.available() < 6){
  }

  for (i=0; i<2; i++) { 
    command[i] = Serial.read(); 
  } 
  command[i]=0; 

  for (j=0; j<1; j++) { 
    options[j] = Serial.read();
  } 
  options[j]=0; 

  for (k=0; k<3; k++) { 
    value[k] = Serial.read(); 
  } 
  value[k]=0; 

  NOOPY_API_LEVEL1(command, options, value); 
  NOOPY_API_LEVEL2(command, options, value); 

}



















