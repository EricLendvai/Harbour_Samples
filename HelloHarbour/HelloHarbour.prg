#define MAXLOOP 9

Function Main()
local l_loop

DebugView("Starting Hello World")

FOR l_loop := 1 to MAXLOOP
    ?"Hello Harbour " + alltrim(str(l_loop))
    IF l_loop == 4
        AltD()
        ?"Paused Debugger" 
    ENDIF
END

DebugView("Completed Hello World")

RETURN nil
//====================================================================================
function DebugView(par_cMessage)
#ifdef DEBUGVIEW   // The DEBUGVIEW precompiler variable is defined in BuildEXE.bat. 
    WindowsDebugView("[Harbour] "+par_cMessage)
#ENDIF
return nil
//====================================================================================
#pragma BEGINDUMP
#include "hbapi.h"
#ifdef _WIN32   // Only MS Windows has DebugView
#include <windows.h>
#endif

HB_FUNC( WINDOWSDEBUGVIEW )
{
#ifdef _WIN32
   OutputDebugString( hb_parc(1) );
// #else
//     TRACE("Will appear only in the debugger's output window while debugging");
#endif
}
#pragma ENDDUMP
//====================================================================================
