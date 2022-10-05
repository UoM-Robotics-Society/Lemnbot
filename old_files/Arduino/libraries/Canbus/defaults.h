#ifndef	DEFAULTS_H
#define	DEFAULTS_H
/*
#define	P_MOSI	B,3
#define	P_MISO	B,4
#define	P_SCK	B,5

//#define	MCP2515_CS			D,3	// Rev A
#define	MCP2515_CS			B,2 // Rev B
#define	MCP2515_INT			D,2
#define LED2_HIGH			B,0
#define LED2_LOW			B,0
*/

//Leonardo defines
#define	P_MOSI	B,2
#define	P_MISO	B,3
#define	P_SCK	B,1

//#define	MCP2515_CS			D,3	// Rev A
#define	MCP2515_CS			B,0 // Rev B
#define	MCP2515_INT			E,6
//Not sure if these will work...
#define LED2_HIGH			F,0
#define LED2_LOW			F,0

#endif	// DEFAULTS_H
