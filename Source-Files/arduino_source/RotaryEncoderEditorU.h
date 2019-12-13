/**
 *  RotaryEncoderEditorU.h: Rotary Encoder Fields editor Unit
 *
 */

//------------------------------------------------------------------------------
#ifndef RotaryEncoderEditorUH
#define RotaryEncoderEditorUH

// emulate arduino 64-bit integers
#ifdef __BORLANDC__
  typedef __int64 int64_t;
#else
# include <stdint.h>
#endif

class TRotaryEncoderFieldEditor; // pre-declaration

//------------------------------------------------------------------------------
class TRotaryEncoderEditor {

private: 
   char fieldEditCount, fieldIndex;
   TRotaryEncoderFieldEditor* pFieldEdit[16];

public:
   TRotaryEncoderEditor ();
   void addField (char digits, char decimals, int64_t outIni);
   void encoderEvent (char incr); // incr: -1=left ; 0=push ; 1=right
   int64_t fieldValue (char index);
   void setField (char index, int64_t val);
   char* outString (char index);
   char curPos (char index); // return cursor position (or -1 if no cursor)
   char editingField;
};

//------------------------------------------------------------------------------
class TRotaryEncoderFieldEditor {

private:
   char digits, decimals, editPos;
   bool selDigMod;
   int64_t outMax;
   char outStr[17];

public:
   TRotaryEncoderFieldEditor (char digits, char decimals, int64_t outIni);
   bool encoderEvent (char incr); // -1=left ; 0=push ; 1=right
   char* outString (bool Editing);
   char curPos;
   int64_t out;
};

//------------------------------------------------------------------------------

#endif // RotaryEncoderEditorUH
