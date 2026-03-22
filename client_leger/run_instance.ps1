# Launches the built Windows Debug exe (e.g. second window). Use flutter run for hot reload.
$exe = Join-Path $PSScriptRoot "build\windows\x64\runner\Debug\client_leger.exe"
Start-Process -FilePath $exe
