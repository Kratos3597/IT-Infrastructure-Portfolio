$base = "https://raw.githubusercontent.com/Kratos3597/IT-Infrastructure-Portfolio/main/System-Admin-Toolkit"
$local = "$env:TEMP\SAT"

# Create folder
if (!(Test-Path $local)) {
    New-Item -ItemType Directory -Path $local | Out-Null
}

# Download required files
Invoke-RestMethod "$base/menu.ps1" -OutFile "$local\menu.ps1"
Invoke-RestMethod "$base/system.ps1" -OutFile "$local\system.ps1"

# Run menu
powershell -ExecutionPolicy Bypass -File "$local\menu.ps1"
