int analogPin = A0;    // select the input pin for the potentiometer
int ledPin = 23;   // select the pin for the LED
int motorPin = 9;
int val = 0;       // variable to store the value coming from the sensor

void setup() {
  pinMode(ledPin, OUTPUT);  // declare the ledPin as an OUTPUT
  //pinMode(analogPin, INPUT);
  Serial.begin(9600);
}

void loop() {
  val = analogRead(analogPin);    // read the value from the sensor
  val = val >> 2;
  Serial.println(val);
  analogWrite(motorPin,val);
  //digitalWrite(ledPin, HIGH);  // turn the ledPin on
  //digitalWrite(analogPin, HIGH);  // turn the ledPin on
  //delay(val);              // wait for a second
  //digitalWrite(ledPin, LOW);   // turn the ledPin off
  //digitalWrite(analogPin, LOW);  // turn the ledPin on
  //delay(val);                  // stop the program for some time
}

