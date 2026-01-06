#!/bin/bash
# ========================================
# SoftwayApp Marketplace - Quick Install
# ========================================
# One-command installation for macOS/Linux
# Usage: curl -fsSL https://raw.githubusercontent.com/softwayapp/market-place/main/quick-install.sh | bash

set -e

SKILLS_DIR="$HOME/.claude/skills"
COMMANDS_DIR="$HOME/.claude/commands"
AGENTS_DIR="$HOME/.claude/agents"
REPO_URL="https://github.com/softwayapp/market-place.git"
TEMP_DIR="/tmp/market-place-$$"

# Colors
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
GRAY='\033[0;90m'
NC='\033[0m' # No Color

# Helper functions
success() { echo -e "${GREEN}$1${NC}"; }
info() { echo -e "${CYAN}$1${NC}"; }
warning() { echo -e "${YELLOW}$1${NC}"; }
error() { echo -e "${RED}$1${NC}"; }

# Header
clear
echo ""
echo -e "${CYAN}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║   🏪 SoftwayApp Marketplace Quick Installer          ║${NC}"
echo -e "${CYAN}║   32+ Skills | 4 Commands | 3 Agents                  ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check prerequisites
info "🔍 Checking prerequisites..."

# Check git
if ! command -v git &> /dev/null; then
    error "   ✗ Git is not installed"
    echo ""
    warning "Please install Git first:"
    warning "  macOS: brew install git"
    warning "  Ubuntu/Debian: sudo apt-get install git"
    warning "  Fedora: sudo dnf install git"
    exit 1
fi
success "   ✓ Git is installed"

# Check Claude Code directory
if [ ! -d "$HOME/.claude" ]; then
    warning "   ⚠ Claude Code directory not found"
    info "   Creating ~/.claude directory..."
    mkdir -p "$HOME/.claude"
fi
success "   ✓ Claude Code directory exists"

echo ""

# Create directories
info "📁 Setting up directories..."
mkdir -p "$SKILLS_DIR" "$COMMANDS_DIR" "$AGENTS_DIR"
success "   ✓ Directories ready"

echo ""

# Download marketplace
info "⬇️  Downloading marketplace from GitHub..."
if [ -d "$TEMP_DIR" ]; then
    rm -rf "$TEMP_DIR"
fi

if git clone --depth 1 --quiet "$REPO_URL" "$TEMP_DIR" 2>/dev/null; then
    success "   ✓ Download complete"
else
    error "   ✗ Failed to download"
    echo ""
    warning "Manual installation:"
    warning "  1. Clone: git clone $REPO_URL"
    warning "  2. Run: cd market-place && bash install-global-skills.sh"
    exit 1
fi

echo ""

# Install skills
info "📦 Installing skills..."
TOTAL_SKILLS=0
categories=("backend" "frontend" "devops" "security" "quality" "documentation" "github" "setup-executor")

for category in "${categories[@]}"; do
    category_path="$TEMP_DIR/skills/$category"
    if [ -d "$category_path" ]; then
        for skill_dir in "$category_path"/*/; do
            if [ -d "$skill_dir" ]; then
                skill_name=$(basename "$skill_dir")
                dest_path="$SKILLS_DIR/$skill_name"
                rm -rf "$dest_path"
                cp -r "$skill_dir" "$dest_path"
                ((TOTAL_SKILLS++))
            fi
        done
    fi
done
success "   ✓ Installed $TOTAL_SKILLS skills"

# Install commands
info "📋 Installing commands..."
TOTAL_COMMANDS=0
commands_path="$TEMP_DIR/commands"

if [ -d "$commands_path" ]; then
    # Copy main commands
    find "$commands_path" -maxdepth 1 -name "*.md" -exec cp {} "$COMMANDS_DIR/" \; 2>/dev/null || true
    TOTAL_COMMANDS=$(find "$commands_path" -maxdepth 1 -name "*.md" | wc -l)

    # Copy subdirectory commands (github, init)
    for sub_dir in "$commands_path"/*/; do
        if [ -d "$sub_dir" ]; then
            find "$sub_dir" -name "*.md" -exec cp {} "$COMMANDS_DIR/" \; 2>/dev/null || true
            sub_count=$(find "$sub_dir" -name "*.md" | wc -l)
            TOTAL_COMMANDS=$((TOTAL_COMMANDS + sub_count))
        fi
    done
fi
success "   ✓ Installed $TOTAL_COMMANDS commands"

# Install agents
info "🤖 Installing agents..."
TOTAL_AGENTS=0
agents_path="$TEMP_DIR/agents"

if [ -d "$agents_path" ]; then
    for agent_dir in "$agents_path"/*/; do
        if [ -d "$agent_dir" ]; then
            agent_name=$(basename "$agent_dir")
            dest_path="$AGENTS_DIR/$agent_name"
            rm -rf "$dest_path"
            cp -r "$agent_dir" "$dest_path"
            ((TOTAL_AGENTS++))
        fi
    done
fi
success "   ✓ Installed $TOTAL_AGENTS agents"

# Cleanup
info "🧹 Cleaning up..."
rm -rf "$TEMP_DIR"
success "   ✓ Cleanup complete"

echo ""
echo ""

# Success message
echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║              ✅ Installation Complete!                 ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

# Summary
info "📊 Installation Summary:"
echo "   • $TOTAL_SKILLS skills installed"
echo "   • $TOTAL_COMMANDS commands installed"
echo "   • $TOTAL_AGENTS agents installed"
echo ""

# Locations
info "📍 Installed to:"
echo -e "   ${GRAY}• Skills:   $SKILLS_DIR${NC}"
echo -e "   ${GRAY}• Commands: $COMMANDS_DIR${NC}"
echo -e "   ${GRAY}• Agents:   $AGENTS_DIR${NC}"
echo ""

# Quick start
success "🚀 Quick Start:"
echo ""
echo -e "   ${CYAN}Try these commands in Claude Code:${NC}"
echo ""
echo -e "   ${YELLOW}/font${NC}                    ${GRAY}Download Pretendard fonts${NC}"
echo -e "   ${YELLOW}/analyze${NC}                 ${GRAY}Analyze code quality${NC}"
echo -e "   ${YELLOW}@api-generator${NC}          ${GRAY}Generate REST API${NC}"
echo -e "   ${YELLOW}@font-download${NC}          ${GRAY}Download fonts${NC}"
echo -e "   ${YELLOW}@test-generator${NC}         ${GRAY}Generate tests${NC}"
echo ""

# Next steps
info "📚 Next Steps:"
echo "   1. No restart needed - ready to use immediately!"
echo "   2. View all skills: Type '@' in Claude Code"
echo "   3. View all commands: Type '/' in Claude Code"
echo "   4. Documentation: https://github.com/softwayapp/market-place"
echo ""

# Create quick reference
QUICK_REF="$HOME/.claude/MARKETPLACE-QUICK-REFERENCE.md"
cat > "$QUICK_REF" << 'EOF'
# 🏪 SoftwayApp Marketplace Quick Reference

**Last Updated**: $(date '+%Y-%m-%d %H:%M')
**Installation**: Complete

---

## 📋 Commands (Type '/' in Claude Code)

| Command | Description |
|---------|-------------|
| /font | Download Pretendard fonts with auto path detection |
| /analyze | Comprehensive code quality analysis |
| /test | Execute tests with coverage analysis |
| /deploy | Automated deployment workflows |

---

## 🛠️ Skills by Category (Type '@' in Claude Code)

### 🔧 Backend
- @api-generator - REST API scaffolding
- @database-migration - Migration management
- @clean-architecture-scaffolder - Architecture setup
- @cqrs-generator - CQRS pattern implementation
- @error-handler - Error handling patterns
- @performance-optimizer - Performance tuning

### 🎨 Frontend
- @font-download - Pretendard font installation
- @component-generator - UI component scaffolding
- @accessibility-audit - WCAG compliance checking
- @responsive-design - Responsive layout helpers
- @state-management - State management patterns

### 🚀 DevOps
- @ci-cd-setup - CI/CD pipeline configuration
- @docker-optimizer - Docker optimization
- @k8s-deployment - Kubernetes deployment
- @monitoring-setup - Monitoring configuration
- @project-init-pipeline - Project initialization

### 🔒 Security
- @vulnerability-scan - Security vulnerability detection
- @code-security-audit - Code security analysis
- @dependency-check - Dependency vulnerability scanning
- @secrets-detection - Secret detection in code

### 🧪 Quality
- @test-generator - Automated test generation
- @e2e-test-builder - End-to-end test creation
- @coverage-analyzer - Test coverage analysis
- @mock-data-generator - Test data generation

### 📝 Documentation
- @api-docs-generator - API documentation
- @readme-generator - README file generation
- @changelog-generator - Changelog automation
- @jsdoc-generator - JavaScript documentation

---

## 🤖 Agents (Type '@agent-' in Claude Code)

| Agent | Purpose |
|-------|---------|
| @agent-backend-architect | Backend system design |
| @agent-performance-engineer | Performance optimization |
| @agent-security-auditor | Security assessment |

---

## 🔄 Update

To get the latest version:

```bash
curl -fsSL https://raw.githubusercontent.com/softwayapp/market-place/main/quick-install.sh | bash
```

---

## 📚 Resources

- **GitHub**: https://github.com/softwayapp/market-place
- **Issues**: https://github.com/softwayapp/market-place/issues
- **Email**: dev@softwayapp.com
EOF

success "📄 Quick reference saved: $QUICK_REF"
echo ""

echo -e "${CYAN}═══════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}           Happy coding with Claude! 🚀${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════${NC}"
echo ""
