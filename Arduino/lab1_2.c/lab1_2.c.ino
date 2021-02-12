/*
Blink and printTurns on an LED on for one second, then off for one second, repeatedly.
Writes the state and the current time to the serial port.
*/

//// seyup vars ////

int freq = 4;
int led = 13;
bool ledState = HIGH;

// initialize other vars
float dt;
int currentTime;
//bool state;

//// functions ////

// switch LED state 
bool swtich(bool state){
  if(state){
    state = LOW;
  }else{
    state = HIGH;
  }
  return state;
}


void setup(){
  // initialize digital pin 13 as an output.
  pinMode(led, OUTPUT);
  Serial.begin(9600);// Start serial communication

  //cofigure timer interups (register compare based intereupts)
  cli();//stop interrupts
  
    //set timer1 interrupt at 1Hz
    TCCR1A = 0;// set entire TCCR1A register to 0
    TCCR1B = 0;// same for TCCR1B
    TCNT1  = 0;//initialize counter value to 0
    
    // set compare match register for 1hz increments
    OCR1A = 3905;//15624;//((16*10^6) / (1*(freq * 1000))) - 1; // [16,000,000Hz/ (prescaler * desired interrupt frequency)] - 1 (must be <65536)
    
    // turn on CTC mode
    TCCR1B |= (1 << WGM12);
    
    // Set CS12 and CS10 bits for 1024 prescaler
    TCCR1B |= (1 << CS12) | (1 << CS10);  
    
    // enable timer compare interrupt
    TIMSK1 |= (1 << OCIE1A);
  
  sei();//allow interrupts
}


//// interupt service routines ////
  
ISR(TIMER1_COMPA_vect){
  ledState = swtich(ledState);
}

//// MAIN ////

// the loop function runs over and over again forever
void loop(){
//  dt=millis() % transitionTime;// Get milliseconds since the arduino was turned on
//  
  digitalWrite(led, ledState);
  currentTime = (millis()/1000) % 2;
  
  Serial.print(ledState);
  Serial.print("\t");
  Serial.println(currentTime);
  Serial.print("\n");

}
