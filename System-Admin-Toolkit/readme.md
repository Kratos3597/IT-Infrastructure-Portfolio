# Enterprise System Administrator & Cloud Automation Toolkit

A collection of production-grade, parameterized PowerShell automation scripts designed to streamline identity governance, infrastructure health auditing, and cloud security monitoring. 

## Toolkit Overview

| Script Name | Target Environment | Core Functionality | Primary Modules Used |
| :--- | :--- | :--- | :--- |
| `Optimize-ADInfrastructure.ps1` | Hybrid / On-Premises AD | Automates stale account remediation, checks disk space thresholds, and flags failed critical services. | `ActiveDirectory`, `CimCmdlets` |
| `Microsoft 365 Cloud Security Script.ps1` | Microsoft 365 Cloud | Audits tenant security postures, identifying accounts lacking MFA and detecting hidden inbox forwarding rules. | `Microsoft.Graph` |

## Design Philosophy & Safety Guardrails
* **Zero Hardcoded Credentials:** All scripts utilize secure runtime authentication or interactive OAuth2 device logins.
* **Error Handling:** Built using strict `Try/Catch` blocks to ensure graceful termination without leaving unfinished system states.
* **Logging & Reporting:** Every script generates structured `.csv` file exports for change control tracking and compliance reporting.
