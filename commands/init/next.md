---
description: Initialize Next.js project with setup guide
argument-hint: [project-name]
allowed-tools: Bash, Read, Write, Grep, Glob
model: claude-sonnet-4-5-20250929
---

# Next.js Project Initialization

## Usage

```bash
# Create new project
/init:next MyApp

# Setup existing project
/init:next
```

## What it does

1. **With project name**: Creates new Next.js project with `npx create-next-app@latest`
2. **Without name**: Analyzes existing Next.js project
3. Generates `claude.md` setup guide
4. User says "실행해" or "run it" to execute setup
5. Auto-setup completes and replaces claude.md with documentation

---

## Implementation

```bash
#!/bin/bash

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

PROJECT_NAME="${ARGUMENTS}"

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}🚀 Next.js Project Initialization${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo

# Step 1: Create project or use existing
if [ -n "$PROJECT_NAME" ]; then
  echo -e "${CYAN}📦 Creating new Next.js project: ${PROJECT_NAME}${NC}"
  npx create-next-app@latest "$PROJECT_NAME"

  if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Failed to create Next.js project${NC}"
    exit 1
  fi

  cd "$PROJECT_NAME" || exit 1
  echo -e "${GREEN}✓${NC} Project created"
  echo
else
  PROJECT_NAME=$(basename "$PWD")
  echo -e "${CYAN}📦 Using existing project: ${PROJECT_NAME}${NC}"

  # Validate it's a Next.js project
  if [ ! -f "package.json" ] || ! grep -q '"next"' package.json && [ ! -f "next.config.js" ] && [ ! -f "next.config.mjs" ]; then
    echo -e "${RED}❌ Not a Next.js project${NC}"
    echo -e "${YELLOW}💡 Run with project name to create new: /init:next MyApp${NC}"
    exit 1
  fi

  echo -e "${GREEN}✓${NC} Next.js project detected"
  echo
fi

# Step 2: Analyze project
echo -e "${CYAN}📊 Analyzing project...${NC}"

NEXTJS_VERSION=$(grep -oP '"next":\s*"[\^~]?\K[^"]+' package.json 2>/dev/null || echo "latest")
TYPESCRIPT="Yes"
if [ ! -f "tsconfig.json" ]; then
  TYPESCRIPT="No"
fi

APP_ROUTER="Yes"
if [ -d "app" ]; then
  APP_ROUTER="Yes (app directory)"
elif [ -d "pages" ]; then
  APP_ROUTER="No (pages directory)"
fi

UI_LIBRARY="None"
if grep -q '"tailwindcss"' package.json 2>/dev/null; then
  UI_LIBRARY="Tailwind CSS"
fi

echo -e "${GREEN}✓${NC} Next.js: ${NEXTJS_VERSION}"
echo -e "${GREEN}✓${NC} TypeScript: ${TYPESCRIPT}"
echo -e "${GREEN}✓${NC} App Router: ${APP_ROUTER}"
echo -e "${GREEN}✓${NC} UI Library: ${UI_LIBRARY}"
echo

# Step 3: Generate claude.md from template
echo -e "${CYAN}📝 Generating setup guide...${NC}"

TEMPLATE="$HOME/.claude/templates/claude-config/next-setup-guide.md"

if [ ! -f "$TEMPLATE" ]; then
  echo -e "${RED}❌ Template not found: $TEMPLATE${NC}"
  exit 1
fi

# Simple template variable replacement
sed -e "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
    -e "s/{{NEXTJS_VERSION}}/$NEXTJS_VERSION/g" \
    -e "s/{{TYPESCRIPT}}/$TYPESCRIPT/g" \
    -e "s/{{APP_ROUTER}}/$APP_ROUTER/g" \
    -e "s/{{UI_LIBRARY}}/$UI_LIBRARY/g" \
    -e "s/{{CORE_DEPS}}//g" \
    -e "s/{{DEV_DEPS}}//g" \
    "$TEMPLATE" > claude.md

echo -e "${GREEN}✓${NC} claude.md created"
echo

# Step 4: Done
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ Setup guide created!${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo
echo -e "${YELLOW}📄 Next step:${NC}"
echo -e "   Just say one of these to start setup:"
echo -e "   • ${CYAN}실행해${NC} / ${CYAN}설정해${NC} / ${CYAN}셋업해${NC}"
echo -e "   • ${CYAN}run it${NC} / ${CYAN}execute${NC} / ${CYAN}start${NC}"
echo
echo -e "${YELLOW}💡 What happens:${NC}"
echo -e "   1. Tailwind CSS installed"
echo -e "   2. Atomic Design folders created"
echo -e "   3. Pretendard fonts downloaded"
echo -e "   4. Config files generated"
echo -e "   5. claude.md replaced with documentation"
echo
```
