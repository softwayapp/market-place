# 기여 가이드

내부 마켓플레이스에 기여해주셔서 감사합니다! 이 문서는 스킬, 에이전트, 커맨드를 기여하는 방법을 설명합니다.

## 📋 목차

- [행동 강령](#행동-강령)
- [기여 방법](#기여-방법)
- [개발 환경 설정](#개발-환경-설정)
- [스킬 개발 가이드](#스킬-개발-가이드)
- [제출 프로세스](#제출-프로세스)
- [코드 리뷰](#코드-리뷰)
- [스타일 가이드](#스타일-가이드)

## 행동 강령

### 우리의 약속

존중과 협력의 문화를 유지하기 위해 모든 기여자는:

- 다른 관점과 경험을 존중합니다
- 건설적인 피드백을 제공하고 받습니다
- 팀과 조직의 최선의 이익을 우선시합니다
- 전문적이고 포용적인 환경을 유지합니다

## 기여 방법

### 기여 유형

1. **새로운 스킬 추가**
   - 새로운 자동화 기능 구현
   - 기존 워크플로우 개선

2. **기존 스킬 개선**
   - 버그 수정
   - 성능 최적화
   - 기능 향상

3. **문서 개선**
   - 가이드 작성 및 업데이트
   - 예제 추가
   - 튜토리얼 작성

4. **버그 리포트**
   - 이슈 생성 및 재현 단계 제공

## 개발 환경 설정

### 1. 저장소 포크 및 클론

```bash
# 저장소 포크 (GitHub UI에서)
# 그 다음 클론
git clone https://github.com/[your-username]/internal-marketplace.git
cd internal-marketplace
```

### 2. 업스트림 설정

```bash
git remote add upstream https://github.com/[organization]/internal-marketplace.git
git fetch upstream
```

### 3. 개발 브랜치 생성

```bash
# 최신 main 브랜치에서 시작
git checkout main
git pull upstream main

# 기능 브랜치 생성
git checkout -b feature/your-skill-name
```

### 4. 로컬 개발 환경

```bash
# 마켓플레이스를 로컬 Claude Code에 링크
/plugin install file://$(pwd)

# 또는 심볼릭 링크 생성
ln -s $(pwd) ~/.claude/marketplaces/internal-dev
```

## 스킬 개발 가이드

### 스킬 구조

```
skills/[category]/[skill-name]/
├── SKILL.md           # 필수: 스킬 정의
├── README.md          # 선택: 상세 문서
├── examples/          # 선택: 사용 예제
│   └── example.md
├── tests/             # 권장: 테스트 케이스
│   └── test.md
└── scripts/           # 선택: 헬퍼 스크립트
    └── helper.sh
```

### SKILL.md 템플릿

```markdown
---
name: skill-name
description: Clear description of what this skill does and when to use it
version: 1.0.0
author: Your Name <your.email@company.com>
category: backend|frontend|devops|security|quality|documentation
tags: [tag1, tag2, tag3]
status: beta|stable|deprecated
allowed-tools: [Read, Write, Grep, Bash, Edit]
triggers:
  - "keyword or phrase 1"
  - "keyword or phrase 2"
dependencies:
  - skill-name-1
  - skill-name-2
---

# Skill Name

## 목적

이 스킬이 해결하는 문제와 목적을 명확히 설명합니다.

## 사용 시기

- ✅ 시나리오 1
- ✅ 시나리오 2

## 사용하지 않을 때

- ❌ 시나리오 1
- ❌ 시나리오 2

## 작동 방식

1. 단계 1
2. 단계 2
3. 단계 3

## 예제

### 예제 1: [시나리오 설명]

\`\`\`
사용자 입력: "..."
스킬 동작: ...
결과: ...
\`\`\`

## 설정

프로젝트에 `.skillconfig.json` 파일이 필요한 경우:

\`\`\`json
{
  "skillName": {
    "option1": "value1"
  }
}
\`\`\`

## 제한사항

- 제한사항 1
- 제한사항 2

## 의존성

- 필요한 패키지 또는 도구
```

### 검증 체크리스트

제출 전에 다음을 확인하세요:

- [ ] SKILL.md에 모든 필수 메타데이터 포함
- [ ] 명확하고 구체적인 설명
- [ ] 최소 2개 이상의 사용 예제
- [ ] triggers 키워드 정의
- [ ] 의존성 명시 (있는 경우)
- [ ] 로컬에서 테스트 완료
- [ ] 문서 작성 완료
- [ ] 스타일 가이드 준수

### 스킬 테스트

```bash
# 검증 스크립트 실행
./scripts/validate-skills.sh

# 특정 스킬만 검증
./scripts/validate-skills.sh skills/backend/api-generator
```

## 제출 프로세스

### 1. 변경사항 커밋

```bash
# 변경사항 스테이징
git add .

# 커밋 (명확한 메시지와 함께)
git commit -m "feat(backend): Add API generator skill for RESTful endpoints"
```

#### 커밋 메시지 규칙

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Type:**
- `feat`: 새로운 기능
- `fix`: 버그 수정
- `docs`: 문서 변경
- `style`: 코드 포맷팅 (기능 변경 없음)
- `refactor`: 리팩토링
- `test`: 테스트 추가/수정
- `chore`: 빌드/설정 변경

**Scope:**
- `backend`, `frontend`, `devops`, `security`, `quality`, `docs`

**예제:**
```
feat(backend): Add database migration skill

- Auto-generate migration files from schema changes
- Support PostgreSQL and MySQL
- Include rollback capabilities

Closes #123
```

### 2. 푸시 및 Pull Request

```bash
# 포크된 저장소에 푸시
git push origin feature/your-skill-name

# GitHub에서 Pull Request 생성
```

### 3. Pull Request 템플릿

```markdown
## 변경 사항 요약
<!-- 무엇을 변경했는지 간단히 설명 -->

## 변경 유형
- [ ] 새로운 스킬 추가
- [ ] 기존 스킬 개선
- [ ] 버그 수정
- [ ] 문서 개선
- [ ] 기타: ___________

## 스킬 정보 (스킬 추가/수정인 경우)
- **카테고리**: backend|frontend|devops|security|quality|documentation
- **스킬 이름**: skill-name
- **버전**: 1.0.0
- **상태**: beta|stable

## 체크리스트
- [ ] SKILL.md에 모든 필수 필드 포함
- [ ] 예제 및 사용 가이드 작성
- [ ] 로컬에서 테스트 완료
- [ ] 검증 스크립트 통과
- [ ] 문서 업데이트
- [ ] CHANGELOG.md 업데이트

## 테스트 방법
<!-- 리뷰어가 이 스킬을 어떻게 테스트할 수 있는지 설명 -->

1. 스킬 설치: `/plugin install ...`
2. 테스트 명령: "..."
3. 예상 결과: ...

## 관련 이슈
<!-- Closes #123, Fixes #456 형식으로 연결 -->

## 스크린샷 (선택사항)
<!-- 스킬 동작을 보여주는 스크린샷 -->
```

## 코드 리뷰

### 리뷰 프로세스

1. **자동 검증** (GitHub Actions)
   - 스킬 메타데이터 유효성 검사
   - 파일 구조 검증
   - 문법 체크

2. **피어 리뷰** (최소 2명)
   - 기능 정확성
   - 코드 품질
   - 문서 완성도

3. **보안 리뷰** (보안 관련 스킬)
   - 보안팀 승인 필요
   - 취약점 검토

4. **최종 승인**
   - 메인테이너 승인
   - 병합

### 리뷰 기준

**필수 항목:**
- [ ] 스킬이 설명대로 작동
- [ ] 문서가 명확하고 완전함
- [ ] 보안 문제 없음
- [ ] 기존 스킬과 충돌 없음
- [ ] 성능 영향 최소화

**권장 항목:**
- [ ] 에러 처리 적절
- [ ] 사용자 피드백 명확
- [ ] 테스트 케이스 포함
- [ ] 예제가 실용적

## 스타일 가이드

### 문서 스타일

- **명확성**: 기술적이지만 이해하기 쉽게
- **간결성**: 불필요한 내용 제거
- **구조화**: 섹션 구분 명확
- **예제**: 실용적이고 완전한 예제 제공

### 코드 스타일

- **일관성**: 기존 스킬 패턴 따르기
- **가독성**: 명확한 변수/함수명
- **주석**: 복잡한 로직에만 주석
- **에러 처리**: 명확한 에러 메시지

### 네이밍 규칙

**스킬 이름:**
- 소문자, 하이픈 사용
- 동작 설명적 (예: `api-generator`, `test-runner`)

**파일명:**
- SKILL.md (필수 대문자)
- README.md
- 기타는 소문자-하이픈

**카테고리:**
- backend, frontend, devops, security, quality, documentation

## 릴리스 프로세스

### 버전 관리 (Semantic Versioning)

```
MAJOR.MINOR.PATCH

MAJOR: 호환성 없는 변경
MINOR: 기능 추가 (호환성 유지)
PATCH: 버그 수정
```

### 릴리스 단계

1. **개발**
   - feature 브랜치에서 개발
   - PR 생성 및 리뷰

2. **베타**
   - `status: beta`로 표시
   - 제한된 사용자 테스트

3. **안정화**
   - 버그 수정 및 개선
   - `status: stable`로 변경

4. **릴리스**
   - 태그 생성: `git tag -a v1.0.0 -m "Release v1.0.0"`
   - 푸시: `git push origin v1.0.0`
   - GitHub Release 생성 (자동)

## 도움 받기

### 질문이 있으신가요?

- **Slack**: #claude-code-marketplace
- **Email**: dev-support@company.com
- **Wiki**: https://wiki.company.com/claude-marketplace
- **GitHub Issues**: 질문이나 제안 생성

### 멘토링

새로운 기여자를 위한 멘토링 프로그램:
- #claude-mentorship 채널 방문
- 간단한 이슈부터 시작 (라벨: `good-first-issue`)

## 감사의 말

모든 기여자분들께 감사드립니다! 여러분의 기여가 팀 전체의 생산성을 향상시킵니다.

---

**Happy Contributing! 🚀**
