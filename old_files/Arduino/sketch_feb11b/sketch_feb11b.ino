//http://www.billporter.info/2010/08/18/ready-set-oscillate-the-fastest-way-to-change-arduino-pins/

#define _BV(bit) (1 << (bit))

void setup() {
  // put your setup code here, to run once:
  //Serial.begin(9600);
//while (!Serial)
//{
    // do nothing
//} ;
  DDRB = DDRB | B10000000;
  DDRF = DDRF | B00000001;
  //Serial.print(DDRF);
}

void loop() {
  // put your main code here, to run repeatedly:


  PORTB |= B10000000;
  PORTF |= B00000001;

  delay(100); 

  PORTB &= ~(B10000000);
  PORTF &= ~(B00000001);

  delay(100); 

}
