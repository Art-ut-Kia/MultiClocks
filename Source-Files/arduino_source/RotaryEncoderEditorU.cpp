/**
 *  RotaryEncoderEditorU.cpp: Rotary Encoder Fields editor Unit
 */

#include "RotaryEncoderEditorU.h"
#include <stdio.h> // for sprintf()

//==============================================================================
// TRotaryEncoderEditor methods
//==============================================================================
TRotaryEncoderEditor::TRotaryEncoderEditor() {
   fieldEditCount = fieldIndex = editingField = 0;
   for (char i=0; i<16; i++) pFieldEdit[i] = NULL;
}
//------------------------------------------------------------------------------
void TRotaryEncoderEditor::addField(char di, char de, int64_t o) {
   pFieldEdit[fieldEditCount++] = new TRotaryEncoderFieldEditor(di, de, o);
}
//------------------------------------------------------------------------------
void TRotaryEncoderEditor::encoderEvent (char incr) {
   if (editingField == 1) {
      if (!pFieldEdit[fieldIndex]->encoderEvent(incr)) editingField = 0;
   } else {
      fieldIndex += incr;
      if (fieldIndex < 0) fieldIndex = (char)(fieldEditCount - 1);
      if (fieldIndex > fieldEditCount - 1) fieldIndex = 0;
      if (incr == 0) editingField = 1;
   }
}
//------------------------------------------------------------------------------
int64_t TRotaryEncoderEditor::fieldValue (char i) {
   return pFieldEdit[i]->out;
}
//------------------------------------------------------------------------------
void TRotaryEncoderEditor::setField(char i, int64_t val) {
   pFieldEdit[i]->out = val;
}
//------------------------------------------------------------------------------
char* TRotaryEncoderEditor::outString (char i) {
   return pFieldEdit[i]->outString(i == fieldIndex);
}
//------------------------------------------------------------------------------
char TRotaryEncoderEditor::curPos (char i) {
   if (i==fieldIndex && editingField) return pFieldEdit[i]->curPos;
   else return -1;
}
//==============================================================================
// TRotaryEncoderFieldEditor methods
//==============================================================================
TRotaryEncoderFieldEditor::TRotaryEncoderFieldEditor(char di,char de,int64_t o){
   this->digits = di;
   this->decimals = de;
   outMax = 1;
   for (char i=0; i<digits; i++) outMax *= 10;
   outMax--;
   out = o;
   editPos = 0;
   selDigMod = true;
}
//------------------------------------------------------------------------------
bool TRotaryEncoderFieldEditor::encoderEvent(char incr) {
   if (incr == 0) {
      if (editPos > 0) selDigMod = !selDigMod;
      else {
         return false;
      }
   } else {
      if (selDigMod) {
         editPos += incr;
         if (editPos < 0) editPos = 0;
         if (editPos > digits) editPos = digits;
      } else {
         if (editPos > 0) {
            int64_t mult = 1;
            for (char i=1; i<digits - editPos + 1; i++) mult *= 10;
            int64_t newout = out + mult * incr;
            if (newout<0) newout = 0;
            if ((int64_t)newout>outMax) newout = outMax;
            out = newout;
         }
      }
   }
   return true;
}
//------------------------------------------------------------------------------
char* TRotaryEncoderFieldEditor::outString(bool Editing) {
   curPos = editPos;
   if (curPos>digits-decimals) curPos++;
   if (Editing) outStr[0] = selDigMod ? '\x02' : '\x01';
   else outStr[0] = '\x03';
   char format[6];
   sprintf(format,"%%0%dld",digits);
   sprintf(&outStr[1], format, out);
   for (char i=1; i<=decimals; i++) {
      char j = digits - i + 2;
      outStr[j] = outStr[j-1];
   }
   if (decimals>0) {
      outStr[digits - decimals + 1] = '.';
      outStr[digits + 2] = '\0';
   } else {
      outStr[digits + 1] = '\0';
   }
   return &outStr[0];
}
//------------------------------------------------------------------------------
