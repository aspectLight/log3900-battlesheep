# Launches the built Windows exe with DEV_INSTANCE=N.
# Use for 2nd, 3rd, ... instances. For the 1st instance use "flutter run" to get hot reload and logs.
# Usage: .\run_instance.ps1 [N] (default 1).
$instance = if ($args.Count -gt 0) { $args[0] } else { "1" }
$env:DEV_INSTANCE = $instance
$exe = Join-Path $PSScriptRoot "build\windows\x64\runner\Debug\client_leger.exe"
Start-Process -FilePath $exe
