/****************************************************************************
CAN-Bus Demo

Toni Klopfenstein @ SparkFun Electronics
September 2015
https://github.com/sparkfun/CAN-Bus_Shield

This example sketch works with the CAN-Bus shield from SparkFun Electronics.

It enables the MCP2515 CAN controller and MCP2551 CAN-Bus driver, and demos
using the chips to communicate with a CAN-Bus.

Resources:

Development environment specifics:
Developed for Arduino 1.6.5

Based off of original example ecu_reader_logger by:
Sukkin Pang
SK Pang Electronics www.skpang.co.uk

This code is beerware; if you see me (or any other SparkFun employee) 
at the local, and you've found our code helpful, please buy us a round!

For the official license, please check out the license file included with the library.

Distributed as-is; no warranty is given.
*************************************************************************/

#include <Canbus.h>
char UserInput;
int data;
char buffer[456];  //Data will be temporarily stored to this buffer before being written to the file

//********************************Setup Loop*********************************//

void setup(){
Serial.begin(9600);
while (!Serial)
{
    // do nothing
} ;
Serial.println("CAN-Bus Demo");

if(Canbus.init(CANSPEED_500))  /* Initialise MCP2515 CAN controller at the specified speed */
  {
    Serial.println("CAN Init ok");
  } else
  {
    Serial.println("Can't init CAN");
  } 
   
  delay(1000); 

Serial.println("Please choose a menu option.");

}



//********************************Main Loop*********************************//

void loop(){
  

while(Serial.available()){
   UserInput = Serial.read();

data = Canbus.message_tx();
 Serial.print(data);
 delay(1000);
}
}

