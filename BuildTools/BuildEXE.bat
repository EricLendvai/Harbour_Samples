@echo off

if %EXEName%. == . goto MissingEnvironmentVariables
if %BuildMode%. == . goto MissingEnvironmentVariables
if %HB_COMPILER%. ==. goto MissingEnvironmentVariables

if not exist %EXEName%_windows.hbp (
    echo Invalid Workspace Folder. Missing file %EXEName%_windows.hbp
    goto End
)

if %BuildMode%. == debug.   goto GoodParameters
if %BuildMode%. == release. goto GoodParameters
echo You must set Environment Variable BuildMode as "debug" or "release"
goto End

:GoodParameters

rem if %HB_COMPILER% == msvc64 call "%ProgramFiles(x86)%\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" x86_amd64
if %HB_COMPILER% == msvc64 call "%ProgramFiles%\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" x86_amd64

if %HB_COMPILER% == mingw64 set PATH=C:\Program Files\mingw-w64\x86_64-8.1.0-win32-seh-rt_v6-rev0\mingw64\bin;%PATH%

set HB_PATH=C:\Harbour
set PATH=%HB_PATH%\bin\win\%HB_COMPILER%;%PATH%
rem set PATH=C:\Harbour\bin\win\mingw64;%PATH%

rem set PATH=C:\Program Files\mingw-w64\x86_64-8.1.0-win32-seh-rt_v6-rev0\mingw64\bin;C:\Harbour\bin\win\mingw64;%PATH%

set ROOT_PATH=%CD%

:: set ROOT_PATH_DRIVE=%CD:~0,2%
:: %ROOT_PATH_DRIVE%

md "%ROOT_PATH%\build\" 2>nul
md "%ROOT_PATH%\build\win64\" 2>nul
md "%ROOT_PATH%\build\win64\%HB_COMPILER%\" 2>nul
md "%ROOT_PATH%\build\win64\%HB_COMPILER%\%BuildMode%\" 2>nul
md "%ROOT_PATH%\build\win64\%HB_COMPILER%\%BuildMode%\hbmk2\" 2>nul

del "%ROOT_PATH%\build\win64\%HB_COMPILER%\%BuildMode%\%EXEName%.exe" 2>nul
if exist "%ROOT_PATH%\build\win64\%HB_COMPILER%\%BuildMode%\%EXEName%.exe" (
    echo Could not delete previous version of "%ROOT_PATH%\build\win64\%HB_COMPILER%\%BuildMode%\%EXEName%.exe"
    goto End
)

if %COPY_PYTHON_DLL_SOURCE%. == . goto NotWithPython
if %COPY_PYTHON_DLL_DESTINATION%. == . goto NotWithPython
copy %COPY_PYTHON_DLL_SOURCE% %COPY_PYTHON_DLL_DESTINATION%
:NotWithPython

::	-b        = debug
::  -w3       = warn for variable declarations
::  -es2      = process warning as errors
::  -gc3      = Pure C code with no HVM
::  -p        = Leave generated ppo files

:: Purposely create a hbmk2 folder so in case we are building with "-inc" in the .hbp we can see the generated c files.
:: The -dDEBUGVIEW will enable the MS Windows DebugView tool

:: The -dDONOTINCLUDE is used to facilitate "#ifndef DONOTINCLUDE" in prg files.

if %BuildMode% == debug (
    hbmk2 "%EXEName%_windows.hbp" ..\BuildTools\vscode_debugger.prg -b -p -w3 -dDEBUGVIEW -dDONOTINCLUDE -workdir="%ROOT_PATH%\build\win64\%HB_COMPILER%\%BuildMode%\hbmk2\"
) else (
    hbmk2 "%EXEName%_windows.hbp" -dDEBUGVIEW -dDONOTINCLUDE -workdir="%ROOT_PATH%\build\win64\%HB_COMPILER%\%BuildMode%\hbmk2\" -static
)

if not exist "%ROOT_PATH%\build\win64\%HB_COMPILER%\%BuildMode%\%EXEName%.exe" (
    echo Failed To build "%ROOT_PATH%\build\win64\%HB_COMPILER%\%BuildMode%\%EXEName%.exe"
) else (
    if errorlevel 0 (
        echo.
        echo No Errors
        echo.
        echo Ready          BuildMode = %BuildMode%          C Compiler = %HB_COMPILER%
        if %BuildMode% == release (
            echo -----------------------------------------------------------------------------------------------
            "%ROOT_PATH%\build\win64\%HB_COMPILER%\%BuildMode%\%EXEName%.exe"
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
:MissingEnvironmentVariables
echo Missing Environment Variables
:End