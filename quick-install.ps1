# ========================================
# SoftwayApp Marketplace - Quick Install
# ========================================
# One-command installation for Windows
# Usage: irm https://raw.githubusercontent.com/softwayapp/market-place/main/quick-install.ps1 | iex

$ErrorActionPreference = "Stop"

$SKILLS_DIR = "$env:USERPROFILE\.claude\skills"
$COMMANDS_DIR = "$env:USERPROFILE\.claude\commands"
$AGENTS_DIR = "$env:USERPROFILE\.claude\agents"
$REPO_URL = "https://github.com/softwayapp/market-place.git"
$TEMP_DIR = "$env:TEMP\market-place-$(Get-Random)"

# Colors
function Write-Success { param($msg) Write-Host $msg -ForegroundColor Green }
function Write-Info { param($msg) Write-Host $msg -ForegroundColor Cyan }
function Write-Warning { param($msg) Write-Host $msg -ForegroundColor Yellow }
function Write-Error { param($msg) Write-Host $msg -ForegroundColor Red }

# Header
Clear-Host
Write-Host ""
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "   SoftwayApp Marketplace Quick Installer" -ForegroundColor Cyan
Write-Host "   32+ Skills | 4 Commands | 3 Agents" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host ""

# Check prerequisites
Write-Info "Checking prerequisites..."

# Check git
try {
    $null = git --version 2>&1
    Write-Success "   [OK] Git is installed"
} catch {
    Write-Error "   [X] Git is not installed"
    Write-Warning ""
    Write-Warning "Please install Git first:"
    Write-Warning "  Download from: https://git-scm.com/download/win"
    Write-Warning "  Or run: winget install Git.Git"
    exit 1
}

# Check Claude Code directory
if (-not (Test-Path "$env:USERPROFILE\.claude")) {
    Write-Warning "   [!] Claude Code directory not found"
    Write-Info "   Creating ~/.claude directory..."
    New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.claude" | Out-Null
}
Write-Success "   [OK] Claude Code directory exists"

Write-Host ""

# Create directories
Write-Info "Setting up directories..."
@($SKILLS_DIR, $COMMANDS_DIR, $AGENTS_DIR) | ForEach-Object {
    New-Item -ItemType Directory -Force -Path $_ | Out-Null
}
Write-Success "   [OK] Directories ready"

Write-Host ""

# Download marketplace
Write-Info "Downloading marketplace from GitHub..."
try {
    if (Test-Path $TEMP_DIR) {
        Remove-Item -Path $TEMP_DIR -Recurse -Force
    }

    $gitOutput = git clone --depth 1 --quiet $REPO_URL $TEMP_DIR 2>&1

    if (-not (Test-Path "$TEMP_DIR\skills")) {
        throw "Download failed"
    }
    Write-Success "   [OK] Download complete"
} catch {
    Write-Error "   [X] Failed to download"
    Write-Warning ""
    Write-Warning "Manual installation:"
    Write-Warning "  1. Clone: git clone $REPO_URL"
    Write-Warning "  2. Run: cd market-place && .\install-global-skills.ps1"
    exit 1
}

Write-Host ""

# Install skills
Write-Info "Installing skills..."
$categories = @("backend", "frontend", "devops", "security", "quality", "documentation", "github", "setup-executor")
$totalSkills = 0

foreach ($category in $categories) {
    $categoryPath = Join-Path $TEMP_DIR "skills\$category"
    if (Test-Path $categoryPath) {
        Get-ChildItem -Path $categoryPath -Directory -ErrorAction SilentlyContinue | ForEach-Object {
            $destPath = Join-Path $SKILLS_DIR $_.Name
            if (Test-Path $destPath) {
                Remove-Item -Path $destPath -Recurse -Force -ErrorAction SilentlyContinue
            }
            Copy-Item -Path $_.FullName -Destination $destPath -Recurse -Force
            $totalSkills++
        }
    }
}
Write-Success "   [OK] Installed $totalSkills skills"

# Install commands
Write-Info "Installing commands..."
$commandsPath = Join-Path $TEMP_DIR "commands"
$totalCommands = 0

if (Test-Path $commandsPath) {
    # Copy main commands
    Get-ChildItem -Path $commandsPath -Filter "*.md" -ErrorAction SilentlyContinue | ForEach-Object {
        Copy-Item -Path $_.FullName -Destination $COMMANDS_DIR -Force
        $totalCommands++
    }

    # Copy subdirectory commands (github, init)
    Get-ChildItem -Path $commandsPath -Directory -ErrorAction SilentlyContinue | ForEach-Object {
        $subCommands = Get-ChildItem -Path $_.FullName -Filter "*.md" -ErrorAction SilentlyContinue
        $subCommands | ForEach-Object {
            Copy-Item -Path $_.FullName -Destination $COMMANDS_DIR -Force
            $totalCommands++
        }
    }
}
Write-Success "   [OK] Installed $totalCommands commands"

# Install agents
Write-Info "Installing agents..."
$agentsPath = Join-Path $TEMP_DIR "agents"
$totalAgents = 0

if (Test-Path $agentsPath) {
    Get-ChildItem -Path $agentsPath -Directory -ErrorAction SilentlyContinue | ForEach-Object {
        $destPath = Join-Path $AGENTS_DIR $_.Name
        if (Test-Path $destPath) {
            Remove-Item -Path $destPath -Recurse -Force -ErrorAction SilentlyContinue
        }
        Copy-Item -Path $_.FullName -Destination $destPath -Recurse -Force
        $totalAgents++
    }
}
Write-Success "   [OK] Installed $totalAgents agents"

# Cleanup
Write-Info "Cleaning up..."
Remove-Item -Path $TEMP_DIR -Recurse -Force -ErrorAction SilentlyContinue
Write-Success "   [OK] Cleanup complete"

Write-Host ""
Write-Host ""

# Success message
Write-Host "================================================================" -ForegroundColor Green
Write-Host "              Installation Complete!" -ForegroundColor Green
Write-Host "================================================================" -ForegroundColor Green
Write-Host ""

# Summary
Write-Info "Installation Summary:"
Write-Host "   - $totalSkills skills installed" -ForegroundColor White
Write-Host "   - $totalCommands commands installed" -ForegroundColor White
Write-Host "   - $totalAgents agents installed" -ForegroundColor White
Write-Host ""

# Locations
Write-Info "Installed to:"
Write-Host "   - Skills:   $SKILLS_DIR" -ForegroundColor Gray
Write-Host "   - Commands: $COMMANDS_DIR" -ForegroundColor Gray
Write-Host "   - Agents:   $AGENTS_DIR" -ForegroundColor Gray
Write-Host ""

# Quick start
Write-Success "Quick Start:"
Write-Host ""
Write-Host "   Try these commands in Claude Code:" -ForegroundColor Cyan
Write-Host ""
Write-Host "   /font                    " -ForegroundColor Yellow -NoNewline
Write-Host "Download Pretendard fonts" -ForegroundColor Gray
Write-Host "   /analyze                 " -ForegroundColor Yellow -NoNewline
Write-Host "Analyze code quality" -ForegroundColor Gray
Write-Host "   @api-generator          " -ForegroundColor Yellow -NoNewline
Write-Host "Generate REST API" -ForegroundColor Gray
Write-Host "   @font-download          " -ForegroundColor Yellow -NoNewline
Write-Host "Download fonts" -ForegroundColor Gray
Write-Host "   @test-generator         " -ForegroundColor Yellow -NoNewline
Write-Host "Generate tests" -ForegroundColor Gray
Write-Host ""

# Next steps
Write-Info "Next Steps:"
Write-Host "   1. No restart needed - ready to use immediately!" -ForegroundColor White
Write-Host "   2. View all skills: Type '@' in Claude Code" -ForegroundColor White
Write-Host "   3. View all commands: Type '/' in Claude Code" -ForegroundColor White
Write-Host "   4. Documentation: https://github.com/softwayapp/market-place" -ForegroundColor White
Write-Host ""

# Quick reference
$quickRefPath = "$env:USERPROFILE\.claude\MARKETPLACE-QUICK-REFERENCE.md"
$quickRefContent = @"
# SoftwayApp Marketplace Quick Reference

**Last Updated**: $(Get-Date -Format "yyyy-MM-dd HH:mm")
**Installation**: $totalSkills skills, $totalCommands commands, $totalAgents agents

---

## Commands (Type '/' in Claude Code)

| Command | Description |
|---------|-------------|
| /font | Download Pretendard fonts with auto path detection |
| /analyze | Comprehensive code quality analysis |
| /test | Execute tests with coverage analysis |
| /deploy | Automated deployment workflows |

---

## Skills by Category (Type '@' in Claude Code)

### Backend
- @api-generator - REST API scaffolding
- @database-migration - Migration management
- @clean-architecture-scaffolder - Architecture setup
- @cqrs-generator - CQRS pattern implementation
- @error-handler - Error handling patterns
- @performance-optimizer - Performance tuning

### Frontend
- @font-download - Pretendard font installation
- @component-generator - UI component scaffolding
- @accessibility-audit - WCAG compliance checking
- @responsive-design - Responsive layout helpers
- @state-management - State management patterns

### DevOps
- @ci-cd-setup - CI/CD pipeline configuration
- @docker-optimizer - Docker optimization
- @k8s-deployment - Kubernetes deployment
- @monitoring-setup - Monitoring configuration
- @project-init-pipeline - Project initialization

### Security
- @vulnerability-scan - Security vulnerability detection
- @code-security-audit - Code security analysis
- @dependency-check - Dependency vulnerability scanning
- @secrets-detection - Secret detection in code

### Quality
- @test-generator - Automated test generation
- @e2e-test-builder - End-to-end test creation
- @coverage-analyzer - Test coverage analysis
- @mock-data-generator - Test data generation

### Documentation
- @api-docs-generator - API documentation
- @readme-generator - README file generation
- @changelog-generator - Changelog automation
- @jsdoc-generator - JavaScript documentation

---

## Agents (Type '@agent-' in Claude Code)

| Agent | Purpose |
|-------|---------|
| @agent-backend-architect | Backend system design |
| @agent-performance-engineer | Performance optimization |
| @agent-security-auditor | Security assessment |

---

## Update

To get the latest version:

``````powershell
irm https://raw.githubusercontent.com/softwayapp/market-place/main/quick-install.ps1 | iex
``````

---

## Resources

- **GitHub**: https://github.com/softwayapp/market-place
- **Issues**: https://github.com/softwayapp/market-place/issues
- **Email**: dev@softwayapp.com

---

**Installed**: $(Get-Date -Format "yyyy-MM-dd HH:mm")
"@

$quickRefContent | Out-File -FilePath $quickRefPath -Encoding UTF8
Write-Success "Quick reference saved: $quickRefPath"
Write-Host ""

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "           Happy coding with Claude!" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host ""
