while ($true) {

    Clear-Host
    Write-Host "===== SYSTEM TOOLS ====="
    Write-Host "1. Shutdown Now"
    Write-Host "2. Restart Now"
    Write-Host "3. Back"

    $choice = Read-Host "Select option"

    switch ($choice) {

        "1" { shutdown /s /t 0 }

        "2" { shutdown /r /t 0 }

        "3" { return }

        default {
            Write-Host "Invalid option"
            Start-Sleep 1
        }
    }
}
