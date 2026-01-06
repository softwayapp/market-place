# 🏪 마켓플레이스 설치 가이드
# Marketplace Installation Guide

> **다른 PC에서 빠르게 설치하는 방법**
> Quick installation guide for other computers

---

## 🚀 가장 빠른 방법 (One-Line Installation)

### Windows

PowerShell을 **관리자 권한**으로 실행한 후:

```powershell
irm https://raw.githubusercontent.com/softwayapp/market-place/main/quick-install.ps1 | iex
```

### macOS / Linux

터미널을 열고:

```bash
curl -fsSL https://raw.githubusercontent.com/softwayapp/market-place/main/quick-install.sh | bash
```

**✅ 설치 완료!** 재시작 없이 바로 사용 가능합니다.

---

## 📋 설치 과정 설명

### 1단계: 필수 요구사항 확인

설치 스크립트가 자동으로 확인하는 항목:

- ✅ **Git 설치 여부** - 없으면 설치 방법 안내
- ✅ **Claude Code 디렉토리** (~/.claude) - 없으면 자동 생성
- ✅ **인터넷 연결** - GitHub에서 다운로드

### 2단계: 자동 설치

스크립트가 자동으로 수행:

1. **임시 디렉토리 생성** → `/tmp` 또는 `%TEMP%`
2. **GitHub에서 다운로드** → 최신 버전 클론
3. **파일 복사**:
   - Skills → `~/.claude/skills/`
   - Commands → `~/.claude/commands/`
   - Agents → `~/.claude/agents/`
4. **임시 파일 정리** → 자동 삭제
5. **Quick Reference 생성** → `~/.claude/MARKETPLACE-QUICK-REFERENCE.md`

### 3단계: 설치 확인

설치 완료 후 표시되는 정보:

```
✅ Installation Complete!

📊 Installation Summary:
   • 32+ skills installed
   • 4 commands installed
   • 3 agents installed

📍 Installed to:
   • Skills:   C:\Users\user\.claude\skills
   • Commands: C:\Users\user\.claude\commands
   • Agents:   C:\Users\user\.claude\agents
```

---

## 🎯 설치 후 사용법

### Claude Code에서 바로 사용

**Commands (슬래시 명령어)**:
```
/font          → 폰트 다운로드
/analyze       → 코드 품질 분석
/test          → 테스트 실행
/deploy        → 배포 자동화
```

**Skills (@ 명령어)**:
```
@api-generator          → REST API 생성
@font-download          → 폰트 다운로드
@test-generator         → 테스트 자동 생성
@vulnerability-scan     → 보안 취약점 스캔
```

**Agents (에이전트)**:
```
@agent-backend-architect      → 백엔드 아키텍처 설계
@agent-performance-engineer   → 성능 최적화
@agent-security-auditor       → 보안 감사
```

### Quick Reference 보기

설치된 모든 스킬과 커맨드 목록:

```bash
# Windows
notepad ~/.claude/MARKETPLACE-QUICK-REFERENCE.md

# macOS/Linux
cat ~/.claude/MARKETPLACE-QUICK-REFERENCE.md
```

---

## 🔄 업데이트 방법

### 자동 업데이트 (권장)

**설치 명령어를 다시 실행**하면 자동으로 최신 버전으로 업데이트됩니다:

```powershell
# Windows
irm https://raw.githubusercontent.com/softwayapp/market-place/main/quick-install.ps1 | iex
```

```bash
# macOS/Linux
curl -fsSL https://raw.githubusercontent.com/softwayapp/market-place/main/quick-install.sh | bash
```

### 수동 업데이트

로컬 저장소를 사용하는 경우:

```bash
cd market-place
git pull origin main
bash install-global-skills.sh      # macOS/Linux
# 또는
powershell -File install-global-skills.ps1  # Windows
```

---

## 🛠️ 문제 해결

### 문제 1: Git이 설치되지 않음

**증상**:
```
✗ Git is not installed
```

**해결책**:

**Windows**:
```powershell
winget install Git.Git
```
또는 https://git-scm.com/download/win 에서 다운로드

**macOS**:
```bash
brew install git
```

**Ubuntu/Debian**:
```bash
sudo apt-get install git
```

### 문제 2: 권한 오류

**증상**:
```
Permission denied
```

**해결책**:

**Windows**: PowerShell을 **관리자 권한**으로 실행

**macOS/Linux**: sudo 권한이 필요한 경우:
```bash
sudo curl -fsSL https://raw.githubusercontent.com/softwayapp/market-place/main/quick-install.sh | bash
```

### 문제 3: 인터넷 연결 실패

**증상**:
```
Failed to download marketplace
```

**해결책**: 수동 설치 방법 사용

```bash
# 1. 저장소 복제
git clone https://github.com/softwayapp/market-place.git

# 2. 디렉토리 이동
cd market-place

# 3. 설치 스크립트 실행
bash install-global-skills.sh      # macOS/Linux
powershell -File install-global-skills.ps1  # Windows
```

### 문제 4: 스킬이 보이지 않음

**증상**: Claude Code에서 `@` 입력 시 스킬이 나타나지 않음

**해결책**:

1. **설치 경로 확인**:
   ```bash
   # Windows
   dir %USERPROFILE%\.claude\skills

   # macOS/Linux
   ls ~/.claude/skills
   ```

2. **Claude Code 재시작**

3. **재설치**:
   ```bash
   # 설치 명령어 다시 실행
   ```

### 문제 5: 이전 버전과 충돌

**해결책**: 완전히 제거 후 재설치

```bash
# Windows (PowerShell)
Remove-Item -Path "$env:USERPROFILE\.claude\skills" -Recurse -Force
Remove-Item -Path "$env:USERPROFILE\.claude\commands" -Recurse -Force
Remove-Item -Path "$env:USERPROFILE\.claude\agents" -Recurse -Force

# macOS/Linux
rm -rf ~/.claude/skills ~/.claude/commands ~/.claude/agents

# 그 다음 재설치
```

---

## 📦 오프라인 설치 (인터넷 없는 환경)

### 1. 인터넷이 있는 PC에서

```bash
# 저장소 다운로드
git clone https://github.com/softwayapp/market-place.git

# ZIP으로 압축
zip -r market-place.zip market-place/
```

### 2. USB로 이동

`market-place.zip` 파일을 USB에 복사

### 3. 대상 PC에서

```bash
# ZIP 압축 해제
unzip market-place.zip
cd market-place

# 설치 스크립트 실행
bash install-global-skills.sh      # macOS/Linux
powershell -File install-global-skills.ps1  # Windows
```

---

## 🎓 팀 전체 배포

### 방법 1: 공유 스크립트

**팀 공유 폴더에 스크립트 저장**:

```powershell
# install-team-marketplace.ps1
irm https://raw.githubusercontent.com/softwayapp/market-place/main/quick-install.ps1 | iex
```

팀원들에게 안내:
```
PowerShell에서 실행: .\install-team-marketplace.ps1
```

### 방법 2: 이메일 배포

**이메일 템플릿**:

```
제목: [필독] Claude Code 마켓플레이스 설치 안내

안녕하세요,

Claude Code 개발 생산성 향상을 위해 마켓플레이스를 설치해주세요.

📋 설치 방법 (5분 소요):

Windows:
1. PowerShell을 관리자 권한으로 실행
2. 아래 명령어 복사 후 실행:
   irm https://raw.githubusercontent.com/softwayapp/market-place/main/quick-install.ps1 | iex

macOS/Linux:
1. 터미널 실행
2. 아래 명령어 복사 후 실행:
   curl -fsSL https://raw.githubusercontent.com/softwayapp/market-place/main/quick-install.sh | bash

✅ 설치 완료 후 바로 사용 가능!
❓ 문제 발생 시: dev@softwayapp.com

포함된 도구:
• 32+ 개발 스킬 (API 생성, 테스트 자동화 등)
• 4개 커맨드 (분석, 테스트, 배포, 폰트)
• 3개 전문 에이전트 (백엔드, 성능, 보안)

감사합니다.
```

### 방법 3: 내부 패키지 관리자

**Chocolatey (Windows)** 또는 **Homebrew (macOS)** 패키지 생성

---

## 🔐 보안 고려사항

### 스크립트 검증

설치 전 스크립트 내용 확인:

```bash
# 다운로드만 하고 검토 후 실행
curl -fsSL https://raw.githubusercontent.com/softwayapp/market-place/main/quick-install.sh > install.sh
cat install.sh  # 내용 확인
bash install.sh  # 검토 후 실행
```

### 신뢰할 수 있는 소스

- ✅ **공식 GitHub 저장소**: https://github.com/softwayapp/market-place
- ✅ **검증된 도메인**: raw.githubusercontent.com
- ❌ 비공식 미러나 수정된 스크립트 사용 금지

---

## 📊 설치 통계 (참고)

| 항목 | 수량 |
|-----|-----|
| 총 스킬 | 32+ |
| 커맨드 | 4개 |
| 에이전트 | 3개 |
| 설치 시간 | ~30초 |
| 디스크 공간 | ~5MB |

---

## 📞 지원

### 문제 보고

**GitHub Issues**: https://github.com/softwayapp/market-place/issues

템플릿:
```
**문제**: [간단한 설명]
**OS**: [Windows 11 / macOS 14 / Ubuntu 22.04]
**오류 메시지**: [전체 오류 메시지 복사]
**재현 방법**: [단계별 설명]
```

### 이메일 지원

**Email**: dev@softwayapp.com

**응답 시간**: 영업일 기준 24시간 이내

---

## ✅ 체크리스트

### 설치 전

- [ ] Git 설치 확인 (`git --version`)
- [ ] 인터넷 연결 확인
- [ ] PowerShell/터미널 관리자 권한 확인

### 설치 중

- [ ] 설치 명령어 실행
- [ ] 성공 메시지 확인
- [ ] 설치 경로 확인

### 설치 후

- [ ] Claude Code에서 `/` 입력 → 커맨드 확인
- [ ] Claude Code에서 `@` 입력 → 스킬 확인
- [ ] Quick Reference 파일 확인
- [ ] 테스트 실행: `/font` 또는 `@api-generator`

---

## 🎯 다음 단계

설치가 완료되었다면:

1. **[Quick Reference 확인](~/.claude/MARKETPLACE-QUICK-REFERENCE.md)** - 전체 기능 목록
2. **[사용 가이드 읽기](README.md)** - 상세 사용법
3. **[전략 문서 검토](claudedocs/claude-code-marketplace-strategy.md)** - 활용 전략

---

**마지막 업데이트**: 2026-01-06
**버전**: 1.0.0
**작성자**: SoftwayApp Development Team
