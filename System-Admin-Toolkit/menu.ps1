while ($true) {

    Clear-Host

    Write-Host "===================================="
    Write-Host "     SYSTEM ADMIN TOOLKIT"
    Write-Host "===================================="
    Write-Host ""
    Write-Host "1. System Tools (Shutdown/Restart)"
    Write-Host "2. Active Directory Tools"
    Write-Host "3. Microsoft 365 Tools"
    Write-Host "4. Network Tools"
    Write-Host "5. Exit"
    Write-Host ""

    $choice = Read-Host "Select option"

    switch ($choice) {

        "1" { & "$PSScriptRoot\modules\system.ps1" }
        "2" { & "$PSScriptRoot\modules\ad.ps1" }
        "3" { & "$PSScriptRoot\modules\m365.ps1" }
        "4" { & "$PSScriptRoot\modules\network.ps1" }
        "5" { exit }

        default {
            Write-Host "Invalid option"
            Start-Sleep 1
        }
    }
}
