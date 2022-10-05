/***************************************************************************
  Hobbytronics Leonardo CAN-BUS board

  Receive Test Data (no filters)
  Send output data via serial port
  
  Leonardo CAN BUS product page  http://www.hobbytronics.co.uk/leonardo-canbus
   
  Hobbytronics.co.uk
****************************************************************************/

#include <mcp_can.h>
#include <SPI.h>

unsigned int rxId;
unsigned char rxLen = 0;
unsigned char rxBuf[8];
volatile unsigned char canData = 0;
int led = 23;

MCP_CAN CAN0(17);                                 // Set CS to pin 17

void setup()
{
   Serial.begin(9600);
      while (!Serial)
{
    // do nothing
} ;
   CAN0.begin(CAN_125KBPS);                       // init can bus : baudrate = 500k 
   attachInterrupt(4, can_receive, FALLING);      // Pin D7 is Interrupt4 on Leonardo
   Serial.println("MCP2515 Library Receive Example...");
   pinMode(led, OUTPUT);
}

void loop()
{
   if(canData)
   {
      canData=0;
      digitalWrite(led, HIGH);   // turn the LED on  
      CAN0.readMsgBuf(&rxLen, rxBuf);            // Read data: len = data length, buf = data byte(s)
      rxId = CAN0.getCanId();                    // Get message ID

      Serial.print("ID: ");
      Serial.print(rxId, HEX);
      Serial.print("  Data: ");
      for(int i = 0; i < rxLen; i++)                // Print each byte of the data
      {
         if(rxBuf[i] < 0x10)                     // If data byte is less than 0x10, add a leading zero
         {
            Serial.print("0");
         }
         Serial.print(rxBuf[i], HEX);
         Serial.print(" ");
      }
      Serial.println();
      digitalWrite(led, LOW);   // turn the LED off
   }
}

void can_receive()
{
   // CAN Receive Interrupt  
   canData = 1;
}

