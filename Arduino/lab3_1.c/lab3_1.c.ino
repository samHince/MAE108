#include <Wire.h>
#include <LSM303.h>
#include <Servo.h>
#include <math.h>

Servo myservo;
int servoPin = 3;       // Pin that the servomotor is connected to
int pos = 90;            // variable to store the servo position, varies from 0 to 180
float target;
float heading;
float delta;

LSM303 compass;

// Time variables
unsigned long currentMillis;  // time in milliseconds
unsigned long oldMillis;  // previous measurement of time in millseconds
unsigned long oldServoMillis;  // previous measurement of time when we moved servo in millseconds

void setup() {
  Serial.begin(9600);
  Wire.begin();
  compass.init();
  compass.enableDefault();
  currentMillis = millis(); // initialize time
  oldMillis = currentMillis;
  
  /*
  Calibration values; the default values of +/-32767 for each axis
  lead to an assumed magnetometer bias of 0. Use the Calibrate example
  program to determine appropriate values for your particular unit.
  */
  //min: { -1693,  -1045,  +4140}    max: {  +298,  +1408,  +5423}
  compass.m_min = (LSM303::vector<int16_t>){ -1693,  -1045,  +4140}; //{-32767, -32767, -32767};
  compass.m_max = (LSM303::vector<int16_t>){  +298,  +1408,  +5423}; //{+32767, +32767, +32767};
  myservo.attach(servoPin);               // attaches the servo toservoPin

  compass.read();
  target = compass.heading();
}

void loop() {

    compass.read();
  /*
  When given no arguments, the heading() function returns the angular
  difference in the horizontal plane between a default vector and
  north, in degrees.
  
  The default vector is chosen by the library to point along the
  surface of the PCB, in the direction of the top of the text on the
  silkscreen. This is the +X axis on the Pololu LSM303D carrier and
  the -Y axis on the Pololu LSM303DLHC, LSM303DLM, and LSM303DLH
  carriers.
  
  To use a different vector as a reference, use the version of heading()
  that takes a vector argument; for example, use
  compass.heading((LSM303::vector<int>){0, 0, 1});
  to use the +Z axis as a reference.
  */
    heading = compass.heading();
    delta = (heading - target); 
    delta = fmod(delta, 360);
    pos = 90 + delta;
    myservo.write(pos);
    delay(1);

}
