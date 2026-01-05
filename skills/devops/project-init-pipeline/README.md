# Project Initialization Pipeline Skill

프로젝트 초기화 자동화 파이프라인 - Expo와 Next.js 프로젝트 셋업을 완전 자동화합니다.

## 빠른 시작

```bash
# 스킬 설치 (내부 명령어 시스템 포함)
/plugin install project-init-pipeline@internal-marketplace

# 새 Expo 프로젝트
/init:expo MyApp
# "실행해" 입력

# 새 Next.js 프로젝트
/init:next MyWebApp
# "run it" 입력
```

## 주요 기능

- ✅ Atomic Design 폴더 구조 자동 생성 (15개 폴더)
- ✅ CSS 라이브러리 자동 설치 (NativeWind/Tailwind)
- ✅ Pretendard 폰트 자동 다운로드 (4 variants)
- ✅ 폴더별 역할 가이드 (15개 CLAUDE.md) 자동 배치
- ✅ React Query 패턴 (queries/mutations) 강제
- ✅ 설정 파일 자동 생성

## 생성되는 구조

```
프로젝트/
├── components/ (atoms, molecules, organisms, templates)
├── hooks/ (queries, mutations)
├── utils/, types/, schema/, libs/, stores/
├── styles/, constants/, mock/
└── 각 폴더마다 CLAUDE.md 가이드 포함
```

## 문서

- 전체 문서: [SKILL.md](SKILL.md)
- 완전 가이드: [docs/project-init-pipeline-guide.md](../../../docs/project-init-pipeline-guide.md)
- 시스템 아키텍처, 워크플로우, 템플릿 시스템 등 상세 설명

## 지원

- **Slack**: #devops-support
- **Email**: devops@company.com

## 라이선스

MIT - 내부 사용 전용
