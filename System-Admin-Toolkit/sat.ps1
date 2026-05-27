$repo = "https://github.com/Kratos3597/System-Admin-Toolkit"
$local = "$env:TEMP\SAT"

if (!(Test-Path $local)) {
    git clone $repo $local
}
else {
    cd $local
    git pull
}

powershell -ExecutionPolicy Bypass -File "$local\menu.ps1"
