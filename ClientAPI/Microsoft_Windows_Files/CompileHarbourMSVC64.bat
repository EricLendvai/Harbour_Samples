@echo off

set HB_COMPILER=msvc64

call "%ProgramFiles%\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" x86_amd64
set HB_COMPILER_VER==2022

set HB_STATIC_OPENSSL=yes
set HB_STATIC_CURL=yes
rem set HB_BUILD_MODE=c       Not needed since default is "c"

rem To not suppress line number information. The ProcLine() function will return actual source code line numbers.
set HB_USER_PRGFLAGS=-l-

rem Clone locally the following repo: https://github.com/openssl/openssl
set HB_WITH_OPENSSL=R:\github\openssl\include

rem Clone locally the following repo: https://github.com/curl/curl
set HB_WITH_CURL=R:\github\curl\include

c:
cd c:\Harbour

del .\src\common\obj\win\msvc64\hbver.obj
del .\src\common\obj\win\msvc64\hbver_dyn.obj
del .\src\common\obj\win\msvc64\hbverdsp.obj

rem use the following command in case changing compiler version 
rem win-make clean

"C:\WINDOWS\system32\cmd.exe" /k win-make

pause
