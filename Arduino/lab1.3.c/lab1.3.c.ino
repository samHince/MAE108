/*
Blink and printTurns on an LED on for one second, then off for one second, repeatedly.
Writes the state and the current time to the serial port.
*/

//// seyup vars ////

//// functions ////
void setup(){
  Serial.begin(9600);// Start serial communication
}

//// MAIN ////

// the loop function runs over and over again forever
void loop(){
  // read the input on analog pin 0:
  int sensorValue = analogRead(A0);
  // Convert the analog reading (which goes from 0 - 1023) to a voltage (0 - 5V):
  float voltage = sensorValue * (5.0 / 1023.0);
  // print out the value you read:
  Serial.println(voltage);
}
