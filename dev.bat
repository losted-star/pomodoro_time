@echo off
setlocal
set "MSVC=C:\Program Files (x86)\Microsoft Visual Studio\18\BuildTools\VC\Tools\MSVC\14.51.36231"
set "SDK=C:\Program Files (x86)\Windows Kits\10"
set "PATH=%MSVC%\bin\Hostx64\x64;%SDK%\bin\10.0.26100.0\x64;%HOME%\.cargo\bin;%PATH%"
set "LIB=%MSVC%\lib\x64;%SDK%\lib\10.0.26100.0\ucrt\x64;%SDK%\lib\10.0.26100.0\um\x64;%LIB%"
set "INCLUDE=%MSVC%\include;%SDK%\include\10.0.26100.0\ucrt;%SDK%\include\10.0.26100.0\um;%SDK%\include\10.0.26100.0\shared;%INCLUDE%"
npx tauri dev
endlocal
