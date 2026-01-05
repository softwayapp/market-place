# 🏪 SoftwayApp Development Marketplace

> Complete development toolkit for Claude Code with 32+ skills, 4 commands, and 3 agents

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude-Code-blueviolet)](https://code.claude.com)

---

## 🚀 Quick Install

### macOS / Linux

```bash
curl -fsSL https://raw.githubusercontent.com/softwayapp/market-place/main/install.sh | bash
```

### Windows (PowerShell)

```powershell
irm https://raw.githubusercontent.com/softwayapp/market-place/main/install.ps1 | iex
```

### Manual Installation

```bash
# Clone to Claude Code plugins directory
git clone https://github.com/softwayapp/market-place.git ~/.claude/plugins/softwayapp-marketplace

# Restart Claude Code
```

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

### Font Download Example

```bash
# Auto-detect project type and download
/font

# Custom path
/font public/fonts

# Natural language
"Download Pretendard fonts"
```

### Code Analysis Example

```bash
# Analyze current file
/analyze

# Full project analysis
/analyze --full
```

### Test Execution Example

```bash
# Run all tests
/test

# With coverage
/test --coverage
```

---

## 🔄 Update

```bash
cd ~/.claude/plugins/softwayapp-marketplace
git pull origin main
```

Then restart Claude Code.

---

## 📚 Documentation

### Skill Categories

Explore skills by browsing the `skills/` directory:

```
skills/
├── backend/       # Backend development
├── frontend/      # Frontend development
├── devops/        # DevOps automation
├── security/      # Security tools
├── quality/       # Code quality
└── documentation/ # Documentation generation
```

### Command Reference

All commands are in `commands/`:

```
commands/
├── font.md     # Font downloader
├── analyze.md  # Code analyzer
├── test.md     # Test runner
└── deploy.md   # Deployment automation
```

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
