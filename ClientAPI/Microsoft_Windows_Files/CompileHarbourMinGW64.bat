@echo off

set PATH=C:\Program Files\mingw-w64\x86_64-8.1.0-win32-seh-rt_v6-rev0\mingw64\bin;%PATH%

set HB_COMPILER=mingw64

set HB_STATIC_OPENSSL=yes
set HB_STATIC_CURL=yes

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