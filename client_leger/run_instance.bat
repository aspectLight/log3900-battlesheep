@echo off
REM Launches the built Windows Debug exe (e.g. second window). Use flutter run for hot reload.
cd /d "%~dp0"
start "" "build\windows\x64\runner\Debug\client_leger.exe"
