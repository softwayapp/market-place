---
description: Initialize React project with auto library setup and CLAUDE.md
argument-hint: [project-name]
allowed-tools: Bash, Read, Write, Grep, Glob
model: claude-sonnet-4-5-20250929
---

# React Project Initialization

## Usage

```bash
# Create new project
/init:react MyApp

# Setup existing project
/init:react
```

## What it does

1. **With project name**: Creates new React project with `npm create vite@latest`
2. **Without name**: Analyzes existing React project
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
echo -e "${CYAN}🚀 React Project Initialization${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo

# Step 1: Create project or use existing
if [ -n "$PROJECT_NAME" ]; then
  echo -e "${CYAN}📦 Creating new React project: ${PROJECT_NAME}${NC}"
  npm create vite@latest "$PROJECT_NAME" -- --template react-ts

  if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Failed to create React project${NC}"
    exit 1
  fi

  cd "$PROJECT_NAME" || exit 1
  echo -e "${GREEN}✓${NC} Project created"
  echo
else
  PROJECT_NAME=$(basename "$PWD")
  echo -e "${CYAN}📦 Using existing project: ${PROJECT_NAME}${NC}"

  # Validate it's a React project
  if [ ! -f "package.json" ] || ! grep -q '"react"' package.json; then
    echo -e "${RED}❌ Not a React project${NC}"
    echo -e "${YELLOW}💡 Run with project name to create new: /init:react MyApp${NC}"
    exit 1
  fi

  echo -e "${GREEN}✓${NC} React project detected"
  echo
fi

# Step 2: Analyze project
echo -e "${CYAN}📊 Analyzing project...${NC}"

REACT_VERSION=$(grep -oP '"react":\s*"[\^~]?\K[^"]+' package.json 2>/dev/null || echo "latest")
TYPESCRIPT="Yes"
if [ ! -f "tsconfig.json" ]; then
  TYPESCRIPT="No"
fi

BUILD_TOOL="Unknown"
if grep -q '"vite"' package.json 2>/dev/null; then
  BUILD_TOOL="Vite"
elif grep -q '"react-scripts"' package.json 2>/dev/null; then
  BUILD_TOOL="Create React App"
elif grep -q '"webpack"' package.json 2>/dev/null; then
  BUILD_TOOL="Webpack"
fi

UI_LIBRARY="None"
if grep -q '"tailwindcss"' package.json 2>/dev/null; then
  UI_LIBRARY="Tailwind CSS"
fi
if grep -q '"shadcn"' package.json 2>/dev/null || [ -d "components/ui" ]; then
  UI_LIBRARY="${UI_LIBRARY}, shadcn/ui"
fi

ROUTER="Not detected"
if grep -q '"react-router-dom"' package.json 2>/dev/null; then
  ROUTER="React Router"
fi

echo -e "${GREEN}✓${NC} React: ${REACT_VERSION}"
echo -e "${GREEN}✓${NC} TypeScript: ${TYPESCRIPT}"
echo -e "${GREEN}✓${NC} Build Tool: ${BUILD_TOOL}"
echo -e "${GREEN}✓${NC} UI Library: ${UI_LIBRARY}"
echo -e "${GREEN}✓${NC} Router: ${ROUTER}"
echo

# Step 3: Generate claude.md from template
echo -e "${CYAN}📝 Generating setup guide...${NC}"

TEMPLATE="$HOME/.claude/templates/claude-config/react-setup-guide.md"

if [ ! -f "$TEMPLATE" ]; then
  echo -e "${RED}❌ Template not found: $TEMPLATE${NC}"
  exit 1
fi

# Simple template variable replacement
sed -e "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
    -e "s/{{REACT_VERSION}}/$REACT_VERSION/g" \
    -e "s/{{TYPESCRIPT}}/$TYPESCRIPT/g" \
    -e "s/{{BUILD_TOOL}}/$BUILD_TOOL/g" \
    -e "s/{{UI_LIBRARY}}/$UI_LIBRARY/g" \
    -e "s/{{ROUTER}}/$ROUTER/g" \
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
echo -e "   1. Essential libraries installed (TanStack Query, Zustand, etc.)"
echo -e "   2. Tailwind CSS configured (if not present)"
echo -e "   3. Pretendard fonts downloaded"
echo -e "   4. Project structure created"
echo -e "   5. claude.md replaced with comprehensive documentation"
echo
```
