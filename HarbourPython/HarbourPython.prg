Function Main()

// See https://github.com/FiveTechSoft/harbour_python  for original solution for calling Python code in Harbour

local l_cPythonInstallPath := "C:\Pythons\3_11-64"     // Download Python 3.11 from https://www.python.org/downloads/. Update this path to your own install location
local l_cPythonDllFile     := "python311.dll"
local l_iCounter


DebugView("Starting Hello Python")

if hb_osIsWin7()  // Will also be valid for any versions after 7
    hb_SetEnv("PYTHONHOME",l_cPythonInstallPath)      // Only needed in Windows.
    // hb_SetEnv("PYTHONPATH",l_cPythonInstallPath)   // Not needed in this sample.
                                                      // PYTHONPATH can be set to point to additional directories with private libraries in them.
endif

Py_Initialize()

// for l_iCounter := 1 to 1   // Did run a test for up to 1 million calls to Math(), and no failures or memory overruns detected.
    // ?l_iCounter,Math()
// endfor
// 
// if hb_osIsWin7()
    // Plot()  // Will only render in Windows. Docker only supports text output.
// endif

?SayHello()
?Power(2.1,3.1)
?Power(2.1,3)

Py_Finalize()

DebugView("Completed Hello Python")

return nil
//====================================================================================
function Math()

local l_xResult

local hModule, hFunc, hNum, hResult
hModule := PyImport_ImportModule( "math" ) 
hFunc := PyObject_GetAttrString( hModule, "sqrt" ) 
hNum := PyFloat_FromDouble( 25 ) 
hResult := PyObject_CallFunctionObjArgs( hFunc, hNum ) 

l_xResult := PyFloat_AsDouble( hResult )

altd()

Py_Decref( hNum )
Py_Decref( hFunc )
Py_Decref( hModule )

return l_xResult
//====================================================================================
function Plot()

// From a VSCODE cmd terminal run the following once to install globally the mathplotlib package
//     In Windows
//          set path=C:\pythons\3_11-64\;C:\pythons\3_11-64\scripts\;%PATH%
//          python --version
//          pip install matplotlib
//     In Dev Container / Ubunutu
//          pip install matplotlib
//
// To view the current list of packages:  pip list


local hList1, hList2, hModule, hFunc1, hFunc2, hResult
// local hPyPlot_savefig

// Py_Initialize()
hList1 = PyList_New( 5 )
PyList_SetItem( hList1, 0, PyFloat_FromDouble( 1 ) )
PyList_SetItem( hList1, 1, PyFloat_FromDouble( 2 ) )
PyList_SetItem( hList1, 2, PyFloat_FromDouble( 3 ) )
PyList_SetItem( hList1, 3, PyFloat_FromDouble( 4 ) )
PyList_SetItem( hList1, 4, PyFloat_FromDouble( 5 ) )

hList2 = PyList_New( 5 )
PyList_SetItem( hList2, 0, PyFloat_FromDouble( 1 ) )
PyList_SetItem( hList2, 1, PyFloat_FromDouble( 4 ) )
PyList_SetItem( hList2, 2, PyFloat_FromDouble( 9 ) )
PyList_SetItem( hList2, 3, PyFloat_FromDouble( 16 ) )
PyList_SetItem( hList2, 4, PyFloat_FromDouble( 25 ) )

hModule = PyImport_ImportModule( "matplotlib.pyplot" ) 
hFunc1 = PyObject_GetAttrString( hModule, "plot" ) 
hResult = PyObject_CallFunctionObjArgs( hFunc1, hList1, hList2 )

// ?"hResult: ",hResult

hFunc2 = PyObject_GetAttrString( hModule, "show" ) 
hResult = PyObject_CallFunctionObjArgs( hFunc2 )

// hPyPlot_savefig = PyObject_CallMethod( hModule, "savefig" )
// PyObject_CallMethod( hPyPlot_savefig, PyUnicode_FromString( "/workspaces/HarbourPython/plot001.png" ) )


Py_Decref( hList1 )
Py_Decref( hList2 )
// Py_Finalize()

return nil
//====================================================================================
function SayHello()

local l_xResult

local hModule, hFunc, hNum, hResult
hModule := PyImport_ImportModule("HarbourSample001") 
hFunc := PyObject_GetAttrString( hModule,"SayHello") 
hNum := PyUnicode_FromString( "Eric" ) 
hResult := PyObject_CallFunctionObjArgs( hFunc, hNum ) 

l_xResult := PyString_AsString( hResult )

altd()

Py_Decref( hNum )
Py_Decref( hFunc )
Py_Decref( hModule )

return l_xResult
//====================================================================================
function Power(par_x,par_y)

local l_xResult

local hModule, hFunc, hNumX, hNumY, hResult
hModule := PyImport_ImportModule( "HarbourSample001" ) 
hFunc := PyObject_GetAttrString( hModule, "power" ) 
hNumX := PyFloat_FromDouble( par_x ) 
hNumY := PyFloat_FromDouble( par_y ) 
hResult := PyObject_CallFunctionObjArgs( hFunc, hNumX, hNumY) 

l_xResult := PyFloat_AsDouble( hResult )

altd()

Py_Decref( hNumX )
Py_Decref( hNumY )
Py_Decref( hFunc )
Py_Decref( hModule )


return l_xResult  //par_x**par_y
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
