# Getting Started

Internal Claude Code Marketplace를 시작하는 방법을 안내합니다.

## 전제 조건

시작하기 전에 다음이 설치되어 있는지 확인하세요:

- **Claude Code CLI** v1.0.0 이상
- **Git** 2.0 이상
- **Node.js** 16.0 이상 (선택사항)

## 설치

### 방법 1: Claude Code Plugin 시스템 (권장)

가장 간단한 설치 방법입니다:

```bash
# 1. 마켓플레이스 추가
/plugin marketplace add your-org/internal-marketplace

# 2. 사용 가능한 플러그인 확인
/plugin

# 3. 스킬 설치
# UI에서 Browse and install plugins 선택
# internal-marketplace 선택
# 원하는 스킬 카테고리 선택
# Install now 클릭
```

### 방법 2: 직접 클론

개발하거나 기여하려는 경우:

```bash
# 저장소 클론
git clone https://github.com/your-org/internal-marketplace.git
cd internal-marketplace

# Claude Code에 연결
ln -s $(pwd) ~/.claude/marketplaces/internal-dev
```

### 방법 3: 프로젝트별 설치

특정 프로젝트에만 스킬을 사용하려는 경우:

```bash
# 프로젝트 루트에 .claude 디렉토리 생성
mkdir -p .claude

# settings.json 파일 생성
cat > .claude/settings.json <<EOF
{
  "plugins": [
    {
      "name": "internal-marketplace",
      "source": "github:your-org/internal-marketplace",
      "skills": ["api-generator", "test-generator"],
      "enabled": true
    }
  ]
}
EOF
```

## 첫 번째 스킬 사용하기

### 예제: API Generator 스킬

1. **스킬 확인**

```bash
# 설치된 스킬 목록 확인
/skills
```

2. **스킬 사용**

Claude Code와 대화하면서 자연스럽게 사용:

```
사용자: "User 모델에 대한 REST API를 생성해줘"

Claude: [api-generator 스킬이 자동으로 활성화됩니다]
```

3. **결과 확인**

생성된 파일들을 확인:
- `routes/user.routes.js`
- `controllers/user.controller.js`
- `validators/user.validator.js`

## 스킬 카테고리

### 🔧 Backend Development
```bash
/plugin install backend-skills@internal-marketplace
```
- API Generator
- Database Migration
- Performance Optimizer
- Error Handler

### 🎨 Frontend Development
```bash
/plugin install frontend-skills@internal-marketplace
```
- Component Generator
- Accessibility Audit
- Responsive Design
- State Management

### 🔒 Security
```bash
/plugin install security-skills@internal-marketplace
```
- Vulnerability Scanner
- Code Security Audit
- Dependency Check
- Secrets Detection

### 🧪 Testing
```bash
/plugin install quality-skills@internal-marketplace
```
- Test Generator
- E2E Test Builder
- Coverage Analyzer
- Mock Data Generator

### 🚀 DevOps
```bash
/plugin install devops-skills@internal-marketplace
```
- CI/CD Setup
- Docker Optimizer
- K8s Deployment
- Monitoring Setup

### 📝 Documentation
```bash
/plugin install documentation-skills@internal-marketplace
```
- API Docs Generator
- README Generator
- Changelog Generator
- JSDoc Generator

## 스킬 설정

일부 스킬은 프로젝트별 설정이 필요합니다. 프로젝트 루트에 `.skillconfig.json` 생성:

```json
{
  "apiGenerator": {
    "framework": "express",
    "database": "mongodb",
    "useTypeScript": false
  },
  "testGenerator": {
    "framework": "jest",
    "coverage": true
  }
}
```

## 다음 단계

- [스킬 개발 가이드](skill-development.md) - 커스텀 스킬 만들기
- [Best Practices](best-practices.md) - 효과적인 사용 방법
- [FAQ](faq.md) - 자주 묻는 질문
- [Troubleshooting](troubleshooting.md) - 문제 해결

## 도움말

질문이나 문제가 있으면:

- **Slack**: #claude-code-marketplace
- **Email**: dev-support@company.com
- **Wiki**: https://wiki.company.com/claude-marketplace
- **GitHub**: https://github.com/your-org/internal-marketplace/issues

## 다음 읽을 내용

- [튜토리얼: 첫 스킬 만들기](tutorials/first-skill.md)
- [스킬 예제 모음](examples/)
- [기여 가이드](../CONTRIBUTING.md)
