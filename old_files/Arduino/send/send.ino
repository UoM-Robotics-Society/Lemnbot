/***************************************************************************
  Hobbytronics Leonardo CAN-BUS board

  Send Test Data to other nodes
  
  Leonardo CAN BUS product page  http://www.hobbytronics.co.uk/leonardo-canbus
   
  Hobbytronics.co.uk
****************************************************************************/

#include <mcp_can.h>
#include <SPI.h>

int led = 23;

MCP_CAN CAN0(17);           // Set CS to pin 17

void setup()
{
   Serial.begin(9600);
   /*while (!Serial)
  {
    //do nothing
  } ;*/
   Serial.print("Can Test..\r\n");
   // init can bus, baudrate: 500k
   if(CAN0.begin(CAN_125KBPS) == CAN_OK) Serial.print("can init ok!!\r\n");
   else Serial.print("Can init fail!!\r\n");
   pinMode(led, OUTPUT);
}

unsigned char stmp[8] = {0, 1, 2, 3, 4, 5, 6, 7};
void loop()
{
   // send data:  id = 0x00, standard frame, data len = 8, stmp: data buf
   digitalWrite(led, HIGH);   // turn the LED on   
   CAN0.sendMsgBuf(0x00, 0, 8, stmp);  
   delay(100);
   digitalWrite(led, LOW);   // turn the LED off  
   delay(900);                       // send data every second
}

