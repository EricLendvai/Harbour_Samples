#include "hbclass.ch"

#ifndef DONOTINCLUDE
//The following is a fake header to make VSCODE not error on the method declarations
//Ensure buildexe.bat defines the DONOTINCLUDE pre-compiler variable. See line: hbmk2 "%EXEName%.hbp" -dDONOTINCLUDE
class Cars
    //Don't have to worry about hidden or protected classifications, since this is only a fake header.
    data Model init ""
    data Version

    method ExtraMethod()

endclass
#endif   /* DONOTINCLUDE */

method ExtraMethod() class Cars
    Altd()
    ?"Called ExtraMethod on "+::Model+" Version="+::Version
return NIL