# Uptime Kuma Infrastructure Monitoring & Alerting Deployment
### Xcelerate Outsourcing — Centralized Monitoring & Security Alerting System

# Project Overview

Implemented a centralized infrastructure monitoring and alerting platform using Docker-based Uptime Kuma hosted on Windows Server to improve visibility, uptime tracking, and incident response across critical business systems and branch services at Xcelerate Outsourcing.

The deployment provided proactive monitoring, automated notifications, uptime reporting, and centralized infrastructure visibility across internal and external services while reducing dependency on costly enterprise monitoring platforms.

The monitoring environment was fully containerized using Docker and configured with automated startup and recovery procedures to ensure continuous monitoring availability after server reboots, maintenance windows, Windows updates, or power interruptions.

---

# Objectives

- Centralize infrastructure monitoring into a single platform
- Reduce operational downtime through proactive alerting
- Improve visibility across branch and cloud infrastructure
- Monitor mission-critical business systems
- Implement low-cost enterprise-grade monitoring
- Improve SLA response and incident handling
- Enable automated recovery of monitoring services
- Reduce dependency on expensive third-party monitoring platforms

---

# Infrastructure & Services Monitored

## Communication & Voice Systems

- RealConnect PBX infrastructure
- SIP service connectivity
- VoIP gateway uptime
- WAN latency affecting voice quality
- Communication service failures

## Security & Surveillance Systems

- CCTV NVR devices
- Camera network connectivity
- Surveillance infrastructure uptime
- Security network availability

## Business Applications

- SwordFish application endpoints
- Internal web services
- Application response times
- Database connectivity availability

## Printer & Device Monitoring

- Network printers
- Branch office devices
- Print servers
- Internal network-connected devices

## Server & Infrastructure Monitoring

- Windows Servers
- Domain Controllers
- Hypervisor hosts
- File servers
- Backup infrastructure
- VPN services

## Network Infrastructure Monitoring

- Routers
- Firewalls
- Switches
- WAN connectivity
- Internet services

## External & Cloud Services

- Public websites
- HTTPS endpoints
- Microsoft 365 services
- External APIs
- SSL certificate validity

---

# Technologies Used

| Technology | Purpose |
|---|---|
| Windows Server | Monitoring host platform |
| Docker | Container runtime |
| Docker Compose | Service orchestration |
| Uptime Kuma | Infrastructure monitoring & alerting |
| SMTP Integration | Automated email notifications |
| Reverse Proxy | Secure dashboard access |
| SSL Certificates | Secure HTTPS connectivity |

---

# Windows Server Deployment Environment

## Server Preparation

- Installed latest Windows Server updates
- Configured static IP addressing
- Configured DNS settings
- Hardened Windows Firewall rules
- Enabled remote management access
- Optimized server resources for container workloads

---

# Docker Installation & Configuration

- Installed Docker Engine / Docker Desktop
- Installed Docker Compose
- Enabled container support
- Configured persistent storage volumes
- Enabled automatic service startup
- Configured container restart policies

---

# Uptime Kuma Deployment Process

## Docker Compose Configuration

```yaml
version: '3'

services:
  uptime-kuma:
    image: louislam/uptime-kuma:latest
    container_name: uptime-kuma
    volumes:
      - uptime-kuma:/app/data
    ports:
      - 3001:3001
    restart: always

volumes:
  uptime-kuma:
```

---

## Deployment Steps

1. Created deployment directory
2. Added Docker Compose file
3. Initialized Docker volumes
4. Pulled Uptime Kuma image
5. Started container
6. Verified dashboard access
7. Confirmed persistence

### Commands

```bash
docker compose up -d
```

```bash
docker ps
```

```bash
docker logs uptime-kuma
```

---

# Initial Configuration

- Admin account setup
- Monitoring groups created
- Device categorization
- Alert thresholds configured
- Notification channels added

---

# Monitoring Configuration

## Ping Monitoring

Used for:
- Routers
- Switches
- Printers
- CCTV devices
- Servers

## HTTP/HTTPS Monitoring

Used for:
- Internal applications
- Websites
- Microsoft 365 services
- Cloud services

## TCP Monitoring

Used for:
- PBX systems
- SIP services
- VPN services
- SQL services
- RDP services

## SSL Monitoring

Used for:
- Certificates expiry tracking
- HTTPS validation

---

# Alerting & Notifications

- SMTP email alerts configured
- Device offline notifications
- Service failure alerts
- Recovery notifications
- SSL expiry warnings

---

# Dashboard & Reporting

- Real-time infrastructure dashboard
- Uptime percentage tracking
- Historical downtime reports
- SLA visibility
- Incident tracking

---

# Security Hardening

- Firewall restrictions applied
- Secure admin authentication
- SSL reverse proxy access
- Persistent volume protection
- Access control policies

---

# Automated Startup & Recovery

## Objective

Ensure Uptime Kuma automatically starts after Windows Server reboot.

---

## Docker Auto-Start

- Docker services set to Automatic startup

---

## Startup Script

**File:** `start-uptime-kuma.bat`

```bash
cd C:\Docker\UptimeKuma

docker compose up -d
```

---

## Task Scheduler Setup

### Task Name
Start Uptime Kuma

### Trigger
- At startup

### Action
- Run batch file

```text
C:\Docker\start-uptime-kuma.bat
```

### Settings
- Run with highest privileges
- Run whether user is logged in or not
- Restart on failure enabled

---

## Validation

- Reboot testing completed
- Docker container persistence verified
- Dashboard accessibility confirmed
- Alerts tested successfully

---

# Backup & Recovery

- Docker volume persistence
- Configuration backup strategy
- Container recovery procedure

---

# Business Impact

## Operational Improvements

- Reduced downtime response time
- Improved monitoring visibility
- Faster incident detection
- Increased infrastructure stability

## Cost Savings

- Eliminated enterprise monitoring licensing costs
- Open-source solution adoption
- Reduced operational overhead

## IT Efficiency

- Centralized monitoring system
- Automated alerting
- Faster troubleshooting

---

# Key Deliverables

- Docker-based Uptime Kuma deployment
- Windows Server hosting environment
- Automated monitoring dashboard
- Email alert system
- PBX, CCTV, printer, server monitoring
- Task Scheduler automation
- Startup recovery configuration

---

# Outcome

Successfully implemented a scalable infrastructure monitoring solution using Uptime Kuma on Windows Server for Xcelerate Outsourcing, improving uptime visibility, reducing downtime, and enabling proactive infrastructure management across all critical systems.

