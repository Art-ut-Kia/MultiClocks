/**
 * MultiClockHmi.ino: Human-Machine Interface for Multi-Clock sub-assembly
 * Project: MultiClock (FPGA based clock generators)
 * Author: JPP 2019/04
 */

//--------------------------- Define LCD interface -----------------------------
#include "LiquidCrystal.h"
LiquidCrystal lcd(A5, A4, A3, A2, A1, A0);

// custom characters for LCD
byte varChar[] = { // variation symbol char (digit edition mode)
  B00100, B01110, B11011, B00000, B11011, B01110, B00100, B00000};
byte pfpChar[] = { // positive field pointer char (selected field)
  B00011, B11010, B11010, B00010, B11010, B11010, B00011, B00000};
byte nfpChar[] = { // negative field pointer char (non-selected fields)
  B00000, B11000, B11000, B00000, B11000, B11000, B00000, B00000};

//--------- Define interface and state variables for rotary encoder ------------
#include "RotaryEncoderEditorU.h"
TRotaryEncoderEditor ree;

#define dnPin   2 // nota: Up/Down pins are required
#define upPin   3 // to generate interrupts
#define pushPin 4
#define gndPin  5
volatile unsigned char encodPos = 0;
volatile unsigned char prevSend = 0;
volatile unsigned char prevUpdn = 0;
volatile unsigned char prevChan = -1;

//---------------- Clock generator interface & clocks settings -----------------
#include <SPI.h>

#define SpiSS 10 // SPI Slave Select
SPISettings ClockGenSpiSettings(
  8000000,  // max for arduino UNO
  MSBFIRST,
  SPI_MODE0
);
// 2nd argument for setClock()
#define PERIOD     0
#define PULSEWIDTH 1
// default settings
struct {
   int64_t period, pulsewidth;
} setting[10]= {
   {  500000,  458333}, // RISE computer (200Hz, 0.41667ms low state = UART char 0xF8 at 9600/8-N-1, displayed as "x" in 7-bit ASCII)
   { 1000000,  500000}, // AVRS #1 (100Hz, square)
   { 1000000,  500000}, // AVRS #2 (100Hz)
   {10000000, 5000000}, // GNSS #1 (10Hz)
   {10000000, 5000000}, // GNSS #2 (10Hz)
   {  200000,  100000}, // spare (500Hz)
   {  300000,  150000}, // spare (333Hz)
   {  400000,  200000}, // spare (250Hz)
   {  500000,  250000}, // spare (200Hz)
   {  600000,  300000}  // spare (167Hz)
};

#include <EEPROM.h>

//-------------------------------------------------------------------------------
void setup() {
   // ................... Serial Interface initialization for debug trace .......
   Serial.begin (115200);

   // ........................... SPI initialization ............................
   pinMode(SpiSS, OUTPUT); digitalWrite(SpiSS, HIGH);
   SPI.begin();
   SPI.beginTransaction(ClockGenSpiSettings);
   
   // ...................... retrieve settings from EEPROM ......................
   // check that EEPROM contains MultiClock settings
   char signature[] = "0123456789";
   EEPROM.get(245, signature);
   signature[10] = '\0';
   if (strcmp(signature, "MultiClock") != 0) {
      // first time usage => fill in the EEPROM with default values
      strncpy(signature, "MultiClock", 11);
      for (int i=0; i<sizeof(setting); i++) EEPROM.update(i, ((byte*)setting)[i]);
      for (int i=0; i<11; i++) EEPROM.update(245+i, signature[i]);
   } else EEPROM.get(0, setting);
   // configures all 10 channels of the FPGA (frequency & duty cycle)
   for (int i=0; i<10; i++) {
      setClock(i, PERIOD, setting[i].period);
      setClock(i, PULSEWIDTH, setting[i].pulsewidth);
   }
   setClock(31, 0, 2); // all clock generators are configured, now enable FPGA ...
                       // ... internal 100MHz clock (data = 2 so that 1 is actually sent)

   // ......................... Rotary Encoder Initialization ...................
   // turns built-in LED off
   pinMode(13, OUTPUT); digitalWrite(13, LOW);
   // configures inputs connected to switches as inputs w/ pullup resistors
   pinMode(upPin,   INPUT);  digitalWrite(upPin,   HIGH);
   pinMode(dnPin,   INPUT);  digitalWrite(dnPin,   HIGH);
   pinMode(pushPin, INPUT);  digitalWrite(pushPin, HIGH);
   // configures "ground pin" as output, low level (so that it actually acts as a ground pin)
   pinMode(gndPin,  OUTPUT); digitalWrite(gndPin,  LOW);
   // updateEncoder() will be called on any change of up/down inputs
   attachInterrupt(0, updateEncoder, CHANGE);
   attachInterrupt(1, updateEncoder, CHANGE);

   // ................................ LCD initialization .......................
   lcd.begin(16, 2);
   lcdSplashScreen();
   lcd.createChar(1, varChar);
   lcd.createChar(2, pfpChar);
   lcd.createChar(3, nfpChar);
   lcd.setCursor(0, 0);
   lcd.print("C    P");
   lcd.setCursor(0, 1);
   lcd.print("M    W");

   // ...................... Rotary Encoder Menu Initialization .................
   char channel = 0;
   ree.addField(1, 0, channel);                     // Channel
   ree.addField(8, 5, setting[channel].period);     // Period
   ree.addField(8, 5, setting[channel].pulsewidth); // Width of positive pulse
   ree.addField(0, 0, 0);                           // Memorize command
   lcdDisplay();

   // .......................... end of initializations .........................
}
//-------------------------------------------------------------------------------
void loop() {
   unsigned char toSend = (encodPos >> 2) | (digitalRead(pushPin) ? 0x00 : 0x80); 
   if (toSend != prevSend) {
      char incr = (toSend & 0x7f) - (prevSend & 0x7f);
      if (incr < -32) incr += 64;
      if (incr >  31) incr -= 64;
      bool pressed = (toSend & 0x80) != 0;
      if (incr!=0 || pressed) {
         ree.encoderEvent(incr);
         lcdDisplay();
      }
      if ((toSend & 0x80) != (prevSend & 0x80)) delay(10); // push-button debouncing
      prevSend = toSend;
   }
}
//-------------------------------------------------------------------------------
void updateEncoder() {
   static const char incr[16] = {
      0,-1, 1, 0,
      1, 0, 0,-1,
     -1, 0, 0, 1,
      0, 1,-1, 0
   };
   unsigned char updn = (digitalRead(upPin) << 1) | digitalRead(dnPin);
   encodPos += incr[(prevUpdn << 2) | updn];
   prevUpdn = updn;
}
//-------------------------------------------------------------------------------
void lcdSplashScreen() {
   lcd.home();
   lcd.write("   Multi-Clock  ");
   lcd.setCursor(0, 1);
   lcd.write("10 clockk gen's ");
   delay(3000);
   lcd.home();
   lcd.write("   Multi-Clock  ");
   lcd.setCursor(0, 1);
   lcd.write("(c) JP PETILLON ");
   if (digitalRead(pushPin) == 1) while (1);
   while (digitalRead(pushPin) == 0);
}
//-------------------------------------------------------------------------------
void lcdDisplay() {
   // manages channel change
   unsigned char channel = ree.fieldValue(0);
   if (channel != prevChan) { // if channel was changed => ...
      // ... updates displayed Period & Width fields accordingly ...
      ree.setField(1, setting[channel].period);
      ree.setField(2, setting[channel].pulsewidth);
      prevChan = channel;
   } else {
      // otherwise stores the period/width
      int64_t data = ree.fieldValue(1);
      if (setting[channel].period != data) {
         setting[channel].period = data;
         setClock(channel, PERIOD, data);
      }
      data = ree.fieldValue(2);
      if (setting[channel].pulsewidth != data) {
         setting[channel].pulsewidth = data;
         setClock(channel, PULSEWIDTH, data);
      }
   }
   
   // display fields
   lcd.setCursor(1, 0); lcd.print(ree.outString(0)); // channel
   lcd.setCursor(6, 0); lcd.print(ree.outString(1)); // period
   lcd.setCursor(6, 1); lcd.print(ree.outString(2)); // pulse width
   lcd.setCursor(1, 1); lcd.print(ree.outString(3)); // memorize command
      
   // set cursor position
   char curPos = -1;
   char fi = -1; // field index
   for (char i=0; i<4; i++) {
      char fieldCurPos = ree.curPos(i);
      if (fieldCurPos>=0) {
         fi = i;
         curPos = fieldCurPos;
      }
   }
   if (fi >= 0) {
      lcd.setCursor(
         (fi==0 || fi==3) ? curPos + 1 : curPos + 6,
         (fi==2 || fi==3) ? 1 : 0
      );
      lcd.cursor();
      // manages memorize command
      if ((fi == 3) && ree.outString(3)[0]!=':') {
         ree.encoderEvent(0);
         lcd.noCursor();
         lcd.setCursor(1, 1); lcd.print("\x02\xff");
         for (int i=0; i<sizeof(setting); i++) EEPROM.update(i, ((byte*)setting)[i]);
         delay(1000);
         lcd.setCursor(1, 1); lcd.print("\x02 ");
      }
   } else lcd.noCursor();
}
//-------------------------------------------------------------------------------
// send an SPI command to the clock generator based on Spartan-6 FPGA
void setClock(char Channel, char pw, int64_t data) {

   // send the command over UART for debug
   Serial.print("channel: "); Serial.print(Channel, DEC);
   switch (pw) {
      case PERIOD:     Serial.print(" period: "); break;
      case PULSEWIDTH: Serial.print(" pulseW: "); break;
   }
   Serial.println((unsigned long int)data);

   // send actual SPI command to Spartan-6
   // bit [4] = [0=PERIOD; 1=PULSEWIDTH]
   // bits [3..0] = channel index (0..9)
   if (pw==PULSEWIDTH) Channel |= 0x10;  
   char spiBuf[5];
   spiBuf[4] = Channel;
   data--; // to get a counter by N, count from 0 to data-1
   memcpy(&spiBuf[0], &data, 4);
   digitalWrite(SpiSS, LOW);
   // channel transmitted first, then data (MSByte first) 
   for (int i=4; i>=0; i--) SPI.transfer(spiBuf[i]);
   digitalWrite(SpiSS, HIGH);
}
//-------------------------------------------------------------------------------
