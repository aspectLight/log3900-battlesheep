@echo off
REM Launches the built Windows exe with DEV_INSTANCE=N. Use for 2nd, 3rd, ... instances.
REM For the 1st instance use "flutter run" to get hot reload and logs.
REM Usage: run_instance.bat [N] (default 1).
cd /d "%~dp0"
set DEV_INSTANCE=%~1
if "%DEV_INSTANCE%"=="" set DEV_INSTANCE=1
start "" "build\windows\x64\runner\Debug\client_leger.exe"
