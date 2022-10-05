#include <NewPing.h>
#define TRIGGERPIN 12
#define ECHOPIN 11

int ledPin = 9;      // LED connected to digital pin 9

int PWMPIN0 = 3;   // potentiometer connected to analog pin 3
int PWMPIN1 = 2;

int val = 0;         // variable to store the read value

NewPing sonar(TRIGGERPIN, ECHOPIN);

void setup()
{
  Serial.begin(115200);
  pinMode(PWMPIN0, OUTPUT);   // sets the pin as output
  pinMode(PWMPIN1, OUTPUT);   // sets the pin as output  
}

void loop()

{
  delay(200);
  int uS = sonar.ping_cm();
  Serial.println(uS);

  if (uS < 30)
  {
    analogWrite(PWMPIN0, 0);
    analogWrite(PWMPIN1, 0);
  }
  else
  {
    analogWrite(PWMPIN0, 200);
    analogWrite(PWMPIN1, 200);
  }
  
  /*
  delay(500);
  delay(500);
  delay(500);
  delay(500);
  analogWrite(analogPin,100);  // analogRead values go from 0 to 1023, analogWrite values from 0 to 255
  delay(500);
  delay(500);
  delay(500);
  delay(500);
  analogWrite(analogPin,200);  // analogRead values go from 0 to 1023, analogWrite values from 0 to 255
  */
}
