# Harbour Client API Sample
The sample will show how to call the external API "https://api.zippopotam.us/us/90210".   
Code tested using the latest https://github.com/harbour/core   

## Windows Support
Currently the sample will function with the following C compilers:   
- msvc64, tested with Microsoft Visual Studio 2022   
- mingw64, tested with x86_64-8.1.0-win32-seh-rt_v6-rev0   

To add support to curl to Harbour do the following:
- Clone locally https://github.com/openssl/openssl   
- Clone locally https://github.com/curl/curl   
- Compile Harbour with setting equivalent to the ones described in the batch files in the "Microsoft_Windows_Files" folder located in this sample.   
   - CompileHarbourMinGW64.bat   
   - CompileHarbourMSVC64.bat   
- Get the curl Windows dll. Either use the one provided in this repo in the "Microsoft_Windows_Files" folder or get it using the official curl repo.   
- To get the official libcurl.dll   
   - https://chocolatey.org/install
   - https://community.chocolatey.org/packages/curl#install
   - Copy the file C:\ProgramData\chocolatey\lib\curl\tools\curl-8.2.1_1-win64-mingw\bin\libcurl-x64.dll as libcurl.dll   
- After you execute an initial \<Compile Release and Run\> or \<Compile Debug and Run\>, copy the libcurl.dll in the following subfolders:   
   - build\win64\msvc64\release  as "libcurl.dll"
   - build\win64\msvc64\debug  as "libcurl.dll"
   - build\win64\mingw64\release  as "(null).dll"  WARNING: There is a bug in the Mingw dynamic linking and the file name must be "(null).dll"   
   - build\win64\mingw64\debug  as "(null).dll"  WARNING: There is a bug in the Mingw dynamic linking and the file name must be "(null).dll"   

