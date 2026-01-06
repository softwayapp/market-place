# 🏪 SoftwayApp Development Marketplace

> Complete development toolkit for Claude Code with 32+ skills, 4 commands, and 3 agents

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude-Code-blueviolet)](https://code.claude.com)

---

## 🚀 Quick Install (One-Line Installation)

### Windows (PowerShell - Run as Administrator)

```powershell
# Quick installation (recommended)
irm https://raw.githubusercontent.com/softwayapp/market-place/main/quick-install.ps1 | iex
```

### macOS / Linux

```bash
# Quick installation (recommended)
curl -fsSL https://raw.githubusercontent.com/softwayapp/market-place/main/quick-install.sh | bash
```

**✅ Installation complete in ~30 seconds! No restart required.**

### Manual Installation

```bash
# Clone repository
git clone https://github.com/softwayapp/market-place.git

# Run installation script
cd market-place
bash install-global-skills.sh      # macOS/Linux
# or
powershell -File install-global-skills.ps1  # Windows
```

**📖 Detailed installation guide**: See [INSTALLATION-GUIDE.md](INSTALLATION-GUIDE.md) for troubleshooting, offline installation, team deployment, and more.

---

## 📦 What's Included

### 🎯 Commands (4)

| Command | Description |
|---------|-------------|
| `/font` | Download Pretendard fonts with auto path detection |
| `/analyze` | Comprehensive code quality analysis |
| `/test` | Execute tests with coverage analysis |
| `/deploy` | Automated deployment workflows |

### 🛠️ Skills (32+)

#### 🔧 Backend (6 skills)
- API Generator - REST API scaffolding
- Database Migration - Migration management
- Performance Optimizer - Performance tuning
- Error Handler - Error handling patterns
- Clean Architecture - Architecture scaffolding
- CQRS Generator - CQRS pattern implementation

#### 🎨 Frontend (5 skills)
- **Font Downloader** - Pretendard font installation
- Component Generator - UI component scaffolding
- Accessibility Audit - WCAG compliance checking
- Responsive Design - Responsive layout helpers
- State Management - State management patterns

#### 🔒 Security (4 skills)
- Vulnerability Scan - Security vulnerability detection
- Code Security Audit - Code security analysis
- Dependency Check - Dependency vulnerability scanning
- Secrets Detection - Secret detection in code

#### 🧪 Quality (4 skills)
- Test Generator - Automated test generation
- E2E Test Builder - End-to-end test creation
- Coverage Analyzer - Test coverage analysis
- Mock Data Generator - Test data generation

#### 🚀 DevOps (5 skills)
- CI/CD Setup - CI/CD pipeline configuration
- Docker Optimizer - Docker optimization
- Kubernetes Deployment - K8s deployment automation
- Monitoring Setup - Monitoring configuration
- Project Init Pipeline - Project initialization

#### 📝 Documentation (4 skills)
- API Docs Generator - API documentation generation
- README Generator - README file generation
- Changelog Generator - Changelog automation
- JSDoc Generator - JavaScript documentation

### 🤖 Agents (3)

- **Backend Architect** - Backend system design
- **Performance Engineer** - Performance optimization
- **Security Auditor** - Security assessment

---

## 💻 Usage

### Commands

```bash
# Download fonts
/font                  # Auto-detect project type
/font public/fonts     # Custom path

# Code analysis
/analyze              # Analyze current file
/analyze --full       # Full project analysis

# Testing
/test                 # Run all tests
/test --coverage      # With coverage report

# Deployment
/deploy               # Automated deployment
/deploy --env prod    # Specific environment
```

### Skills

```bash
# Backend development
@api-generator users
@database-migration create_users_table
@clean-architecture-scaffolder my-app

# Frontend development
@font-download
@component-generator Button
@accessibility-audit

# DevOps
@ci-cd-setup
@docker-optimizer
@k8s-deployment

# Security
@vulnerability-scan
@secrets-detection

# Testing
@test-generator UserService
@e2e-test-builder login-flow
```

---

## 🔄 Update

```bash
cd market-place
git pull origin main

# Run installation script again
bash install-global-skills.sh      # macOS/Linux
# or
powershell -File install-global-skills.ps1  # Windows
```

---

## 📚 Documentation

### Project Structure

```
market-place/
├── skills/            # 32+ skills organized by category
│   ├── backend/       # Backend development skills
│   ├── frontend/      # Frontend development skills
│   ├── devops/        # DevOps automation skills
│   ├── security/      # Security tools
│   ├── quality/       # Code quality skills
│   └── documentation/ # Documentation generation
├── commands/          # 4 slash commands
├── agents/            # 3 specialized agents
└── install-global-skills.*  # Installation scripts
```

### Installation Method

This marketplace uses **global installation** instead of the Claude Code plugin system:

- ✅ **Commands** → Copied to `~/.claude/commands/`
- ✅ **Skills** → Copied to `~/.claude/skills/`
- ✅ **No restart required** → Immediately available
- ✅ **Works on all computers** → No plugin registration needed
- ✅ **Easy updates** → Just re-run installation script

---

## 🤝 Contributing

This is an internal marketplace. Contact the development team for contributions.

---

## 📄 License

MIT License - See [LICENSE](LICENSE) for details

---

## 🆘 Support

- **Issues**: [GitHub Issues](https://github.com/softwayapp/market-place/issues)
- **Email**: dev@softwayapp.com

---

**Made with ❤️ by SoftwayApp Development Team**
