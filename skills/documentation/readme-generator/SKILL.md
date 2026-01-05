---
name: readme-generator
description: Generate comprehensive README.md with badges, installation, usage, and examples
version: 1.3.0
author: Documentation Team <docs@company.com>
category: documentation
tags: [readme, markdown, documentation, github, getting-started]
status: stable
allowed-tools: [Read, Write, Grep, Bash]
triggers:
  - "README 생성"
  - "문서 생성"
  - "generate readme"
  - "create readme"
  - "documentation"
dependencies: []
---

# README Generator

## 목적

프로젝트 구조와 코드를 분석하여 포괄적인 README.md 파일을 자동 생성합니다.

## 사용 시기

### ✅ 이 스킬을 사용할 때

- 새 프로젝트의 README 초기 작성
- 기존 README 업데이트 및 개선
- 일관된 문서 구조 유지

### ❌ 이 스킬을 사용하지 않을 때

- 매우 특수한 프로젝트 (수동 작성 권장)
- 단순 개인 프로젝트

## 작동 방식

1. **프로젝트 분석**: package.json, 디렉토리 구조, 코드 스캔
2. **정보 추출**: 의존성, 스크립트, 주요 기능 파악
3. **템플릿 적용**: 표준화된 섹션 구조 생성
4. **내용 생성**: 설치, 사용법, 예제 자동 작성

## 예제

### 예제 1: Node.js 프로젝트 README

**생성되는 README.md:**
```markdown
# My Awesome Project

[![npm version](https://badge.fury.io/js/my-awesome-project.svg)](https://badge.fury.io/js/my-awesome-project)
[![Build Status](https://github.com/username/my-awesome-project/workflows/CI/badge.svg)](https://github.com/username/my-awesome-project/actions)
[![Coverage Status](https://coveralls.io/repos/github/username/my-awesome-project/badge.svg?branch=main)](https://coveralls.io/github/username/my-awesome-project?branch=main)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

> A comprehensive Node.js application with Express and TypeScript

## ✨ Features

- 🚀 Fast and lightweight
- 📦 TypeScript support
- 🔒 Secure authentication
- 📊 Database integration with PostgreSQL
- 🧪 100% test coverage
- 📝 Comprehensive API documentation

## 📋 Prerequisites

- Node.js >= 18.x
- npm >= 9.x
- PostgreSQL >= 14.x

## 🚀 Quick Start

### Installation

\`\`\`bash
# Clone the repository
git clone https://github.com/username/my-awesome-project.git

# Navigate to project directory
cd my-awesome-project

# Install dependencies
npm install

# Copy environment variables
cp .env.example .env

# Run database migrations
npm run migrate

# Start development server
npm run dev
\`\`\`

The application will be available at http://localhost:3000

### Using npm

\`\`\`bash
npm install my-awesome-project
\`\`\`

## 📖 Usage

### Basic Example

\`\`\`javascript
const { createApp } = require('my-awesome-project');

const app = createApp({
  port: 3000,
  database: {
    host: 'localhost',
    port: 5432,
    database: 'mydb',
  },
});

app.start();
\`\`\`

### With TypeScript

\`\`\`typescript
import { createApp, AppConfig } from 'my-awesome-project';

const config: AppConfig = {
  port: 3000,
  database: {
    host: 'localhost',
    port: 5432,
    database: 'mydb',
  },
};

const app = createApp(config);
app.start();
\`\`\`

### Authentication Example

\`\`\`javascript
const { auth } = require('my-awesome-project');

app.post('/login', async (req, res) => {
  const { email, password } = req.body;
  const token = await auth.login(email, password);
  res.json({ token });
});
\`\`\`

## 🏗️ Project Structure

\`\`\`
my-awesome-project/
├── src/
│   ├── controllers/    # Request handlers
│   ├── models/         # Database models
│   ├── routes/         # API routes
│   ├── services/       # Business logic
│   ├── middleware/     # Custom middleware
│   └── utils/          # Utility functions
├── tests/              # Test files
├── docs/               # Documentation
├── .env.example        # Environment variables template
├── package.json
└── tsconfig.json
\`\`\`

## 🔧 Configuration

Create a \`.env\` file in the root directory:

\`\`\`env
# Server
PORT=3000
NODE_ENV=development

# Database
DB_HOST=localhost
DB_PORT=5432
DB_NAME=mydb
DB_USER=postgres
DB_PASSWORD=password

# JWT
JWT_SECRET=your-secret-key
JWT_EXPIRES_IN=7d

# External APIs
API_KEY=your-api-key
\`\`\`

## 📝 API Documentation

API documentation is available at http://localhost:3000/api-docs when running the server.

### Endpoints

#### Authentication

- \`POST /api/auth/login\` - User login
- \`POST /api/auth/register\` - User registration
- \`POST /api/auth/logout\` - User logout

#### Users

- \`GET /api/users\` - Get all users
- \`GET /api/users/:id\` - Get user by ID
- \`POST /api/users\` - Create new user
- \`PUT /api/users/:id\` - Update user
- \`DELETE /api/users/:id\` - Delete user

## 🧪 Testing

\`\`\`bash
# Run all tests
npm test

# Run tests with coverage
npm run test:coverage

# Run tests in watch mode
npm run test:watch

# Run E2E tests
npm run test:e2e
\`\`\`

## 📦 Building

\`\`\`bash
# Build for production
npm run build

# Start production server
npm start
\`\`\`

## 🚢 Deployment

### Docker

\`\`\`bash
# Build Docker image
docker build -t my-awesome-project .

# Run container
docker run -p 3000:3000 my-awesome-project
\`\`\`

### Docker Compose

\`\`\`bash
docker-compose up -d
\`\`\`

### Kubernetes

\`\`\`bash
kubectl apply -f k8s/
\`\`\`

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) for details.

1. Fork the repository
2. Create your feature branch (\`git checkout -b feature/amazing-feature\`)
3. Commit your changes (\`git commit -m 'Add some amazing feature'\`)
4. Push to the branch (\`git push origin feature/amazing-feature\`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Authors

- **John Doe** - *Initial work* - [@johndoe](https://github.com/johndoe)

See also the list of [contributors](https://github.com/username/my-awesome-project/contributors).

## 🙏 Acknowledgments

- Hat tip to anyone whose code was used
- Inspiration
- etc

## 📞 Support

- Documentation: https://docs.example.com
- Issues: https://github.com/username/my-awesome-project/issues
- Email: support@example.com

## 🗺️ Roadmap

- [ ] Add GraphQL support
- [ ] Implement caching layer
- [ ] Add WebSocket support
- [ ] Improve test coverage
- [ ] Add internationalization

## ⭐ Show your support

Give a ⭐️ if this project helped you!
\`\`\`

### 예제 2: React 라이브러리 README

**생성되는 README.md:**
```markdown
# React Components Library

[![npm version](https://badge.fury.io/js/%40company%2Fcomponents.svg)](https://www.npmjs.com/package/@company/components)
[![Bundle Size](https://img.shields.io/bundlephobia/minzip/@company/components)](https://bundlephobia.com/package/@company/components)
[![Downloads](https://img.shields.io/npm/dm/@company/components.svg)](https://www.npmjs.com/package/@company/components)

> Modern, accessible React components built with TypeScript and Tailwind CSS

## ✨ Features

- 🎨 Beautiful, customizable components
- ♿ WCAG 2.1 Level AA compliant
- 📱 Fully responsive
- 🌙 Dark mode support
- ⚡ Tree-shakeable
- 📦 TypeScript support
- 🎭 Storybook documentation

## 📦 Installation

\`\`\`bash
npm install @company/components
\`\`\`

\`\`\`bash
yarn add @company/components
\`\`\`

## 🚀 Usage

### Import Components

\`\`\`tsx
import { Button, Input, Modal } from '@company/components';
import '@company/components/dist/styles.css';

function App() {
  return (
    <div>
      <Button variant="primary">Click me</Button>
      <Input placeholder="Enter text..." />
    </div>
  );
}
\`\`\`

### Component Examples

#### Button

\`\`\`tsx
import { Button } from '@company/components';

<Button variant="primary" size="large">
  Primary Button
</Button>

<Button variant="secondary" disabled>
  Disabled Button
</Button>

<Button variant="outline" onClick={() => console.log('Clicked!')}>
  Outline Button
</Button>
\`\`\`

#### Form Components

\`\`\`tsx
import { Input, Select, Checkbox } from '@company/components';

<Input
  label="Email"
  type="email"
  placeholder="you@example.com"
  error="Invalid email"
/>

<Select
  label="Country"
  options={[
    { value: 'us', label: 'United States' },
    { value: 'uk', label: 'United Kingdom' },
  ]}
/>

<Checkbox label="Accept terms and conditions" />
\`\`\`

## 📚 Documentation

Full documentation and interactive examples are available at [https://components.example.com](https://components.example.com)

## 🎨 Theming

Customize the theme by overriding CSS variables:

\`\`\`css
:root {
  --primary-color: #007bff;
  --secondary-color: #6c757d;
  --border-radius: 4px;
  --font-family: 'Inter', sans-serif;
}
\`\`\`

## 🧪 Development

\`\`\`bash
# Install dependencies
npm install

# Start Storybook
npm run storybook

# Run tests
npm test

# Build library
npm run build
\`\`\`

## 📄 License

MIT © Company Name
\`\`\`

### 예제 3: Python 프로젝트 README

**생성되는 README.md:**
```markdown
# Python Data Pipeline

[![PyPI version](https://badge.fury.io/py/data-pipeline.svg)](https://pypi.org/project/data-pipeline/)
[![Python Versions](https://img.shields.io/pypi/pyversions/data-pipeline.svg)](https://pypi.org/project/data-pipeline/)
[![CI](https://github.com/username/data-pipeline/workflows/CI/badge.svg)](https://github.com/username/data-pipeline/actions)
[![codecov](https://codecov.io/gh/username/data-pipeline/branch/main/graph/badge.svg)](https://codecov.io/gh/username/data-pipeline)

> A robust data pipeline for ETL operations

## 🚀 Installation

\`\`\`bash
pip install data-pipeline
\`\`\`

## 📖 Quick Start

\`\`\`python
from data_pipeline import Pipeline, Extract, Transform, Load

# Create pipeline
pipeline = Pipeline()

# Add stages
pipeline.add(Extract(source='database'))
pipeline.add(Transform(operations=['clean', 'normalize']))
pipeline.add(Load(destination='warehouse'))

# Run pipeline
pipeline.run()
\`\`\`

## 🔧 Configuration

\`\`\`yaml
# config.yaml
source:
  type: postgresql
  host: localhost
  port: 5432
  database: mydb

transformations:
  - type: clean
  - type: normalize
  - type: aggregate

destination:
  type: s3
  bucket: my-data-warehouse
\`\`\`

## 🧪 Testing

\`\`\`bash
# Run tests
pytest

# With coverage
pytest --cov=data_pipeline

# Specific test file
pytest tests/test_pipeline.py
\`\`\`

## 📄 License

MIT License
\`\`\`

## 설정

`.skillconfig.json`:
```json
{
  "readmeGenerator": {
    "template": "standard",
    "includeBadges": true,
    "includeTableOfContents": true,
    "sections": [
      "features",
      "installation",
      "usage",
      "api",
      "testing",
      "deployment",
      "contributing",
      "license"
    ],
    "badgeStyle": "flat-square"
  }
}
```

## 의존성

```json
{
  "marked": "^11.0.0",
  "gray-matter": "^4.0.3"
}
```

## 라이선스

MIT License - 조직 내부 사용 전용
