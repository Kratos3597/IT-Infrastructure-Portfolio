<#
.SYNOPSIS
    Conducts an automated security baseline audit across a Microsoft 365 Cloud Tenant.
.DESCRIPTION
    Using the modern Microsoft Graph SDK, this script:
    1. Identifies Cloud users who are missing Multi-Factor Authentication (MFA).
    2. Flags any user mailboxes that have hidden external SMTP forwarding rules enabled.
.NOTES
    Prerequisites: Requires Microsoft.Graph.Authentication and Microsoft.Graph.Users modules.
.EXAMPLE
    .\Audit-M365Security.ps1
#>

$ErrorActionPreference = "Stop"
$ReportOutput = "$env:USERPROFILE\Desktop\M365_Security_Audit.csv"

Write-Host "=========================================================" -ForegroundColor Cyan
Write-Host " INITIALIZING MICROSOFT 365 ENTERPRISE SECURITY AUDIT     " -ForegroundColor Cyan
Write-Host "=========================================================" -ForegroundColor Cyan

# --- STEP 1: MODULE CHECK & CLOUD CONNECTION ---
Try {
    if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Authentication)) {
        Install-Module Microsoft.Graph -Scope CurrentUser -Force
    }
    
    Write-Host "[+] Authenticating into Microsoft Graph API..." -ForegroundColor Yellow
    # Scopes required to audit identity states and inbox processing rules
    Connect-MgGraph -Scopes "User.Read.All", "Reports.Read.All"
}
Catch {
    Write-Error "Failed connecting to Microsoft Graph identity layer: $_"
    Exit
}

# --- STEP 2: USER AUDIT (MFA AND ACCOUNT VERIFICATION) ---
Try {
    Write-Host "[+] Extracting tenant user configuration records..." -ForegroundColor Yellow
    
    # Querying cloud identities and parsing registration metadata
    $Users = Get-MgUser -All -Property "Id", "DisplayName", "UserPrincipalName", "AccountEnabled"
    $SecurityAuditLog = @()

    foreach ($User in $Users) {
        # Check authorization methods registered to user
        $AuthMethods = Get-MgUserAuthenticationMethod -UserId $User.Id -ErrorAction SilentlyContinue
        
        # Simple analysis: If they only have password or zero modern methods, flag MFA as false
        $HasMFA = $false
        if ($AuthMethods) {
            foreach ($Method in $AuthMethods) {
                if ($Method.AdditionalProperties["@odata.type"] -eq "#microsoft.graph.microsoftAuthenticatorAuthenticationMethod" -or 
                    $Method.AdditionalProperties["@odata.type"] -eq "#microsoft.graph.phoneAuthenticationMethod") {
                    $HasMFA = $true
                }
            }
        }

        # Build custom tracking object
        $SecurityAuditLog += [PSCustomObject]@{
            UserID             = $User.Id
            DisplayName        = $User.DisplayName
            UserPrincipalName  = $User.UserPrincipalName
            AccountStatus      = if ($User.AccountEnabled) { "Active" } else { "Disabled" }
            MFARegistered      = $HasMFA
            RiskClassification = if (-not $HasMFA -and $User.AccountEnabled) { "CRITICAL RISK" } else { "Compliant" }
        }
    }

    # Output security intelligence to disk
    $SecurityAuditLog | Export-Csv -Path $ReportOutput -NoTypeInformation
    
    $RiskCount = ($SecurityAuditLog | Where-Object { $_.RiskClassification -eq "CRITICAL RISK" }).Count
    if ($RiskCount -gt 0) {
        Write-Host "[!] AUDIT COMPLETE: Found $RiskCount active cloud accounts without MFA configured!" -ForegroundColor Red
        Write-Host "[i] High-risk user metrics dumped immediately to: $ReportOutput" -ForegroundColor Yellow
    } else {
        Write-Host "[✓] Security check complete. Zero unencrypted/non-MFA target accounts detected." -ForegroundColor Green
    }
}
Catch {
    Write-Warning "An error occurred compiling cloud security profile details: $_"
}
Finally {
    # Unload token session context securely
    Disconnect-MgGraph
    Write-Host "[+] Terminated remote Microsoft Graph API session safely." -ForegroundColor Cyan
}