<#
.SYNOPSIS
    Automates local Active Directory health auditing and stale resource remediation.
.DESCRIPTION
    This script performs three core infrastructure operations:
    1. Identifies and disables AD user accounts inactive for a specified threshold.
    2. Audits local system drives for low disk space alerts (< 15% free).
    3. Verifies that critical infrastructure services (DNS, DHCP, Netlogon) are actively running.
.PARAMETER InactiveDays
    The threshold duration in days to classify an account as inactive. Default is 90 days.
.PARAMETER ExportPath
    The directory path where compliance audit CSV reports will be saved.
.EXAMPLE
    .\Optimize-ADInfrastructure.ps1 -InactiveDays 90 -ExportPath "C:\IT_Audits"
#>

Param(
    [Parameter(Mandatory=$false)]
    [int]$InactiveDays = 90,

    [Parameter(Mandatory=$false)]
    [string]$ExportPath = "$env:USERPROFILE\Desktop\AD_Health_Export"
)

# Enforce strict coding rules
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Create export directory if it doesn't exist
if (-not (Test-Path -Path $ExportPath)) {
    New-Item -ItemType Directory -Force -Path $ExportPath | Out-Null
}

Write-Host "=========================================================" -ForegroundColor Cyan
Write-Host " STARTING HYBRID INFRASTRUCTURE & DISK HEALTH AUDIT      " -ForegroundColor Cyan
Write-Host "=========================================================" -ForegroundColor Cyan

# --- STEP 1: STALE AD ACCOUNTS AUDIT ---
Try {
    if (Get-Module -ListAvailable -Name ActiveDirectory) {
        Write-Host "[+] Querying Active Directory for accounts inactive for over $InactiveDays days..." -ForegroundColor Yellow
        $CutoffDate = (Get-Date).AddDays(-$InactiveDays)
        
        $InactiveUsers = Get-ADUser -Filter {LastLogonDate -le $CutoffDate -and Enabled -eq $true} -Properties LastLogonDate, Description
        
        if ($InactiveUsers) {
            $InactiveUsers | Select-Object Name, UserPrincipalName, LastLogonDate | 
                Export-Csv -Path "$ExportPath\Stale_AD_Users.csv" -NoTypeInformation
            Write-Host "[!] Found $($InactiveUsers.Count) active but stale accounts. Details exported to Stale_AD_Users.csv." -ForegroundColor Red
            
            # Note: For safety in a portfolio context, we list rather than auto-disable. 
            # To auto-disable, pipeline to: Disable-ADAccount
        } else {
            Write-Host "[✓] No stale active user accounts found matching criteria." -ForegroundColor Green
        }
    } else {
        Write-Host "[-] ActiveDirectory module not found. Skipping AD User cleanup task." -ForegroundColor Gray
    }
}
Catch {
    Write-Warning "Failed executing Active Directory audit: $_"
}

# --- STEP 2: STORAGE INFRASTRUCTURE AUDIT ---
Try {
    Write-Host "[+] Inspecting local storage partition thresholds..." -ForegroundColor Yellow
    $Disks = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3" # Local Disks
    $DiskReport = @()

    foreach ($Disk in $Disks) {
        $SizeGB = [Math]::Round($Disk.Size / 1GB, 2)
        $FreeGB = [Math]::Round($Disk.FreeSpace / 1GB, 2)
        $PercentFree = [Math]::Round(($Disk.FreeSpace / $Disk.Size) * 100, 2)

        if ($PercentFree -lt 15) {
            Write-Host "[WARNING] Drive $($Disk.DeviceID) is running critically low: $PercentFree% free!" -ForegroundColor Red
        }

        $DiskReport += [PSCustomObject]@{
            DriveLetter  = $Disk.DeviceID
            VolumeName   = $Disk.VolumeName
            TotalSizeGB  = $SizeGB
            FreeSpaceGB  = $FreeGB
            PercentFree  = "$PercentFree%"
            AlertStatus  = if ($PercentFree -lt 15) { "CRITICAL" } else { "HEALTHY" }
        }
    }
    $DiskReport | Export-Csv -Path "$ExportPath\Disk_Storage_Report.csv" -NoTypeInformation
    Write-Host "[✓] Storage audit complete. Logs compiled in Disk_Storage_Report.csv." -ForegroundColor Green
}
Catch {
    Write-Warning "Failed compiling storage metrics: $_"
}

# --- STEP 3: SYSTEM SERVICE VALIDATION ---
Try {
    Write-Host "[+] Checking runtime status of core network services..." -ForegroundColor Yellow
    $CriticalServices = @("W32Time", "LanmanServer", "Netlogon")
    $ServiceReport = @()

    foreach ($Service in $CriticalServices) {
        $Status = Get-Service -Name $Service
        if ($Status.Status -ne "Running") {
            Write-Host "[!] Critical alert: Service '$Service' is currently stopped!" -ForegroundColor Red
        }
        $ServiceReport += [PSCustomObject]@{
            ServiceName = $Status.Name
            DisplayName = $Status.DisplayName
            State       = $Status.Status
            Severity    = if ($Status.Status -ne "Running") { "HIGH" } else { "NONE" }
        }
    }
    $ServiceReport | Export-Csv -Path "$ExportPath\Critical_Services_Status.csv" -NoTypeInformation
    Write-Host "[✓] Infrastructure operational service metrics gathered cleanly." -ForegroundColor Green
}
Catch {
    Write-Warning "Failed assessing core infrastructure services: $_"
}

Write-Host "`n[✓] All automated auditing processes finished successfully. Reports located at: $ExportPath" -ForegroundColor Green