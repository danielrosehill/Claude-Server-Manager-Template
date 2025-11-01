# Claude Server Manager Template

A template repository for deploying Claude Code configuration to home servers, specifically designed for Ubuntu VMs running Docker-based services and backup operations.

## Purpose

This template provides a pre-configured Claude Code environment optimized for server administration tasks. It includes:

- Custom `CLAUDE.md` with server-specific context and instructions
- Slash commands for routine system administration tasks
- A logbook submodule for documentation and troubleshooting notes
- Hardware profiling directory structure

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

### Storage & Filesystem
- `/disk-usage` - Analyze disk space consumption and identify space hogs
- `/filesystem-health` - Check filesystem health and integrity (XFS)
- `/cleanup-filesystem` - Identify old/leftover files for cleanup (requires approval)

### Docker Management
- `/docker-health` - Comprehensive Docker health check
- `/prune-docker` - Review running containers and identify resource usage
- `/cleanup-docker` - Identify inactive Docker deployments for removal (requires approval)
- `/check-docker-permissions` - Verify Docker volume and data directory permissions

### Networking
- `/network-health` - Check network configuration and connectivity
- `/check-lan-connectivity` - Verify connectivity to key LAN systems
- `/check-nfs-mounts` - Check NFS mounts and NAS availability

### Security
- `/security-audit` - Conduct comprehensive security audit
- `/firewall-check` - Assess firewall configuration and security posture

### Backups
- `/backup-status` - Verify recent backup operations and check for failures
- `/verify-backup-clis` - Check backup CLI tools (rclone, aws, etc.)

### System Maintenance
- `/update-check` - Check for available system updates and security patches
- `/verify-github-cli` - Verify GitHub CLI is working correctly

## Included Subagents

Specialized agents for complex administrative tasks (use via Task tool):

- **docker-troubleshooter** - Diagnose and resolve Docker-related issues
- **backup-manager** - Manage, troubleshoot, and optimize backup operations
- **log-analyzer** - Examine system and application logs for issues and patterns
- **service-monitor** - Monitor and troubleshoot systemd services
- **security-auditor** - Perform security checks and vulnerability identification

## Directory Structure

- `.claude/` - Claude Code configuration and commands
- `logbook/` - Documentation and troubleshooting notes (submodule)
- `hw-profile/` - Hardware profiling reports

## Use Case

Ideal for Ubuntu servers running:
- Docker containerized services
- Automated backup operations
- Local network services
- Development/testing environments

## Security Note

This template is designed for home lab and development servers. Adjust permissions and security settings appropriately for your environment.
