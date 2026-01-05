---
name: ci-cd-setup
description: Automatically configure CI/CD pipelines for GitHub Actions, GitLab CI, or Jenkins
version: 1.3.0
author: DevOps Team <devops@company.com>
category: devops
tags: [ci-cd, github-actions, gitlab-ci, jenkins, automation, deployment]
status: stable
allowed-tools: [Write, Read, Bash]
triggers:
  - "CI/CD 설정"
  - "파이프라인 구성"
  - "setup ci cd"
  - "configure pipeline"
  - "github actions setup"
dependencies: []
---

# CI/CD Setup

## 목적

GitHub Actions, GitLab CI, Jenkins를 위한 CI/CD 파이프라인을 자동으로 구성합니다.

## 사용 시기

### ✅ 이 스킬을 사용할 때

- 새 프로젝트의 CI/CD 파이프라인 설정
- 기존 파이프라인 현대화 및 최적화
- 멀티 환경 배포 자동화 (dev, staging, production)

### ❌ 이 스킬을 사용하지 않을 때

- 복잡한 커스텀 배포 로직 (수동 작성 권장)
- 레거시 CI 시스템 (Travis CI, CircleCI 등)

## 작동 방식

1. **프로젝트 분석**: 언어, 프레임워크, 테스트 도구 감지
2. **파이프라인 생성**: 플랫폼별 최적화된 워크플로우 생성
3. **환경 구성**: 시크릿, 변수, 배포 타겟 설정
4. **검증**: 파이프라인 문법 및 보안 검사

## 예제

### 예제 1: GitHub Actions - Node.js 프로젝트

**생성되는 워크플로우:**
```yaml
# .github/workflows/ci.yml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: [18.x, 20.x]

    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js ${{ matrix.node-version }}
        uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Run linter
        run: npm run lint

      - name: Run tests
        run: npm test -- --coverage

      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          files: ./coverage/lcov.info

  build:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'

    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 20.x
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Build
        run: npm run build

      - name: Upload build artifacts
        uses: actions/upload-artifact@v3
        with:
          name: build
          path: dist/

  deploy:
    needs: build
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    environment: production

    steps:
      - name: Download build artifacts
        uses: actions/download-artifact@v3
        with:
          name: build
          path: dist/

      - name: Deploy to production
        run: |
          echo "Deploying to production..."
          # Your deployment script here
        env:
          DEPLOY_KEY: ${{ secrets.DEPLOY_KEY }}
```

### 예제 2: GitLab CI - Python 프로젝트

```yaml
# .gitlab-ci.yml
stages:
  - test
  - build
  - deploy

variables:
  PIP_CACHE_DIR: "$CI_PROJECT_DIR/.cache/pip"

cache:
  paths:
    - .cache/pip
    - venv/

before_script:
  - python -m venv venv
  - source venv/bin/activate
  - pip install -r requirements.txt

test:
  stage: test
  script:
    - pytest --cov=app tests/
    - coverage report
    - coverage xml
  coverage: '/(?i)total.*? (100(?:\.0+)?\%|[1-9]?\d(?:\.\d+)?\%)$/'
  artifacts:
    reports:
      coverage_report:
        coverage_format: cobertura
        path: coverage.xml

lint:
  stage: test
  script:
    - flake8 app/
    - black --check app/
    - mypy app/

build:
  stage: build
  script:
    - python setup.py bdist_wheel
  artifacts:
    paths:
      - dist/*.whl
    expire_in: 1 week
  only:
    - main

deploy_staging:
  stage: deploy
  script:
    - echo "Deploying to staging..."
    - pip install dist/*.whl
    - python -m app.deploy --env staging
  environment:
    name: staging
    url: https://staging.example.com
  only:
    - develop

deploy_production:
  stage: deploy
  script:
    - echo "Deploying to production..."
    - pip install dist/*.whl
    - python -m app.deploy --env production
  environment:
    name: production
    url: https://example.com
  when: manual
  only:
    - main
```

### 예제 3: Multi-Environment 배포

```yaml
# .github/workflows/deploy.yml
name: Multi-Environment Deployment

on:
  push:
    branches: [main, staging, develop]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Set environment
        id: env
        run: |
          if [[ "${{ github.ref }}" == "refs/heads/main" ]]; then
            echo "env_name=production" >> $GITHUB_OUTPUT
            echo "env_url=https://example.com" >> $GITHUB_OUTPUT
          elif [[ "${{ github.ref }}" == "refs/heads/staging" ]]; then
            echo "env_name=staging" >> $GITHUB_OUTPUT
            echo "env_url=https://staging.example.com" >> $GITHUB_OUTPUT
          else
            echo "env_name=development" >> $GITHUB_OUTPUT
            echo "env_url=https://dev.example.com" >> $GITHUB_OUTPUT
          fi

      - name: Deploy to ${{ steps.env.outputs.env_name }}
        run: |
          echo "Deploying to ${{ steps.env.outputs.env_name }}"
          ./scripts/deploy.sh ${{ steps.env.outputs.env_name }}
        env:
          DEPLOY_TOKEN: ${{ secrets[format('{0}_DEPLOY_TOKEN', steps.env.outputs.env_name)] }}

      - name: Notify deployment
        if: success()
        run: |
          curl -X POST ${{ secrets.SLACK_WEBHOOK }} \
            -H 'Content-Type: application/json' \
            -d '{
              "text": "✅ Deployed to ${{ steps.env.outputs.env_name }}",
              "blocks": [{
                "type": "section",
                "text": {
                  "type": "mrkdwn",
                  "text": "🚀 *Deployment Successful*\n*Environment:* ${{ steps.env.outputs.env_name }}\n*URL:* ${{ steps.env.outputs.env_url }}\n*Commit:* `${{ github.sha }}`"
                }
              }]
            }'
```

## 설정

`.skillconfig.json`:
```json
{
  "ciCdSetup": {
    "platform": "github-actions",
    "language": "auto-detect",
    "environments": ["development", "staging", "production"],
    "features": {
      "caching": true,
      "parallelization": true,
      "notifications": true,
      "securityScanning": true
    },
    "deploymentStrategy": "manual-approval-production"
  }
}
```

## 의존성

```json
{
  "github-actions": "latest",
  "gitlab-ci": "latest",
  "jenkins": "^2.0.0"
}
```

## 라이선스

MIT License - 조직 내부 사용 전용
