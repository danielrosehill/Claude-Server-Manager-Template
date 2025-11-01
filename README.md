# Claude Server Manager Template

A template repository for deploying Claude Code configuration to home servers. Some of the context is a little specific to my actual environment and home server purpose. But the template/pattern should be reasonably adaptable with a few edits. 

## Purpose

This template provides a comprehensive Claude Code environment optimized for server administration tasks. It includes:

- Custom `CLAUDE.md` with server-specific context and instructions
- **38 slash commands** for routine system administration tasks
- **10 specialized agents** for complex management workflows
- A logbook submodule for documentation and troubleshooting notes
- Hardware profiling directory structure

### Key Features

- **Low-spec hardware optimization** - Resource monitoring and performance tuning
- **Docker deployment management** - Atomic deployment pattern with Git integration
- **Cloudflare Tunnel integration** - External service exposure and monitoring
- **Advanced storage management** - XFS, RAID, NAS, and cloud object storage
- **Comprehensive monitoring** - System health, services, logs, and security
- **Backup orchestration** - Status monitoring and troubleshooting
- **Proxmox VM integration** - VM management from host perspective

## Deployment Model

The intended deployment is to clone this repository directly to `~` (home directory) on your managed server. This places all configuration files at the root level where Claude Code expects them:

```bash
# On your managed server:
cd ~
git clone <this-repo> claude-server-config
cd claude-server-config
cp -r .claude CLAUDE.md env.md ~/
```

Or use rsync for deployment:
```bash
# From your local machine:
rsync -av --exclude='.git' ./ user@server:~/
```

When Claude Code CLI is run from `~` on the remote server, it will automatically have access to:
- `CLAUDE.md` - Server-specific context and instructions
- `.claude/commands/` - Slash command library
- `.claude/` - Agent configurations and settings

### Setup Steps

1. Deploy the configuration files to `~` on your target server (as shown above)
2. Ensure Claude Code CLI is installed and authenticated on the server
3. For maximally permissive configuration, add `/` to trusted directories:
   ```bash
   # Note: Only do this on personal/development servers, not production!
   ```
4. Initialize the logbook submodule if using:
   ```bash
   cd ~
   git submodule init
   git submodule update
   ```

## Included Slash Commands

Use these commands by typing them in Claude Code CLI:

### System Health & Monitoring
- `/system-health` - Check disk space, memory, CPU, and system status
- `/uptime-stats` - Check system uptime and stability metrics
- `/boot-time` - Analyze boot time and identify slow-starting services
- `/check-services` - Review systemd service status and identify failures
- `/check-logs-noteworthy` - Review logs for anything noteworthy (not just errors)
- `/analyze-logs` - Examine system and service logs for errors
- `/resource-alerts` - Check resource pressure and alerts (critical for low-spec hardware)
- `/process-monitor` - Identify and analyze resource-intensive processes

### Storage & Filesystem
- `/disk-usage` - Analyze disk space consumption and identify space hogs
- `/filesystem-health` - Check filesystem health and integrity (XFS)
- `/cleanup-filesystem` - Identify old/leftover files for cleanup (requires approval)
- `/xfs-check` - XFS-specific filesystem health and performance checks
- `/raid-status` - Check multi-disk array and RAID status

### Docker Management
- `/docker-health` - Comprehensive Docker health check
- `/prune-docker` - Review running containers and identify resource usage
- `/cleanup-docker` - Identify inactive Docker deployments for removal (requires approval)
- `/check-docker-permissions` - Verify Docker volume and data directory permissions
- `/deployment-list` - List and analyze all Docker deployments
- `/volume-check` - Check Docker volume configuration and health

### Networking & Connectivity
- `/network-health` - Check network configuration and connectivity
- `/check-lan-connectivity` - Verify connectivity to key LAN systems
- `/check-nfs-mounts` - Check NFS mounts and NAS availability
- `/tunnel-status` - Check Cloudflare tunnel status and connectivity
- `/port-check` - Analyze port usage and listening services

### Security & Certificates
- `/security-audit` - Conduct comprehensive security audit
- `/firewall-check` - Assess firewall configuration and security posture
- `/certificate-check` - Check SSL/TLS certificate status and expiration

### Backups & Notifications
- `/backup-status` - Verify recent backup operations and check for failures
- `/verify-backup-clis` - Check backup CLI tools (rclone, aws, etc.)
- `/email-test` - Test email notification system

### Hardware & Virtualization
- `/gpu-status` - Check GPU passthrough and NVIDIA GPU status
- `/proxmox-status` - Check this VM's status from Proxmox host perspective

### System Maintenance & Updates
- `/check-updates` - Check for available system updates and security patches
- `/manage-autoupdate` - Review and configure automatic update settings
- `/verify-github-cli` - Verify GitHub CLI is working correctly

### Documentation & Profiling
- `/document-distro` - Document Linux distribution and system info (saves to context/)
- `/benchmark-hardware` - Comprehensive hardware benchmarking (saves to hw-profile/)
- `/benchmark-gpu` - GPU and compute module benchmarking (saves to hw-profile/)
- `/check-restore-points` - Check available backup and restore points

## Included Subagents

Specialized agents for complex administrative tasks (use via Task tool):

### Core Operations
- **docker-troubleshooter** - Diagnose and resolve Docker-related issues
- **backup-manager** - Manage, troubleshoot, and optimize backup operations
- **log-analyzer** - Examine system and application logs for issues and patterns
- **service-monitor** - Monitor and troubleshoot systemd services
- **security-auditor** - Perform security checks and vulnerability identification

### Advanced Management
- **performance-optimizer** - Optimize resource usage for low-spec hardware
- **deployment-manager** - Manage Docker deployments following atomic deployment principle
- **tunnel-manager** - Manage and troubleshoot Cloudflare Tunnel connectivity
- **storage-manager** - Manage XFS filesystems, RAID arrays, NAS, and cloud storage

### Documentation
- **server-documentarian** - Create comprehensive documentation for debugging operations, server configuration, bug reports, and work logs

## Directory Structure

- `.claude/` - Claude Code configuration and commands
- `context/` - Server context documentation (distro info, configuration)
- `hw-profile/` - Hardware and GPU benchmark reports
- `logbook/` - Documentation and troubleshooting notes (submodule)

## Use Case

Ideal for Ubuntu servers running:
- Docker containerized services
- Automated backup operations
- Local network services
- Development/testing environments

## Security Note

This template is designed for home lab and development servers. Adjust permissions and security settings appropriately for your environment.
