---
name: accessibility-audit
description: Automated WCAG 2.1 accessibility audit with a11y best practices and ARIA validation
version: 1.3.0
author: Frontend Team <frontend@company.com>
category: frontend
tags: [accessibility, a11y, wcag, aria, audit]
status: stable
allowed-tools: [Read, Bash, Grep]
triggers:
  - "접근성 검사"
  - "a11y 감사"
  - "accessibility audit"
  - "check wcag"
dependencies: []
---

# Accessibility Audit

## 목적

WCAG 2.1 기준에 따라 웹 접근성을 자동으로 검사하고 개선 방안을 제안합니다.

## 사용 시기

### ✅ 이 스킬을 사용할 때

- 웹 접근성 준수가 필요할 때
- 정부/공공기관 프로젝트
- 장애인 사용자 지원이 필요할 때
- ARIA 속성 검증

### ❌ 이 스킬을 사용하지 않을 때

- 모바일 네이티브 앱
- 백엔드 API

## 작동 방식

1. **HTML 구조 분석**: 시맨틱 태그 사용 여부
2. **ARIA 검증**: 올바른 ARIA 속성 사용
3. **컬러 대비**: WCAG AA/AAA 기준 확인
4. **키보드 접근성**: Tab 순서 및 Focus 관리

## 예제

### 예제 1: 접근성 이슈 탐지

**발견된 이슈:**
```html
<!-- ❌ Bad: 이미지에 alt 속성 없음 -->
<img src="logo.png">

<!-- ✅ Good: 대체 텍스트 제공 -->
<img src="logo.png" alt="회사 로고">
```

```html
<!-- ❌ Bad: 버튼에 라벨 없음 -->
<button><i class="icon-close"></i></button>

<!-- ✅ Good: aria-label 추가 -->
<button aria-label="닫기"><i class="icon-close"></i></button>
```

```html
<!-- ❌ Bad: 색상 대비 부족 -->
<p style="color: #999; background: #fff;">텍스트</p>
<!-- 대비율: 2.85:1 (WCAG AA 미달) -->

<!-- ✅ Good: 충분한 대비 -->
<p style="color: #333; background: #fff;">텍스트</p>
<!-- 대비율: 12.63:1 (WCAG AAA 통과) -->
```

### 예제 2: 자동 수정 제안

**리포트:**
```
접근성 감사 결과
━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔴 Critical (5):
  - 3개 이미지에 alt 속성 누락
  - 2개 버튼에 접근 가능한 이름 없음

🟡 Warning (8):
  - 5개 요소의 색상 대비 부족
  - 3개 링크의 목적이 불명확

🟢 Passed (45)

개선 방안:
1. src/components/Header.tsx:15 - 이미지에 alt 추가
2. src/components/Modal.tsx:23 - 버튼에 aria-label 추가
3. src/styles/theme.ts:10 - 색상 대비 개선
```

## 설정

`.skillconfig.json`:
```json
{
  "accessibilityAudit": {
    "standard": "WCAG21AA",
    "autoFix": false,
    "reportFormat": "markdown"
  }
}
```

## 의존성

```json
{
  "axe-core": "^4.0.0",
  "eslint-plugin-jsx-a11y": "^6.7.0"
}
```

## 라이선스

MIT License - 조직 내부 사용 전용
