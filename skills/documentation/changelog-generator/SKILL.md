---
name: changelog-generator
description: Generate and maintain CHANGELOG.md from git commits and conventional commits
version: 1.2.0
author: Documentation Team <docs@company.com>
category: documentation
tags: [changelog, versioning, conventional-commits, release-notes, semver]
status: stable
allowed-tools: [Read, Write, Edit, Bash]
triggers:
  - "CHANGELOG 생성"
  - "릴리즈 노트"
  - "generate changelog"
  - "create release notes"
  - "version history"
dependencies: []
---

# Changelog Generator

## 목적

Git 커밋 히스토리와 Conventional Commits에서 CHANGELOG.md를 자동 생성합니다.

## 사용 시기

### ✅ 이 스킬을 사용할 때

- 새 버전 릴리즈 전 CHANGELOG 업데이트
- Conventional Commits 사용 프로젝트
- 자동화된 릴리즈 노트 생성

### ❌ 이 스킬을 사용하지 않을 때

- 커밋 메시지가 표준화되지 않은 경우
- 매우 복잡한 릴리즈 노트 필요

## 작동 방식

1. **커밋 분석**: Git 히스토리에서 커밋 수집
2. **분류**: Conventional Commits 형식으로 분류 (feat, fix, docs, etc.)
3. **그룹화**: 타입별로 변경사항 그룹화
4. **CHANGELOG 생성**: Keep a Changelog 형식으로 작성

## 예제

### 예제 1: 기본 CHANGELOG

**Git 커밋 히스토리:**
```bash
feat: add user authentication
feat: implement password reset
fix: resolve login redirect issue
fix: patch security vulnerability in auth
docs: update API documentation
chore: update dependencies
```

**생성되는 CHANGELOG.md:**
```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- User authentication system
- Password reset functionality

### Fixed
- Login redirect issue
- Security vulnerability in authentication module

### Documentation
- Updated API documentation

### Internal
- Updated project dependencies

## [1.2.0] - 2025-01-05

### Added
- Dark mode support
- Export to PDF functionality
- User profile customization

### Changed
- Improved performance of data loading
- Updated UI components to use new design system

### Fixed
- Memory leak in data processing
- Incorrect date formatting in reports

### Security
- Patched XSS vulnerability in comment system
- Updated authentication middleware

## [1.1.0] - 2024-12-15

### Added
- Real-time notifications
- Multi-language support (EN, KO, JP)

### Changed
- Redesigned dashboard layout
- Optimized database queries

### Deprecated
- Legacy API endpoints (will be removed in 2.0.0)

### Fixed
- Timezone handling issues
- Mobile responsive layout bugs

## [1.0.0] - 2024-11-01

### Added
- Initial release
- Core functionality
- User management
- Data visualization
- API endpoints

[Unreleased]: https://github.com/username/project/compare/v1.2.0...HEAD
[1.2.0]: https://github.com/username/project/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/username/project/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/username/project/releases/tag/v1.0.0
```

### 예제 2: Conventional Commits 상세 분석

**분석 결과:**
```markdown
## [2.0.0] - 2025-02-01

### ⚠️ BREAKING CHANGES

- **api**: Changed authentication method from session to JWT
  - Migration guide: https://docs.example.com/migration/v2
  - API endpoints now require `Authorization: Bearer <token>` header

- **database**: Removed deprecated `users.username` column
  - Use `users.email` as unique identifier instead

### ✨ Features

- **auth**: Implement JWT authentication (#123)
  - Add token refresh mechanism
  - Add logout functionality
  - Add token expiration handling

- **ui**: Add dark mode support (#145)
  - System preference detection
  - Manual toggle option
  - Persistent user preference

- **api**: Add rate limiting middleware (#156)
  - 100 requests per 15 minutes per IP
  - Custom limits for authenticated users

### 🐛 Bug Fixes

- **auth**: Fix password reset token expiration (#167)
  - Tokens now expire after 1 hour
  - Send expiration time in email

- **ui**: Resolve mobile navigation menu issues (#178)
  - Fix hamburger menu animation
  - Improve touch responsiveness

### 📝 Documentation

- **api**: Update OpenAPI specification
- **readme**: Add migration guide for v2
- **contributing**: Update code review process

### ⚡ Performance

- **database**: Optimize user query with indexing
  - Added composite index on (email, status)
  - 60% faster user lookup

- **api**: Implement response caching
  - Redis cache for frequently accessed endpoints
  - Cache invalidation on data updates

### 🔒 Security

- **deps**: Update dependencies to patch vulnerabilities
  - express@4.18.2 → 4.19.0
  - jsonwebtoken@8.5.1 → 9.0.0

### 🔧 Internal

- **ci**: Add automated security scanning
- **deps**: Migrate from npm to pnpm
- **tests**: Increase coverage to 95%
```

### 예제 3: 릴리즈 노트 생성

**GitHub Release Notes:**
```markdown
## What's Changed in v1.3.0

### 🚀 New Features

* **Authentication**: JWT-based authentication system by @johndoe in #123
  - Improved security with token-based auth
  - Better support for mobile applications

* **UI**: Dark mode support by @janedoe in #145
  - Automatic theme switching based on system preferences
  - Manual override option

### 🐛 Bug Fixes

* **Auth**: Password reset token expiration fixed in #167
* **UI**: Mobile navigation menu improvements in #178

### 📊 Performance Improvements

* **Database**: 60% faster user queries through indexing
* **API**: Response caching reduces load times by 40%

### 🔒 Security Updates

* Updated vulnerable dependencies
* Implemented rate limiting on API endpoints

### 📝 Documentation

* Complete API documentation update
* Added migration guide for v2.0

### 👥 Contributors

A huge thank you to all our contributors!

@johndoe, @janedoe, @contributor1, @contributor2

**Full Changelog**: https://github.com/username/project/compare/v1.2.0...v1.3.0
```

### 예제 4: 버전 자동 증가

**package.json 업데이트:**
```bash
# 현재 버전: 1.2.0

# Patch 버전 증가 (버그 수정)
$ npm run changelog:patch
# 새 버전: 1.2.1

# Minor 버전 증가 (새 기능)
$ npm run changelog:minor
# 새 버전: 1.3.0

# Major 버전 증가 (Breaking changes)
$ npm run changelog:major
# 새 버전: 2.0.0
```

**package.json scripts:**
```json
{
  "scripts": {
    "changelog": "conventional-changelog -p angular -i CHANGELOG.md -s",
    "changelog:patch": "npm version patch && npm run changelog",
    "changelog:minor": "npm version minor && npm run changelog",
    "changelog:major": "npm version major && npm run changelog",
    "release": "npm run changelog && git push --follow-tags"
  }
}
```

### 예제 5: 커밋 메시지 검증

**.commitlintrc.json:**
```json
{
  "extends": ["@commitlint/config-conventional"],
  "rules": {
    "type-enum": [
      2,
      "always",
      [
        "feat",
        "fix",
        "docs",
        "style",
        "refactor",
        "perf",
        "test",
        "chore",
        "revert"
      ]
    ],
    "type-case": [2, "always", "lower-case"],
    "type-empty": [2, "never"],
    "subject-empty": [2, "never"],
    "subject-case": [2, "always", "sentence-case"],
    "header-max-length": [2, "always", 100]
  }
}
```

**Husky pre-commit hook:**
```bash
#!/bin/sh
# .husky/commit-msg

npx --no -- commitlint --edit "$1"
```

**올바른 커밋 메시지:**
```bash
✅ feat: add user authentication
✅ fix: resolve login redirect issue
✅ docs: update API documentation
✅ perf: optimize database queries
✅ feat!: migrate to JWT authentication (BREAKING CHANGE)

❌ Add user auth (타입 누락)
❌ FEAT: new feature (대문자 사용)
❌ feat (설명 누락)
```

### 예제 6: GitHub Actions 자동화

**.github/workflows/release.yml:**
```yaml
name: Release

on:
  push:
    branches:
      - main

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 20

      - name: Install dependencies
        run: npm ci

      - name: Generate changelog
        run: npm run changelog

      - name: Determine version bump
        id: version
        run: |
          if git log -1 --pretty=%B | grep -q "BREAKING CHANGE"; then
            echo "bump=major" >> $GITHUB_OUTPUT
          elif git log -1 --pretty=%B | grep -q "^feat"; then
            echo "bump=minor" >> $GITHUB_OUTPUT
          else
            echo "bump=patch" >> $GITHUB_OUTPUT
          fi

      - name: Bump version
        run: npm version ${{ steps.version.outputs.bump }} --no-git-tag-version

      - name: Update CHANGELOG
        run: npm run changelog

      - name: Commit changes
        run: |
          git config user.name "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"
          git add CHANGELOG.md package.json
          git commit -m "chore: release v$(node -p "require('./package.json').version")"
          git tag v$(node -p "require('./package.json').version")
          git push && git push --tags

      - name: Create GitHub Release
        uses: actions/create-release@v1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          tag_name: v${{ steps.version.outputs.version }}
          release_name: Release v${{ steps.version.outputs.version }}
          body_path: RELEASE_NOTES.md
```

## 설정

`.skillconfig.json`:
```json
{
  "changelogGenerator": {
    "format": "keep-a-changelog",
    "conventionalCommits": true,
    "includeAuthors": true,
    "includeLinks": true,
    "groupBy": "type",
    "versionBump": "auto",
    "commitTypes": {
      "feat": "Features",
      "fix": "Bug Fixes",
      "docs": "Documentation",
      "perf": "Performance",
      "refactor": "Refactoring",
      "test": "Tests",
      "chore": "Internal"
    }
  }
}
```

## 의존성

```json
{
  "conventional-changelog-cli": "^4.1.0",
  "@commitlint/cli": "^18.4.0",
  "@commitlint/config-conventional": "^18.4.0",
  "husky": "^8.0.0"
}
```

## 라이선스

MIT License - 조직 내부 사용 전용
