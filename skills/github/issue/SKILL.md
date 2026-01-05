---
name: github:issue
description: Create GitHub issue with auto type detection (bug/feature/task)
version: 1.0.0
author: DevOps Team <devops@company.com>
category: github
tags: [github, issue, automation, bug-tracking, project-management]
status: stable
allowed-tools: [Bash, Read, Grep, Glob]
triggers:
  - "이슈 생성"
  - "깃허브 이슈"
  - "버그 리포트"
  - "기능 요청"
  - "create issue"
  - "github issue"
  - "bug report"
  - "feature request"
  - "report bug"
dependencies: [gh]
---

# GitHub Issue Creator

## 목적

GitHub CLI (`gh`)를 사용하여 자동으로 이슈 타입을 감지하고, 적절한 레이블과 템플릿으로 GitHub 이슈를 생성합니다. 수동 분류 작업을 제거하고, 일관된 이슈 포맷을 유지하며, 프로젝트 관리 워크플로우를 자동화합니다.

## 사용 시기

### ✅ 이 스킬을 사용할 때

- 버그를 발견하고 이슈를 생성해야 할 때
- 새로운 기능 아이디어를 이슈로 등록할 때
- 작업(task)을 이슈 트래커에 추가할 때
- 이슈 타입 분류를 자동화하고 싶을 때
- 일관된 이슈 포맷을 유지하고 싶을 때

### ❌ 이 스킬을 사용하지 않을 때

- 이미 GitHub 웹 UI에서 이슈를 작성 중일 때
- 복잡한 이슈 템플릿 커스터마이징이 필요할 때
- 여러 저장소에 동시에 이슈를 생성할 때
- GitHub 외의 이슈 트래킹 시스템을 사용할 때

## 작동 방식

1. **컨텍스트 분석**: 사용자 입력과 코드 컨텍스트를 분석합니다
2. **타입 감지**: 키워드와 패턴으로 이슈 타입을 자동 분류합니다
   - `bug`: 에러, 오류, 버그, crash, fail 등
   - `feature`: 기능, 추가, 개선, enhancement 등
   - `task`: 작업, todo, refactor, update 등
3. **레이블 자동 적용**: 감지된 타입에 따라 적절한 레이블을 추가합니다
4. **이슈 생성**: `gh issue create` 명령으로 이슈를 생성합니다
5. **링크 반환**: 생성된 이슈 URL을 반환합니다

## 예제

### 예제 1: 버그 이슈 생성

**사용자 입력:**
```
"로그인 페이지에서 인증 실패 버그 이슈 생성해줘"
```

**스킬 동작:**

1. 타입 감지: "버그" 키워드 → `bug` 타입
2. 제목 생성: "로그인 페이지 인증 실패"
3. 본문 생성:

```markdown
## 버그 설명
로그인 페이지에서 인증 실패가 발생합니다.

## 재현 단계
1. 로그인 페이지 접속
2. 유효한 자격 증명 입력
3. 로그인 시도

## 기대 동작
정상적으로 인증되어야 합니다.

## 실제 동작
인증이 실패합니다.

## 환경
- Browser: [자동 감지]
- OS: [자동 감지]
- Version: [자동 감지]

🤖 Generated with [Claude Code](https://claude.com/claude-code)
```

4. 명령 실행:
```bash
gh issue create \
  --title "로그인 페이지 인증 실패" \
  --body "$(cat <<'EOF'
[위 본문 내용]
EOF
)" \
  --label "bug,priority:high"
```

**출력:**
```
✅ Issue created: https://github.com/user/repo/issues/123
   Type: bug
   Title: 로그인 페이지 인증 실패
   Labels: bug, priority:high
```

### 예제 2: 기능 요청 이슈 생성

**사용자 입력:**
```
"다크 모드 기능 추가해야 해. 이슈 만들어줘"
```

**스킬 동작:**

1. 타입 감지: "기능 추가" 패턴 → `feature` 타입
2. 제목: "다크 모드 기능 추가"
3. 본문:

```markdown
## 기능 설명
다크 모드를 추가합니다.

## 동기 및 배경
사용자 경험을 개선하고 눈의 피로를 줄이기 위해 다크 모드가 필요합니다.

## 제안 구현
- [ ] 다크 모드 토글 버튼 추가
- [ ] 테마 상태 관리
- [ ] CSS 변수로 색상 시스템 구현
- [ ] 사용자 선택 로컬 저장소에 저장

## 대안
시스템 테마 자동 감지 옵션도 고려할 수 있습니다.

🤖 Generated with [Claude Code](https://claude.com/claude-code)
```

4. 명령 실행:
```bash
gh issue create \
  --title "다크 모드 기능 추가" \
  --body "[본문]" \
  --label "feature,enhancement"
```

### 예제 3: 작업 이슈 생성

**사용자 입력:**
```
"코드 리팩토링 작업 이슈 생성"
```

**타입 감지:** `task` (refactor 키워드)

**생성 내용:**
```markdown
## 작업 설명
코드 리팩토링을 진행합니다.

## 체크리스트
- [ ] 코드 분석 및 개선 대상 파악
- [ ] 리팩토링 계획 수립
- [ ] 구현
- [ ] 테스트 검증
- [ ] 코드 리뷰

## 예상 소요 시간
[필요 시 자동 추정]

🤖 Generated with [Claude Code](https://claude.com/claude-code)
```

## 설정

`.skillconfig.json` 또는 `.github/issue_config.json`:

```json
{
  "githubIssue": {
    "defaultLabels": {
      "bug": ["bug", "priority:high"],
      "feature": ["feature", "enhancement"],
      "task": ["task", "maintenance"]
    },
    "assignToMe": true,
    "addProjectBoard": false,
    "defaultMilestone": null,
    "templateStyle": "detailed",
    "autoDetect": true,
    "includeContext": true,
    "contextFiles": 3
  }
}
```

### 설정 옵션

- **defaultLabels**: 각 이슈 타입별 기본 레이블
- **assignToMe**: 이슈를 자신에게 자동 할당
- **addProjectBoard**: 프로젝트 보드에 자동 추가
- **defaultMilestone**: 기본 마일스톤
- **templateStyle**: 템플릿 스타일 (simple, detailed, minimal)
- **autoDetect**: 자동 타입 감지 활성화
- **includeContext**: 코드 컨텍스트 포함 여부
- **contextFiles**: 포함할 컨텍스트 파일 수

## 타입 감지 규칙

### Bug 감지 키워드
```
버그, 오류, 에러, 문제, 실패, 깨짐, 작동 안 함
bug, error, issue, crash, fail, broken, not working, doesn't work
```

### Feature 감지 키워드
```
기능, 추가, 개선, 향상, 새로운
feature, add, new, enhance, improvement, implement, support
```

### Task 감지 키워드
```
작업, 할일, 리팩토링, 업데이트, 정리, 변경
task, todo, refactor, update, cleanup, change, modify, chore
```

## 가이드라인

### 이슈 제목
- 명확하고 구체적으로 작성
- 50자 이내 권장
- 동사로 시작 (추가, 수정, 개선)

### 이슈 본문
- 문제/기능을 명확하게 설명
- 재현 단계 또는 구현 계획 포함
- 스크린샷이나 로그 추가 (필요 시)
- 체크리스트로 작업 분해

### 레이블 사용
- 우선순위: `priority:high`, `priority:medium`, `priority:low`
- 타입: `bug`, `feature`, `task`
- 상태: `in-progress`, `blocked`, `ready`

## 출력 형식

```
✅ Issue created: [URL]
   Type: [bug|feature|task]
   Title: [제목]
   Labels: [레이블 목록]
   Assigned: [담당자] (설정된 경우)
```

## 의존성

### 필수
- **GitHub CLI (`gh`)**: 이슈 생성에 필요
  ```bash
  # 설치 확인
  gh --version

  # 인증
  gh auth login
  ```

### 선택적
- Git 저장소 (이슈를 생성할 저장소)

## 제한사항

- **GitHub 전용**: GitLab, Bitbucket 등 다른 플랫폼 미지원
- **gh CLI 필수**: GitHub CLI가 설치되고 인증되어 있어야 함
- **단일 저장소**: 한 번에 한 저장소에만 이슈 생성 가능
- **복잡한 템플릿**: 매우 복잡한 커스텀 템플릿은 수동 조정 필요

## 버전 이력

### 1.0.0 (2025-01-05)
- 초기 릴리스
- 자동 타입 감지 (bug/feature/task)
- 기본 이슈 템플릿 생성
- 레이블 자동 적용

## 기여자

- DevOps Team (devops@company.com) - 초기 개발
- Backend Team - 자동 분류 로직 개선

## 지원

문제가 발생하거나 질문이 있으면:
- **Slack**: #devops-support
- **Email**: devops@company.com
- **이슈**: GitHub Issues

## 라이선스

MIT License - 조직 내부 사용 전용
