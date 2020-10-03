@echo off
if %1. == . goto MissingParameter
if %2. == . goto MissingParameter
if %3. == . goto MissingParameter
if %2. == debug.   goto GoodParameter
if %2. == release. goto GoodParameter

echo You must send the "C-compiler type", "debug" or "release", and the name of the program (folder and exe) as parameters
goto End

:GoodParameter

set CCompiler=%1
set BuildMode=%2
set EXEName=%3

set PATH=C:\Program Files\mingw-w64\x86_64-8.1.0-win32-seh-rt_v6-rev0\mingw64\bin;C:\Harbour\bin\win\mingw64;C:\HarbourTools;%PATH%
set HB_COMPILER=%CCompiler%
set HB_PATH=C:\Harbour
set ROOT_PATH=C:\HarbourTestCode-64\VSCODE

C:
md "%ROOT_PATH%\%EXEName%\%CCompiler%\" 2>nul
md "%ROOT_PATH%\%EXEName%\%CCompiler%\%BuildMode%\" 2>nul
cd "%ROOT_PATH%\%EXEName%\" 2>nul

del "%CCompiler%\%BuildMode%\%EXEName%.exe" 2>nul
if exist "%CCompiler%\%BuildMode%\%EXEName%.exe" (
	echo Could not delete previous version of "%CCompiler%\%BuildMode%\%EXEName%.exe"
	goto End
)

::	-b        = debug
::  -w3       = warn for variable declarations
::  -es2      = process warning as errors
::  -gc3      = Pure C code with no HVM
::  -p        = Leave generated ppo files

::  The -dDONOTINCLUDE  will create a #define that can be use to exclude code, especially needed when doing #includes of entire .prg files

if %BuildMode% == debug (
    copy "%ROOT_PATH%\debugger_on.hbm" "%ROOT_PATH%\%EXEName%\debugger.hbm" >nul
    hbmk2 "%EXEName%.hbp" -b -p -dDONOTINCLUDE
) else (
    copy "%ROOT_PATH%\debugger_off.hbm" "%ROOT_PATH%\%EXEName%\debugger.hbm" >nul
    hbmk2 "%EXEName%.hbp" -dDONOTINCLUDE
)

if not exist "%CCompiler%\%BuildMode%\%EXEName%.exe" (
	echo Failed To build "%CCompiler%\%BuildMode%\%EXEName%.exe"
) else (
	if errorlevel 0 (
		echo.
		echo No Errors
		echo.
		echo Ready          BuildMode = %BuildMode%          C Compiler = %CCompiler%
        if %BuildMode% == release (
            echo -----------------------------------------------------------------------------------------------
            "%CCompiler%\%BuildMode%\%EXEName%.exe"
            echo.
            echo -----------------------------------------------------------------------------------------------
        )
	) else (
		echo Compilation Error
		if errorlevel  1 echo Unknown platform
		if errorlevel  2 echo Unknown compiler
		if errorlevel  3 echo Failed Harbour detection
		if errorlevel  5 echo Failed stub creation
		if errorlevel  6 echo Failed in compilation (Harbour, C compiler, Resource compiler)
		if errorlevel  7 echo Failed in final assembly (linker or library manager)
		if errorlevel  8 echo Unsupported
		if errorlevel  9 echo Failed to create working directory
		if errorlevel 19 echo Help
		if errorlevel 10 echo Dependency missing or disabled
		if errorlevel 20 echo Plugin initialization
		if errorlevel 30 echo Too deep nesting
		if errorlevel 50 echo Stop requested
	)
)


goto End
:MissingParameter
echo Missing Parameters. This batch file is called from VSCode Tasks
:End