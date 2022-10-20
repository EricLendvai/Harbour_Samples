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
#ifdef DEBUGVIEW   // The DEBUGVIEW precompiler variable is defined in BuildEXE.bat and BuildEXE.sh
    if hb_osIsWin7()
        DebugViewOrTrace("[Harbour] "+par_cMessage)
    else
        DebugViewOrTrace(par_cMessage)  // No need to prefix with [Harbour], since the SysLog call will also prefix it.
    endif
#endif
return nil
//====================================================================================
#pragma BEGINDUMP
#include "hbapi.h"
#ifdef _WIN32   // Only MS Windows has DebugView
    #include <windows.h>
#else
    #include <syslog.h>
#endif

HB_FUNC( DEBUGVIEWORTRACE )
{
#ifdef _WIN32
   OutputDebugString( hb_parc(1) );  // Using Windows DebugView
#else
    setlogmask(LOG_UPTO (LOG_DEBUG));
    openlog("[Harbour]", LOG_PID | LOG_NDELAY, LOG_LOCAL1);
    syslog(LOG_DEBUG, hb_parc(1));
    closelog();
#endif
}
#pragma ENDDUMP
//====================================================================================
//v1