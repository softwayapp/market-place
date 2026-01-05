---
name: github:pr
description: Intelligent PR workflow - Test/Build/Lint → Auto-classify → Branch separation → PR creation → Merge → Cleanup
version: 1.0.0
author: DevOps Team <devops@company.com>
category: github
tags: [github, pull-request, automation, ci-cd, workflow]
status: stable
allowed-tools: [Bash, Read, Grep, Glob, Edit]
triggers:
  - "PR 생성"
  - "풀 리퀘스트"
  - "머지 요청"
  - "코드 리뷰"
  - "create pr"
  - "pull request"
  - "merge request"
  - "code review"
dependencies: [gh, git]
---

# GitHub Pull Request Automation

## 목적

지능형 PR 워크플로우를 통해 테스트, 빌드, 린트를 자동 실행하고, 변경 사항을 자동 분류하여 적절한 브랜치로 분리한 후 PR을 생성, 머지, 정리까지 자동화합니다.

## 사용 시기

### ✅ 이 스킬을 사용할 때

- 기능 개발이 완료되어 PR을 생성해야 할 때
- 여러 타입의 변경사항을 자동으로 분류하고 싶을 때
- 테스트/빌드/린트를 자동으로 실행하고 싶을 때
- PR 생성부터 머지까지 전체 워크플로우를 자동화하고 싶을 때
- 일관된 PR 포맷과 프로세스를 유지하고 싶을 때

### ❌ 이 스킬을 사용하지 않을 때

- WIP(Work In Progress) 단계에서 중간 체크인할 때
- 복잡한 머지 충돌이 예상될 때
- 수동으로 PR 설명을 상세히 작성해야 할 때
- Draft PR을 만들어야 할 때
- 여러 저장소에 동시에 PR을 생성할 때

## 작동 방식

### 전체 워크플로우

```
1. Test/Build/Lint 실행 → 2. 변경사항 분류 → 3. 브랜치 분리
    ↓
4. PR 생성 → 5. 코드 리뷰 → 6. 승인 → 7. 머지 → 8. 정리
```

### 단계별 세부 동작

#### 1단계: 품질 검증
```bash
# 테스트 실행
npm test || yarn test

# 빌드 검증
npm run build || yarn build

# 린트 검사
npm run lint || yarn lint

# 타입 체크 (TypeScript)
npm run type-check || tsc --noEmit
```

#### 2단계: 자동 분류
변경된 파일을 분석하여 타입을 자동 감지:
- **feature**: 새로운 기능 추가
- **fix**: 버그 수정
- **refactor**: 코드 리팩토링
- **docs**: 문서 변경
- **test**: 테스트 추가/수정
- **style**: 코드 스타일 변경
- **chore**: 빌드/설정 변경

#### 3단계: 브랜치 분리
여러 타입이 섞여 있으면 자동으로 브랜치 분리:
```bash
feature/user-auth    # 기능 변경사항만
fix/login-bug        # 버그 수정만
refactor/api-cleanup # 리팩토링만
```

#### 4단계: PR 생성
```bash
gh pr create \
  --title "[TYPE] 제목" \
  --body "$(cat <<'EOF'
## Summary
[변경 사항 요약]

## Changes
- [주요 변경 1]
- [주요 변경 2]

## Test Plan
- [x] 단위 테스트 통과
- [x] 빌드 성공
- [x] 린트 검사 통과

## Screenshots
[필요시 스크린샷]

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)" \
  --label "type:[타입]" \
  --assignee "@me"
```

## 예제

### 예제 1: 단일 타입 변경 (Feature)

**사용자 입력:**
```
"유저 인증 기능 완료했어. PR 만들어줘"
```

**스킬 동작:**

1. **품질 검증**
```bash
✓ Tests: 45 passed
✓ Build: successful
✓ Lint: no errors
✓ Type check: passed
```

2. **변경사항 분석**
```
분석된 파일:
- src/auth/login.ts (NEW)
- src/auth/register.ts (NEW)
- src/middleware/auth.ts (NEW)
- tests/auth.test.ts (NEW)

분류: feature (100% - 모든 파일이 새로운 기능)
```

3. **브랜치 확인**
```bash
현재 브랜치: feature/user-auth
✓ 이미 적절한 브랜치에 있음
```

4. **PR 생성**
```bash
gh pr create \
  --title "[Feature] Add user authentication" \
  --body "$(cat <<'EOF'
## Summary
사용자 인증 시스템을 구현했습니다. JWT 기반 인증, 로그인/회원가입 기능을 포함합니다.

## Changes
- ✨ JWT 토큰 기반 인증 구현
- 🔐 로그인 엔드포인트 추가
- 📝 회원가입 엔드포인트 추가
- 🛡️ 인증 미들웨어 구현
- ✅ 인증 테스트 추가

## Test Plan
- [x] 45 unit tests passed
- [x] Build successful
- [x] Lint checks passed
- [x] Type checking passed
- [x] Manual testing completed

## Security Considerations
- 비밀번호 bcrypt 해싱
- JWT 토큰 만료 시간 설정
- HTTPS 전용 쿠키 사용

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)" \
  --label "feature,backend,security" \
  --assignee "@me"
```

**출력:**
```
✅ Pull Request created: https://github.com/user/repo/pull/456
   Branch: feature/user-auth → main
   Type: feature
   Title: [Feature] Add user authentication
   Labels: feature, backend, security
   Assignee: @me
   Status: Ready for review
```

### 예제 2: 혼합 타입 변경 (자동 분리)

**사용자 입력:**
```
"모든 작업 완료. PR 생성해줘"
```

**스킬 동작:**

1. **품질 검증** (통과)

2. **변경사항 분석**
```
분석된 파일:
- src/components/Button.tsx (MODIFIED) → feature
- src/utils/api.ts (MODIFIED) → fix
- src/styles/theme.ts (MODIFIED) → refactor
- README.md (MODIFIED) → docs
- tests/button.test.ts (NEW) → test

분류: 혼합 (feature: 20%, fix: 20%, refactor: 20%, docs: 20%, test: 20%)
⚠️ 여러 타입이 섞여 있음 → 브랜치 분리 권장
```

3. **자동 브랜치 분리**
```bash
# 원본 브랜치 백업
git branch backup/combined-changes

# 타입별 브랜치 생성
git checkout -b feature/button-enhancement
git checkout main
git checkout -b fix/api-error-handling
git checkout main
git checkout -b refactor/theme-structure
git checkout main
git checkout -b docs/readme-update

# 변경사항을 각 브랜치로 체리픽
git checkout feature/button-enhancement
git checkout backup/combined-changes -- src/components/Button.tsx tests/button.test.ts
git commit -m "feat: enhance button component"

git checkout fix/api-error-handling
git checkout backup/combined-changes -- src/utils/api.ts
git commit -m "fix: improve API error handling"

# ... 나머지 브랜치들도 동일하게
```

4. **각 브랜치별 PR 생성**
```
✅ Created 4 Pull Requests:

1. #457: [Feature] Enhance button component
   Branch: feature/button-enhancement → main
   Files: Button.tsx, button.test.ts

2. #458: [Fix] Improve API error handling
   Branch: fix/api-error-handling → main
   Files: api.ts

3. #459: [Refactor] Restructure theme system
   Branch: refactor/theme-structure → main
   Files: theme.ts

4. #460: [Docs] Update README
   Branch: docs/readme-update → main
   Files: README.md
```

### 예제 3: 완전 자동화 워크플로우 (생성 → 머지)

**사용자 입력:**
```
"작업 완료. 테스트 통과하면 자동으로 머지까지 해줘"
```

**스킬 동작:**

1. **품질 검증** ✓
2. **변경사항 분류** ✓
3. **PR 생성** ✓

4. **CI 대기**
```
⏳ Waiting for CI checks...
   ✓ Tests (45/45 passed)
   ✓ Build (successful)
   ✓ Lint (no errors)
   ✓ Security scan (no vulnerabilities)
```

5. **자동 머지**
```bash
# 모든 체크가 통과하면
gh pr merge 456 --squash --auto

✅ PR #456 merged successfully
   Merge method: squash
   Commit: abc1234
```

6. **정리**
```bash
# 원격 브랜치 삭제
git push origin --delete feature/user-auth

# 로컬 브랜치 삭제
git branch -d feature/user-auth

# 메인 브랜치로 전환
git checkout main
git pull

✅ Cleanup completed
   ✓ Remote branch deleted
   ✓ Local branch deleted
   ✓ Switched to main
```

## 설정

`.skillconfig.json` 또는 `.github/pr_config.json`:

```json
{
  "githubPr": {
    "workflow": {
      "runTests": true,
      "runBuild": true,
      "runLint": true,
      "runTypeCheck": true,
      "stopOnFailure": true
    },
    "classification": {
      "autoDetect": true,
      "separateBranches": true,
      "mixedThreshold": 0.7
    },
    "prCreation": {
      "assignToMe": true,
      "addLabels": true,
      "addReviewers": [],
      "template": "detailed",
      "draft": false
    },
    "merge": {
      "autoMerge": false,
      "mergeMethod": "squash",
      "deleteAfterMerge": true,
      "requireApprovals": 1,
      "requireCI": true
    },
    "cleanup": {
      "deleteLocalBranch": true,
      "deleteRemoteBranch": true,
      "switchToMain": true,
      "pullLatest": true
    }
  }
}
```

### 설정 옵션 설명

#### workflow
- **runTests**: 테스트 실행 여부
- **runBuild**: 빌드 검증 여부
- **runLint**: 린트 검사 여부
- **runTypeCheck**: 타입 체크 여부
- **stopOnFailure**: 실패 시 중단 여부

#### classification
- **autoDetect**: 자동 타입 감지
- **separateBranches**: 혼합 시 브랜치 분리
- **mixedThreshold**: 혼합 판단 임계값 (0.7 = 70%)

#### merge
- **autoMerge**: CI 통과 시 자동 머지
- **mergeMethod**: 머지 방식 (squash/merge/rebase)
- **deleteAfterMerge**: 머지 후 브랜치 삭제
- **requireApprovals**: 필요한 승인 수
- **requireCI**: CI 통과 필수 여부

## 변경사항 분류 규칙

### Feature 감지
```yaml
patterns:
  - new files in src/
  - new components
  - new API endpoints
  - new features directory
keywords:
  - "add", "implement", "create", "feature"
```

### Fix 감지
```yaml
patterns:
  - bug fix commits
  - error handling changes
  - patches
keywords:
  - "fix", "bug", "patch", "resolve", "correct"
```

### Refactor 감지
```yaml
patterns:
  - code structure changes
  - no functional changes
  - optimization
keywords:
  - "refactor", "cleanup", "optimize", "improve"
```

## 가이드라인

### PR 제목 규칙
```
[Type] 간결한 설명 (50자 이내)

예시:
✅ [Feature] Add user authentication
✅ [Fix] Resolve login redirect issue
✅ [Refactor] Simplify API client
❌ Updated some files
❌ Changes
```

### PR 본문 구조
```markdown
## Summary
[1-2문장으로 변경사항 요약]

## Changes
- [변경사항 1]
- [변경사항 2]

## Test Plan
- [x] 테스트 항목 1
- [x] 테스트 항목 2

## Related Issues
Closes #123
Related to #456
```

### 브랜치 네이밍
```
feature/[기능명]     # 새 기능
fix/[버그명]         # 버그 수정
refactor/[대상]      # 리팩토링
docs/[문서명]        # 문서 변경
test/[테스트명]      # 테스트
chore/[작업명]       # 기타 작업
```

## 출력 형식

### 성공 케이스
```
🎉 PR Workflow Completed

✅ Quality Checks
   ✓ Tests: 45 passed
   ✓ Build: successful
   ✓ Lint: no errors

✅ Pull Request Created
   URL: https://github.com/user/repo/pull/456
   Branch: feature/user-auth → main
   Type: feature
   Labels: feature, backend

✅ CI Checks Passed
   ✓ All checks green

✅ Merged & Cleaned Up
   ✓ PR merged (squash)
   ✓ Branches deleted
   ✓ Ready for next task
```

### 실패 케이스
```
❌ PR Workflow Failed

Step: Quality Checks
Error: Tests failed (3/45)

Failed tests:
  - auth.test.ts: login with invalid credentials
  - auth.test.ts: token expiration
  - auth.test.ts: refresh token

🔧 Action Required:
   1. Fix failing tests
   2. Run: npm test
   3. Retry PR creation

Status: Workflow stopped
```

## 의존성

### 필수
- **GitHub CLI (gh)**: PR 생성 및 관리
- **Git**: 브랜치 관리 및 커밋
- **Node.js/npm** 또는 **Yarn**: 테스트/빌드 실행 (프로젝트에 따라)

### 선택적
- **TypeScript**: 타입 체크 시
- **ESLint**: 린트 검사 시
- **Jest/Mocha**: 테스트 실행 시

## 제한사항

- **GitHub 전용**: GitHub 외 플랫폼 미지원
- **단일 저장소**: 한 번에 한 저장소만 처리
- **CI 의존성**: CI 설정이 되어 있어야 자동 머지 가능
- **권한 필요**: 저장소에 대한 쓰기 권한 필수
- **복잡한 충돌**: 머지 충돌은 수동 해결 필요

## 버전 이력

### 1.0.0 (2025-01-05)
- 초기 릴리스
- 전체 워크플로우 자동화
- 자동 타입 감지 및 브랜치 분리
- 품질 검증 (Test/Build/Lint)
- 자동 머지 및 정리

## 기여자

- DevOps Team (devops@company.com) - 초기 개발 및 자동화
- Backend Team - 품질 검증 로직 구현
- Frontend Team - 브랜치 분류 규칙 정의

## 지원

문제가 발생하거나 질문이 있으면:
- **Slack**: #devops-support
- **Email**: devops@company.com
- **이슈**: GitHub Issues

## 라이선스

MIT License - 조직 내부 사용 전용
