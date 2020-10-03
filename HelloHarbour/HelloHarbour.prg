#define MAXLOOP 5

Function Main()
local l_loop

MyOutputDebugString("[Harbour] Starting Hello World")

FOR l_loop := 1 to MAXLOOP
    ?"Hello Harbour " + alltrim(str(l_loop))
    IF l_loop == 3
        AltD()
        ?"Paused Debugger" 
    ENDIF
END

MyOutputDebugString("[Harbour] Completed Hello World")

RETURN nil
//====================================================================================
#pragma BEGINDUMP

#include <windows.h>
#include "hbapi.h"

HB_FUNC( MYOUTPUTDEBUGSTRING )
{
   OutputDebugString( hb_parc(1) );
}

#pragma ENDDUMP
