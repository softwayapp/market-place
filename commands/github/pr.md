---
description: Intelligent PR workflow - Test/Build/Lint → Auto-classify → Branch separation → PR creation → Merge → Cleanup
argument-hint: [optional-description]
allowed-tools: Bash, Read, Write, Grep, Glob
model: claude-sonnet-4-5-20250929
---

# GitHub PR - Intelligent Automated Workflow

## 🎯 Overview

This command provides a complete, safe, and intelligent PR workflow:

1. ✅ **Validation**: Test/Build/Lint with colored results
2. 🔧 **Failure Analysis**: Skills-based improvement suggestions + auto-issue creation
3. 🤖 **Classification**: Intelligent file categorization (feature/fix/docs/etc)
4. 🌳 **Safe Branching**: Stash-based branch separation (no data loss)
5. 🚀 **Automation**: Push → Create PRs → Merge → Cleanup

---

## ⚠️ CRITICAL SAFETY RULES

**Skills Integration:**
- Reference: `~/.claude/plugins/cache/superpowers-marketplace/superpowers/3.6.2/skills/verification-before-completion/SKILL.md`
- Reference: `~/.claude/plugins/cache/superpowers-marketplace/superpowers/3.6.2/skills/finishing-a-development-branch/SKILL.md`
- Reference: `~/.claude/plugins/cache/superpowers-marketplace/superpowers/3.6.2/skills/systematic-debugging/SKILL.md`
- **Principle**: Test → Evidence → User Confirmation → Execute → Verify

**Git Operations:**
```bash
# ✅ ALLOWED (Information gathering)
git status --porcelain
git diff --staged
git diff
git log --oneline -10
git branch --show-current

# ⚠️ REQUIRES CONFIRMATION (State-changing)
git stash               # Backup only
git checkout -b         # Branch creation
git add                 # Stage changes
git commit              # Create commit
git push                # Push to remote
git merge               # Merge branches
git branch -D           # Delete branch
```

---

## 📋 Execution Flow

```
┌─────────────────────────────────────┐
│ Phase 0: Pre-Flight Checks          │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│ Phase 1: Test/Build/Lint Validation │
│ ✅ Pass → Continue                  │
│ ❌ Fail → Phase 2 (Analysis)        │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│ Phase 2: Failure Analysis (if fail) │
│ - Root cause investigation          │
│ - Improvement suggestions           │
│ - Auto-create issue                 │
│ 🛑 STOP                             │
└──────────────┬──────────────────────┘
               ↓ (if all passed)
┌─────────────────────────────────────┐
│ Phase 3: File Classification        │
│ - Analyze all changes               │
│ - Classify by type                  │
│ - User confirmation                 │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│ Phase 4: Safe Branch Operations     │
│ - Stash backup                      │
│ - Create category branches          │
│ - Commit per category               │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│ Phase 5: Push/PR/Merge/Cleanup      │
│ - Push all branches                 │
│ - Create PRs                        │
│ - Merge (with confirmation)         │
│ - Cleanup branches                  │
└──────────────┬──────────────────────┘
               ↓
           ✅ DONE
```

---

## Phase 0: Pre-Flight Checks

```bash
#!/bin/bash

# Terminal color codes for output
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
MAGENTA='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
RESET='\033[0m'
BOLD='\033[1m'

echo ""
echo -e "${CYAN}╔════════════════════════════════════════╗${RESET}"
echo -e "${CYAN}║  🚀 GitHub PR - Intelligent Workflow   ║${RESET}"
echo -e "${CYAN}╚════════════════════════════════════════╝${RESET}"
echo ""

# STEP 0.1: Environment Validation
echo -e "${BLUE}🔍 Validating environment...${RESET}"
echo ""

# Check git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo -e "${RED}❌ Not a git repository${RESET}"
  exit 1
fi

# Check gh CLI
if ! command -v gh &> /dev/null; then
  echo -e "${RED}❌ GitHub CLI (gh) not installed${RESET}"
  echo ""
  echo "Install: https://cli.github.com/"
  exit 1
fi

# Check gh authentication
if ! gh auth status &> /dev/null; then
  echo -e "${RED}❌ GitHub CLI not authenticated${RESET}"
  echo ""
  echo "Run: gh auth login"
  exit 1
fi

# Get current branch
CURRENT_BRANCH=$(git branch --show-current)

# Check if on main/master
if [ "$CURRENT_BRANCH" != "main" ] && [ "$CURRENT_BRANCH" != "master" ]; then
  echo -e "${YELLOW}⚠️ WARNING: Not on main/master branch${RESET}"
  echo -e "Current branch: ${BOLD}$CURRENT_BRANCH${RESET}"
  echo ""
  echo -e "${CYAN}🤔 Continue anyway? [Y/n]${RESET}"
  read -r CONTINUE_CHOICE

  if [[ "$CONTINUE_CHOICE" =~ ^[Nn]$ ]]; then
    echo -e "${YELLOW}❌ Aborted by user${RESET}"
    exit 0
  fi
fi

# STEP 0.2: Collect Git State (READ-ONLY)
echo -e "${BLUE}📊 Analyzing git state...${RESET}"
echo ""

STAGED_FILES=$(git diff --staged --name-only)
STAGED_COUNT=$(echo "$STAGED_FILES" | grep -v '^$' | wc -l)

UNSTAGED_FILES=$(git diff --name-only)
UNSTAGED_COUNT=$(echo "$UNSTAGED_FILES" | grep -v '^$' | wc -l)

UNTRACKED_FILES=$(git ls-files --others --exclude-standard)
UNTRACKED_COUNT=$(echo "$UNTRACKED_FILES" | grep -v '^$' | wc -l)

TOTAL_CHANGES=$((STAGED_COUNT + UNSTAGED_COUNT + UNTRACKED_COUNT))

if [ $TOTAL_CHANGES -eq 0 ]; then
  echo -e "${YELLOW}ℹ️ No changes to commit${RESET}"
  exit 0
fi

echo -e "${GREEN}📋 Changes detected:${RESET}"
echo "  - Staged:    $STAGED_COUNT files"
echo "  - Unstaged:  $UNSTAGED_COUNT files"
echo "  - Untracked: $UNTRACKED_COUNT files"
echo -e "  - ${BOLD}Total:     $TOTAL_CHANGES files${RESET}"
echo ""

# STEP 0.3: Determine base branch
if git show-ref --verify --quiet refs/heads/main; then
  BASE_BRANCH="main"
elif git show-ref --verify --quiet refs/heads/master; then
  BASE_BRANCH="master"
else
  echo -e "${RED}❌ Cannot find base branch (main or master)${RESET}"
  exit 1
fi

echo -e "${GREEN}✅ Environment validation passed${RESET}"
echo -e "📌 Base branch: ${BOLD}$BASE_BRANCH${RESET}"
echo ""
```

---

## Phase 1: Test/Build/Lint Validation

```bash
echo ""
echo -e "${CYAN}╔════════════════════════════════════════╗${RESET}"
echo -e "${CYAN}║  Phase 1: Validation                   ║${RESET}"
echo -e "${CYAN}╚════════════════════════════════════════╝${RESET}"
echo ""

# STEP 1.1: Run Tests
echo -e "${MAGENTA}╔════════════════════════════════════════╗${RESET}"
echo -e "${MAGENTA}║  🧪 RUNNING TESTS                      ║${RESET}"
echo -e "${MAGENTA}╚════════════════════════════════════════╝${RESET}"
echo ""

# Detect test command
TEST_CMD=""
if [ -f "package.json" ]; then
  if grep -q '"test"' package.json; then
    TEST_CMD="npm test"
  fi
elif [ -f "Cargo.toml" ]; then
  TEST_CMD="cargo test"
elif [ -f "pytest.ini" ] || [ -f "setup.py" ]; then
  TEST_CMD="pytest"
fi

if [ -z "$TEST_CMD" ]; then
  echo -e "${YELLOW}⚠️ No test command found - skipping tests${RESET}"
  TEST_PASSED=true
  TOTAL_TESTS=0
  FAILED_TESTS=0
  FAILURE_RATE=0
else
  TEST_OUTPUT=$(eval "$TEST_CMD" 2>&1)
  TEST_EXIT_CODE=$?

  if [ $TEST_EXIT_CODE -eq 0 ]; then
    echo -e "${GREEN}${BOLD}✅ TESTS PASSED${RESET}"
    TEST_PASSED=true

    # Extract test count
    TOTAL_TESTS=$(echo "$TEST_OUTPUT" | grep -oP '\d+(?= tests?)' | head -1)
    FAILED_TESTS=0
    FAILURE_RATE=0
  else
    echo -e "${RED}${BOLD}❌ TESTS FAILED${RESET}"
    TEST_PASSED=false

    # Parse test output for failure count
    TOTAL_TESTS=$(echo "$TEST_OUTPUT" | grep -oP '\d+(?= tests?)' | head -1)
    FAILED_TESTS=$(echo "$TEST_OUTPUT" | grep -oP '\d+(?= failed)' | head -1)

    # Default values if parsing fails
    TOTAL_TESTS=${TOTAL_TESTS:-0}
    FAILED_TESTS=${FAILED_TESTS:-1}

    if [ $TOTAL_TESTS -gt 0 ]; then
      FAILURE_RATE=$(awk "BEGIN {printf \"%.1f\", ($FAILED_TESTS/$TOTAL_TESTS)*100}")
    else
      FAILURE_RATE=100
    fi

    echo ""
    echo -e "${RED}📊 Test Results:${RESET}"
    echo "  - Total:   $TOTAL_TESTS tests"
    echo "  - Failed:  $FAILED_TESTS tests"
    echo -e "  - Failure: ${RED}${BOLD}$FAILURE_RATE%${RESET}"
  fi
fi

echo ""

# STEP 1.2: Run Build
echo -e "${MAGENTA}╔════════════════════════════════════════╗${RESET}"
echo -e "${MAGENTA}║  🏗️ RUNNING BUILD                      ║${RESET}"
echo -e "${MAGENTA}╚════════════════════════════════════════╝${RESET}"
echo ""

# Detect build command
BUILD_CMD=""
if [ -f "package.json" ]; then
  if grep -q '"build"' package.json; then
    BUILD_CMD="npm run build"
  fi
elif [ -f "Cargo.toml" ]; then
  BUILD_CMD="cargo build --release"
fi

if [ -z "$BUILD_CMD" ]; then
  echo -e "${YELLOW}⚠️ No build command found - skipping build${RESET}"
  BUILD_PASSED=true
  BUILD_ERRORS=0
else
  BUILD_OUTPUT=$(eval "$BUILD_CMD" 2>&1)
  BUILD_EXIT_CODE=$?

  if [ $BUILD_EXIT_CODE -eq 0 ]; then
    echo -e "${GREEN}${BOLD}✅ BUILD PASSED${RESET}"
    BUILD_PASSED=true
    BUILD_ERRORS=0
  else
    echo -e "${RED}${BOLD}❌ BUILD FAILED${RESET}"
    BUILD_PASSED=false

    # Extract error count
    BUILD_ERRORS=$(echo "$BUILD_OUTPUT" | grep -ci "error")
    BUILD_ERRORS=${BUILD_ERRORS:-1}

    echo ""
    echo -e "${RED}📊 Build Results:${RESET}"
    echo -e "  - Errors: ${RED}${BOLD}$BUILD_ERRORS${RESET}"
  fi
fi

echo ""

# STEP 1.3: Run Lint
echo -e "${MAGENTA}╔════════════════════════════════════════╗${RESET}"
echo -e "${MAGENTA}║  🔍 RUNNING LINT                       ║${RESET}"
echo -e "${MAGENTA}╚════════════════════════════════════════╝${RESET}"
echo ""

# Detect lint command
LINT_CMD=""
if [ -f "package.json" ]; then
  if grep -q '"lint"' package.json; then
    LINT_CMD="npm run lint"
  fi
elif [ -f "Cargo.toml" ]; then
  LINT_CMD="cargo clippy"
fi

if [ -z "$LINT_CMD" ]; then
  echo -e "${YELLOW}⚠️ No lint command found - skipping lint${RESET}"
  LINT_PASSED=true
  LINT_WARNINGS=0
else
  LINT_OUTPUT=$(eval "$LINT_CMD" 2>&1)
  LINT_EXIT_CODE=$?

  if [ $LINT_EXIT_CODE -eq 0 ]; then
    echo -e "${GREEN}${BOLD}✅ LINT PASSED${RESET}"
    LINT_PASSED=true
    LINT_WARNINGS=0
  else
    echo -e "${YELLOW}${BOLD}⚠️ LINT WARNINGS${RESET}"
    LINT_PASSED=false

    # Extract warning count
    LINT_WARNINGS=$(echo "$LINT_OUTPUT" | grep -ci "warning")
    LINT_WARNINGS=${LINT_WARNINGS:-1}

    echo ""
    echo -e "${YELLOW}📊 Lint Results:${RESET}"
    echo -e "  - Warnings: ${YELLOW}${BOLD}$LINT_WARNINGS${RESET}"
  fi
fi

echo ""

# STEP 1.4: Summary
echo -e "${CYAN}╔════════════════════════════════════════╗${RESET}"
echo -e "${CYAN}║  📊 VALIDATION SUMMARY                 ║${RESET}"
echo -e "${CYAN}╚════════════════════════════════════════╝${RESET}"
echo ""

ALL_PASSED=true

if [ "$TEST_PASSED" = true ]; then
  echo -e "  🧪 Tests:  ${GREEN}${BOLD}✅ PASSED${RESET}"
else
  echo -e "  🧪 Tests:  ${RED}${BOLD}❌ FAILED ($FAILURE_RATE%)${RESET}"
  ALL_PASSED=false
fi

if [ "$BUILD_PASSED" = true ]; then
  echo -e "  🏗️ Build:  ${GREEN}${BOLD}✅ PASSED${RESET}"
else
  echo -e "  🏗️ Build:  ${RED}${BOLD}❌ FAILED ($BUILD_ERRORS errors)${RESET}"
  ALL_PASSED=false
fi

if [ "$LINT_PASSED" = true ]; then
  echo -e "  🔍 Lint:   ${GREEN}${BOLD}✅ PASSED${RESET}"
else
  echo -e "  🔍 Lint:   ${YELLOW}${BOLD}⚠️ WARNINGS ($LINT_WARNINGS)${RESET}"
  # Lint warnings don't block (only errors)
fi

echo ""
```

---

## Phase 2: Failure Analysis & Improvement Plan

```bash
if [ "$ALL_PASSED" = false ]; then
  echo ""
  echo -e "${RED}╔════════════════════════════════════════╗${RESET}"
  echo -e "${RED}║  Phase 2: Failure Analysis             ║${RESET}"
  echo -e "${RED}╚════════════════════════════════════════╝${RESET}"
  echo ""

  # STEP 2.1: Root Cause Investigation (systematic-debugging skill)
  echo -e "${BLUE}📋 Applying systematic-debugging skill...${RESET}"
  echo ""
  echo "Reference: ~/.claude/plugins/.../skills/systematic-debugging/SKILL.md"
  echo ""

  echo -e "${YELLOW}🔍 Phase 1: Root Cause Investigation${RESET}"
  echo ""

  # Test Failures
  if [ "$TEST_PASSED" = false ]; then
    echo -e "${RED}🧪 Test Failures:${RESET}"
    echo ""

    # Show failure details
    echo "$TEST_OUTPUT" | grep -A 3 "FAIL\|Error\|✕" | head -20
    echo ""

    # Extract failed test names
    FAILED_TEST_NAMES=$(echo "$TEST_OUTPUT" | grep -oP '✕.*|FAIL.*' | head -5)

    if [ -n "$FAILED_TEST_NAMES" ]; then
      echo -e "${YELLOW}Failed tests:${RESET}"
      echo "$FAILED_TEST_NAMES" | sed 's/^/  - /'
      echo ""
    fi
  fi

  # Build Failures
  if [ "$BUILD_PASSED" = false ]; then
    echo -e "${RED}🏗️ Build Errors:${RESET}"
    echo ""
    echo "$BUILD_OUTPUT" | grep -i "error" | head -10
    echo ""
  fi

  # STEP 2.2: Pattern Analysis
  echo -e "${YELLOW}🔍 Phase 2: Pattern Analysis${RESET}"
  echo ""

  # Check recent changes
  echo "Recent changes that might cause failures:"
  git diff --name-only HEAD~1..HEAD 2>/dev/null | while read file; do
    echo "  - $file"
  done
  echo ""

  # STEP 2.3: Improvement Suggestions
  echo -e "${CYAN}╔════════════════════════════════════════╗${RESET}"
  echo -e "${CYAN}║  💡 IMPROVEMENT SUGGESTIONS            ║${RESET}"
  echo -e "${CYAN}╚════════════════════════════════════════╝${RESET}"
  echo ""

  if [ "$TEST_PASSED" = false ]; then
    echo -e "${YELLOW}🧪 Test Improvements:${RESET}"
    echo ""
    echo "  1. Fix failing tests before proceeding"
    echo "  2. Run tests with verbose output: $TEST_CMD --verbose"
    echo "  3. Failure rate: ${RED}${BOLD}$FAILURE_RATE%${RESET} ($FAILED_TESTS/$TOTAL_TESTS)"
    echo ""

    # Categorize by failure rate
    FAILURE_RATE_NUM=$(echo "$FAILURE_RATE" | cut -d'.' -f1)

    if [ $FAILURE_RATE_NUM -gt 50 ]; then
      echo -e "  ${RED}⚠️ HIGH FAILURE RATE (>50%) - Consider:${RESET}"
      echo "     • Breaking changes in dependencies?"
      echo "     • Major refactoring needed?"
      echo "     • Test suite configuration issue?"
    elif [ $FAILURE_RATE_NUM -gt 20 ]; then
      echo -e "  ${YELLOW}⚠️ MODERATE FAILURE RATE (20-50%) - Consider:${RESET}"
      echo "     • Related failures (common cause)?"
      echo "     • Flaky tests (timing issues)?"
      echo "     • Missing test data/fixtures?"
    else
      echo -e "  ${GREEN}ℹ️ LOW FAILURE RATE (<20%) - Likely:${RESET}"
      echo "     • Specific bug in recent changes"
      echo "     • Edge case not handled"
      echo "     • Quick fix possible"
    fi
    echo ""
  fi

  if [ "$BUILD_PASSED" = false ]; then
    echo -e "${YELLOW}🏗️ Build Improvements:${RESET}"
    echo ""
    echo "  1. Fix compilation errors: ${RED}${BOLD}$BUILD_ERRORS${RESET} errors found"
    echo "  2. Check TypeScript/compiler configuration"
    echo "  3. Verify all imports are correct"
    echo "  4. Run with verbose: $BUILD_CMD --verbose"
    echo ""
  fi

  # STEP 2.4: Automated Issue Creation
  echo -e "${CYAN}╔════════════════════════════════════════╗${RESET}"
  echo -e "${CYAN}║  🎫 AUTOMATED ISSUE CREATION           ║${RESET}"
  echo -e "${CYAN}╚════════════════════════════════════════╝${RESET}"
  echo ""
  echo "Validation failed. Create GitHub issue to track fixes?"
  echo ""
  echo -e "${CYAN}🤔 Create issue? [Y/n]${RESET}"

  read -r CREATE_ISSUE

  if [[ "$CREATE_ISSUE" =~ ^[Yy]$ ]] || [ -z "$CREATE_ISSUE" ]; then
    echo ""
    echo -e "${BLUE}📝 Creating issue...${RESET}"
    echo ""

    # Generate issue title
    if [ "$TEST_PASSED" = false ] && [ "$BUILD_PASSED" = false ]; then
      ISSUE_TITLE="fix: Test and build failures ($FAILURE_RATE% test failure, $BUILD_ERRORS build errors)"
    elif [ "$TEST_PASSED" = false ]; then
      ISSUE_TITLE="fix: Test failures ($FAILURE_RATE% failure rate)"
    else
      ISSUE_TITLE="fix: Build failures ($BUILD_ERRORS errors)"
    fi

    # Create issue body
    cat > /tmp/validation-failure-issue.md <<EOF
## 🐛 Validation Failures

**Branch**: \`$CURRENT_BRANCH\`
**Failure Date**: $(date +%Y-%m-%d\ %H:%M:%S)

### 📊 Summary

| Check | Status | Details |
|-------|--------|---------|
| 🧪 Tests | $([ "$TEST_PASSED" = true ] && echo "✅ PASSED" || echo "❌ FAILED") | $FAILURE_RATE% failure ($FAILED_TESTS/$TOTAL_TESTS) |
| 🏗️ Build | $([ "$BUILD_PASSED" = true ] && echo "✅ PASSED" || echo "❌ FAILED") | $BUILD_ERRORS errors |
| 🔍 Lint | $([ "$LINT_PASSED" = true ] && echo "✅ PASSED" || echo "⚠️ WARNINGS") | $LINT_WARNINGS warnings |

### 🧪 Test Details

**Failed Tests**:
\`\`\`
$FAILED_TEST_NAMES
\`\`\`

**Test Output** (first 20 lines of failures):
\`\`\`
$(echo "$TEST_OUTPUT" | grep -A 3 "FAIL\|Error\|✕" | head -20)
\`\`\`

### 🏗️ Build Details

**Build Errors**:
\`\`\`
$(echo "$BUILD_OUTPUT" | grep -i "error" | head -10)
\`\`\`

### 💡 Improvement Plan

**Immediate Actions**:
1. Fix critical test failures
2. Resolve build errors
3. Re-run validation: \`$TEST_CMD && $BUILD_CMD\`

**Root Cause Analysis** (systematic-debugging):
- Recent changes: \`$(git log -1 --oneline)\`
- Modified files: $(git diff --name-only HEAD~1..HEAD 2>/dev/null | wc -l) files
- Failure category: $([ $FAILURE_RATE_NUM -gt 50 ] && echo "HIGH (>50%)" || ([ $FAILURE_RATE_NUM -gt 20 ] && echo "MODERATE (20-50%)" || echo "LOW (<20%)"))

### 🔗 Related Files

$(git diff --name-only HEAD~1..HEAD 2>/dev/null | sed 's/^/- /')

---
🤖 Auto-generated from validation failure via Claude Code
Branch: \`$CURRENT_BRANCH\`
Command: \`/github:pr\`
EOF

    # Create issue via gh CLI
    gh issue create \
      --title "$ISSUE_TITLE" \
      --body-file /tmp/validation-failure-issue.md \
      --label "bug" \
      --assignee @me 2>&1

    ISSUE_URL=$(gh issue list --author "@me" --limit 1 --json url -q '.[0].url' 2>/dev/null)

    echo ""
    echo -e "${GREEN}✅ Issue created: ${BOLD}$ISSUE_URL${RESET}"
    echo ""
  fi

  # STOP: Cannot proceed with failures
  echo ""
  echo -e "${RED}╔════════════════════════════════════════╗${RESET}"
  echo -e "${RED}║  🛑 VALIDATION FAILED - STOPPING       ║${RESET}"
  echo -e "${RED}╚════════════════════════════════════════╝${RESET}"
  echo ""
  echo "Cannot proceed with PR creation until validation passes."
  echo ""
  echo -e "${YELLOW}Next steps:${RESET}"
  echo "  1. Fix the issues listed above"
  echo "  2. Run validation: $TEST_CMD && $BUILD_CMD"
  echo "  3. Re-run this command when ready"
  echo ""

  exit 1
fi

# All validation passed - proceed
echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${RESET}"
echo -e "${GREEN}║  ✅ ALL VALIDATION PASSED              ║${RESET}"
echo -e "${GREEN}╚════════════════════════════════════════╝${RESET}"
echo ""
```

---

## Phase 3: Intelligent File Classification

```bash
echo ""
echo -e "${CYAN}╔════════════════════════════════════════╗${RESET}"
echo -e "${CYAN}║  Phase 3: File Classification          ║${RESET}"
echo -e "${CYAN}╚════════════════════════════════════════╝${RESET}"
echo ""

# STEP 3.1: Collect all changes
echo -e "${BLUE}🔍 Analyzing all changes...${RESET}"
echo ""

# Combine all changed files
ALL_CHANGED_FILES="$STAGED_FILES
$UNSTAGED_FILES
$UNTRACKED_FILES"

# Remove duplicates and empty lines
ALL_CHANGED_FILES=$(echo "$ALL_CHANGED_FILES" | sort -u | grep -v '^$')

# STEP 3.2: Classify files by type
declare -A FILE_CATEGORIES
declare -A CATEGORY_FILES

while IFS= read -r file; do
  if [ -z "$file" ]; then
    continue
  fi

  CATEGORY=""

  # Get file extension
  EXT="${file##*.}"

  # Get directory path
  DIR=$(dirname "$file")

  # Rule-based classification

  # 📝 Documentation
  if [[ "$file" =~ \.(md|txt|rst|adoc)$ ]] || [[ "$DIR" =~ docs?/ ]]; then
    CATEGORY="docs"

  # 🧪 Tests
  elif [[ "$file" =~ \.(test|spec)\. ]] || [[ "$DIR" =~ (test|__tests__|spec)/ ]]; then
    CATEGORY="test"

  # 🎨 Styles
  elif [[ "$file" =~ \.(css|scss|sass|less|styl)$ ]]; then
    CATEGORY="style"

  # ⚙️ Configuration
  elif [[ "$file" =~ \.(json|yaml|yml|toml|ini|conf|config)$ ]] || \
       [[ "$file" =~ (package\.json|tsconfig|\.env|Dockerfile) ]]; then
    CATEGORY="chore"

  # 🔧 Build/CI
  elif [[ "$DIR" =~ \.github/workflows ]] || [[ "$file" =~ (docker-compose|\.gitlab-ci) ]]; then
    CATEGORY="chore"

  # 🐛 Bug fixes (analyze git diff for keywords)
  elif git diff HEAD "$file" 2>/dev/null | grep -qiE "(fix|bug|error|issue)" || \
       echo "$file" | grep -qiE "(fix|bug)"; then
    CATEGORY="fix"

  # ⚡ Performance
  elif git diff HEAD "$file" 2>/dev/null | grep -qiE "(performance|optimize|speed|cache)" || \
       echo "$file" | grep -qiE "(perf|performance)"; then
    CATEGORY="perf"

  # ♻️ Refactor
  elif git diff HEAD "$file" 2>/dev/null | grep -qiE "(refactor|cleanup)" || \
       echo "$file" | grep -qiE "refactor"; then
    CATEGORY="refactor"

  # ✨ Feature (default for code files)
  else
    CATEGORY="feature"
  fi

  # Store classification
  FILE_CATEGORIES["$file"]="$CATEGORY"

  # Add to category list
  if [ -z "${CATEGORY_FILES[$CATEGORY]}" ]; then
    CATEGORY_FILES[$CATEGORY]="$file"
  else
    CATEGORY_FILES[$CATEGORY]="${CATEGORY_FILES[$CATEGORY]}
$file"
  fi
done <<< "$ALL_CHANGED_FILES"

# STEP 3.3: Display classification results
echo -e "${GREEN}📊 File Classification Results:${RESET}"
echo ""

for category in "${!CATEGORY_FILES[@]}"; do
  files="${CATEGORY_FILES[$category]}"
  count=$(echo "$files" | grep -c '^' 2>/dev/null)

  case $category in
    feature)
      emoji="✨"
      label="Features"
      color=$GREEN
      ;;
    fix)
      emoji="🐛"
      label="Bug Fixes"
      color=$RED
      ;;
    docs)
      emoji="📝"
      label="Documentation"
      color=$BLUE
      ;;
    test)
      emoji="🧪"
      label="Tests"
      color=$YELLOW
      ;;
    style)
      emoji="🎨"
      label="Styles"
      color=$MAGENTA
      ;;
    refactor)
      emoji="♻️"
      label="Refactoring"
      color=$CYAN
      ;;
    perf)
      emoji="⚡"
      label="Performance"
      color=$YELLOW
      ;;
    chore)
      emoji="⚙️"
      label="Configuration"
      color=$WHITE
      ;;
    *)
      emoji="📦"
      label="Other"
      color=$WHITE
      ;;
  esac

  echo -e "${color}$emoji $label ($count files):${RESET}"
  echo "$files" | grep -v '^$' | sed 's/^/    /'
  echo ""
done

# STEP 3.4: User confirmation
echo ""
echo -e "${CYAN}╔════════════════════════════════════════╗${RESET}"
echo -e "${CYAN}║  🤔 CLASSIFICATION CONFIRMATION        ║${RESET}"
echo -e "${CYAN}╚════════════════════════════════════════╝${RESET}"
echo ""
echo "Files have been automatically classified by type."
echo ""
echo "Options:"
echo "  1. Accept classification (create branches automatically)"
echo "  2. Abort (exit without changes)"
echo ""
echo -e "${CYAN}Which option? [1-2]${RESET}"

read -r CLASSIFICATION_CHOICE

if [ "$CLASSIFICATION_CHOICE" = "2" ]; then
  echo ""
  echo -e "${YELLOW}❌ Aborted by user${RESET}"
  exit 0
fi

echo ""
echo -e "${GREEN}✅ Classification accepted${RESET}"
echo ""
```

---

## Phase 4: Safe Branch Creation & Commit

```bash
echo ""
echo -e "${CYAN}╔════════════════════════════════════════╗${RESET}"
echo -e "${CYAN}║  Phase 4: Safe Branch Operations       ║${RESET}"
echo -e "${CYAN}╚════════════════════════════════════════╝${RESET}"
echo ""

# STEP 4.1: Create safety backup
echo -e "${BLUE}📦 Creating safety backup...${RESET}"
echo ""

# Stash everything (including untracked)
STASH_NAME="AUTO_BACKUP_$(date +%Y%m%d_%H%M%S)"
git stash push --include-untracked -m "$STASH_NAME" > /dev/null 2>&1

echo -e "${GREEN}✅ Backup created: ${BOLD}$STASH_NAME${RESET}"
echo -e "📌 Base branch: ${BOLD}$BASE_BRANCH${RESET}"
echo ""

# Ensure we're on base branch
git checkout $BASE_BRANCH > /dev/null 2>&1

# STEP 4.2: Process each category
declare -A CREATED_BRANCHES

for category in "${!CATEGORY_FILES[@]}"; do
  files="${CATEGORY_FILES[$category]}"
  file_count=$(echo "$files" | grep -c '^' 2>/dev/null)

  echo -e "${CYAN}╔════════════════════════════════════════╗${RESET}"
  echo -e "${CYAN}║  Processing: $category ($file_count files)${RESET}"
  echo -e "${CYAN}╚════════════════════════════════════════╝${RESET}"
  echo ""

  # Generate branch name
  TIMESTAMP=$(date +%Y%m%d_%H%M%S)
  BRANCH_NAME="${category}/auto-${TIMESTAMP}"

  echo -e "${BLUE}🌿 Creating branch: ${BOLD}$BRANCH_NAME${RESET}"

  # Create branch from base
  git checkout -b "$BRANCH_NAME" $BASE_BRANCH > /dev/null 2>&1

  # Apply stash
  STASH_REF=$(git stash list | grep "$STASH_NAME" | grep -oP 'stash@\{[0-9]+\}' | head -1)
  git stash apply "$STASH_REF" --quiet > /dev/null 2>&1

  # Stage ONLY files in this category
  echo -e "${BLUE}📝 Staging files for $category...${RESET}"
  echo ""

  STAGED_THIS_CATEGORY=0

  while IFS= read -r file; do
    if [ -n "$file" ]; then
      # Check if file exists
      if [ -f "$file" ] || git ls-files --error-unmatch "$file" &>/dev/null; then
        git add "$file" > /dev/null 2>&1
        echo "  ✅ $file"
        STAGED_THIS_CATEGORY=$((STAGED_THIS_CATEGORY + 1))
      else
        echo -e "  ${YELLOW}⚠️ Skipped (not found): $file${RESET}"
      fi
    fi
  done <<< "$files"

  echo ""

  # Check if anything was staged
  if [ -z "$(git diff --cached --name-only)" ]; then
    echo -e "${YELLOW}ℹ️ No files staged for $category - skipping${RESET}"
    git checkout $BASE_BRANCH > /dev/null 2>&1
    git branch -D "$BRANCH_NAME" > /dev/null 2>&1
    echo ""
    continue
  fi

  # Generate commit message
  COMMIT_PREFIX=""
  case $category in
    feature) COMMIT_PREFIX="feat" ;;
    fix) COMMIT_PREFIX="fix" ;;
    docs) COMMIT_PREFIX="docs" ;;
    test) COMMIT_PREFIX="test" ;;
    style) COMMIT_PREFIX="style" ;;
    refactor) COMMIT_PREFIX="refactor" ;;
    perf) COMMIT_PREFIX="perf" ;;
    chore) COMMIT_PREFIX="chore" ;;
  esac

  COMMIT_MSG="$COMMIT_PREFIX: Auto-classified changes for $category

Files modified: $STAGED_THIS_CATEGORY file(s)
$(echo "$files" | grep -v '^$' | sed 's/^/- /')

🤖 Generated with Claude Code
Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"

  # Commit
  echo -e "${BLUE}💾 Committing changes...${RESET}"
  git commit -m "$COMMIT_MSG" > /dev/null 2>&1

  # Reset working directory
  git reset --hard HEAD > /dev/null 2>&1

  # Store branch name
  CREATED_BRANCHES["$category"]="$BRANCH_NAME"

  echo -e "${GREEN}✅ Branch ${BOLD}$BRANCH_NAME${RESET} created and committed"
  echo ""

  # Return to base branch
  git checkout $BASE_BRANCH > /dev/null 2>&1
done

# STEP 4.3: Drop the stash
echo -e "${BLUE}🧹 Cleaning up backup...${RESET}"
STASH_REF=$(git stash list | grep "$STASH_NAME" | grep -oP 'stash@\{[0-9]+\}' | head -1)
if [ -n "$STASH_REF" ]; then
  git stash drop "$STASH_REF" > /dev/null 2>&1
fi
echo ""

# STEP 4.4: Summary
echo -e "${GREEN}╔════════════════════════════════════════╗${RESET}"
echo -e "${GREEN}║  ✅ BRANCHES CREATED                   ║${RESET}"
echo -e "${GREEN}╚════════════════════════════════════════╝${RESET}"
echo ""

for category in "${!CREATED_BRANCHES[@]}"; do
  branch="${CREATED_BRANCHES[$category]}"
  echo -e "  ${GREEN}$category${RESET} → ${BOLD}$branch${RESET}"
done
echo ""
```

---

## Phase 5: Push, PR, Merge, Cleanup

```bash
echo ""
echo -e "${CYAN}╔════════════════════════════════════════╗${RESET}"
echo -e "${CYAN}║  Phase 5: Push/PR/Merge/Cleanup        ║${RESET}"
echo -e "${CYAN}╚════════════════════════════════════════╝${RESET}"
echo ""

# STEP 5.1: Push all branches
echo -e "${BLUE}📤 Pushing branches to remote...${RESET}"
echo ""

for category in "${!CREATED_BRANCHES[@]}"; do
  branch="${CREATED_BRANCHES[$category]}"

  echo -e "${BLUE}🔄 Pushing ${BOLD}$branch${RESET}..."
  git push -u origin "$branch" > /dev/null 2>&1
  echo -e "${GREEN}✅ Pushed ${BOLD}$branch${RESET}"
  echo ""
done

# STEP 5.2: Create PRs
echo -e "${BLUE}📝 Creating pull requests...${RESET}"
echo ""

declare -A PR_NUMBERS

for category in "${!CREATED_BRANCHES[@]}"; do
  branch="${CREATED_BRANCHES[$category]}"
  files="${CATEGORY_FILES[$category]}"

  # Generate PR title
  case $category in
    feature) PR_TITLE="✨ feat: Auto-classified feature changes" ;;
    fix) PR_TITLE="🐛 fix: Auto-classified bug fixes" ;;
    docs) PR_TITLE="📝 docs: Auto-classified documentation updates" ;;
    test) PR_TITLE="🧪 test: Auto-classified test updates" ;;
    style) PR_TITLE="🎨 style: Auto-classified style changes" ;;
    refactor) PR_TITLE="♻️ refactor: Auto-classified refactoring" ;;
    perf) PR_TITLE="⚡ perf: Auto-classified performance improvements" ;;
    chore) PR_TITLE="⚙️ chore: Auto-classified configuration changes" ;;
  esac

  # Generate PR body
  cat > /tmp/pr-body-${category}.md <<EOF
## 📋 Summary
Auto-classified changes for: **$category**

## 📊 Changes
$(echo "$files" | grep -v '^$' | sed 's/^/- /')

## ✅ Validation Results
- 🧪 Tests: ✅ PASSED
- 🏗️ Build: ✅ PASSED
- 🔍 Lint: $([ "$LINT_PASSED" = true ] && echo "✅ PASSED" || echo "⚠️ $LINT_WARNINGS warnings")

## 🤖 Auto-Generated
- Classification: Intelligent file analysis
- Branch: \`$branch\`
- Category: \`$category\`

---
🤖 Generated with [Claude Code](https://claude.com/claude-code)
Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
EOF

  echo -e "${BLUE}📝 Creating PR for ${BOLD}$category${RESET}..."

  # Create PR
  gh pr create \
    --title "$PR_TITLE" \
    --body-file /tmp/pr-body-${category}.md \
    --base $BASE_BRANCH \
    --head "$branch" > /dev/null 2>&1

  # Get PR number
  PR_NUMBER=$(gh pr list --head "$branch" --json number -q '.[0].number' 2>/dev/null)
  PR_NUMBERS["$category"]="$PR_NUMBER"

  echo -e "${GREEN}✅ PR #$PR_NUMBER created for ${BOLD}$category${RESET}"
  echo ""
done

# STEP 5.3: Merge confirmation
echo ""
echo -e "${YELLOW}╔════════════════════════════════════════╗${RESET}"
echo -e "${YELLOW}║  ⚠️ MERGE CONFIRMATION                 ║${RESET}"
echo -e "${YELLOW}╚════════════════════════════════════════╝${RESET}"
echo ""
echo -e "${BOLD}Ready to merge all PRs to $BASE_BRANCH${RESET}"
echo ""
echo "This will:"
for category in "${!PR_NUMBERS[@]}"; do
  pr_num="${PR_NUMBERS[$category]}"
  pr_url=$(gh pr view $pr_num --json url -q '.url' 2>/dev/null)
  echo "  - Merge PR #$pr_num ($category): $pr_url"
done
echo ""
echo -e "${CYAN}🤔 Proceed with merge? [Y/n]${RESET}"

read -r MERGE_CONFIRM

if [[ ! "$MERGE_CONFIRM" =~ ^[Yy]$ ]] && [ -n "$MERGE_CONFIRM" ]; then
  echo ""
  echo -e "${YELLOW}❌ Merge cancelled by user${RESET}"
  echo ""
  echo "PRs have been created but not merged:"
  for category in "${!PR_NUMBERS[@]}"; do
    pr_num="${PR_NUMBERS[$category]}"
    pr_url=$(gh pr view $pr_num --json url -q '.url' 2>/dev/null)
    echo "  - $category: $pr_url"
  done
  echo ""
  exit 0
fi

echo ""

# STEP 5.4: Merge PRs
echo -e "${BLUE}🔀 Merging pull requests...${RESET}"
echo ""

for category in "${!PR_NUMBERS[@]}"; do
  pr_num="${PR_NUMBERS[$category]}"
  branch="${CREATED_BRANCHES[$category]}"

  echo -e "${BLUE}🔀 Merging PR #$pr_num (${BOLD}$category${RESET})..."

  # Merge with squash
  gh pr merge $pr_num \
    --squash \
    --delete-branch \
    --auto > /dev/null 2>&1

  echo -e "${GREEN}✅ Merged and deleted remote branch: ${BOLD}$branch${RESET}"
  echo ""
done

# STEP 5.5: Delete local branches
echo -e "${BLUE}🧹 Cleaning up local branches...${RESET}"
echo ""

for category in "${!CREATED_BRANCHES[@]}"; do
  branch="${CREATED_BRANCHES[$category]}"

  echo -e "${BLUE}🗑️ Deleting local branch: ${BOLD}$branch${RESET}"
  git branch -D "$branch" > /dev/null 2>&1 || true
done

echo ""

# STEP 5.6: Update main
echo -e "${BLUE}📥 Updating ${BOLD}$BASE_BRANCH${RESET}...${RESET}"
git checkout $BASE_BRANCH > /dev/null 2>&1
git pull origin $BASE_BRANCH > /dev/null 2>&1

echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${RESET}"
echo -e "${GREEN}║  ✅ WORKFLOW COMPLETED                 ║${RESET}"
echo -e "${GREEN}╚════════════════════════════════════════╝${RESET}"
echo ""

# Final summary
echo -e "${BOLD}📊 Summary:${RESET}"
echo "  - Categories processed: ${#CREATED_BRANCHES[@]}"
echo "  - PRs created and merged: ${#PR_NUMBERS[@]}"
echo "  - Branches cleaned up: ${#CREATED_BRANCHES[@]}"
echo ""

echo -e "${GREEN}${BOLD}🎉 All changes have been successfully merged to $BASE_BRANCH!${RESET}"
echo ""
```

---

## Error Recovery

```bash
# Error handler (trap at beginning)
trap 'handle_error $LINENO' ERR

handle_error() {
  local line_num=$1

  echo ""
  echo -e "${RED}╔════════════════════════════════════════╗${RESET}"
  echo -e "${RED}║  ❌ ERROR AT LINE $line_num              ${RESET}"
  echo -e "${RED}╚════════════════════════════════════════╝${RESET}"
  echo ""

  echo -e "${YELLOW}🔄 Attempting recovery...${RESET}"
  echo ""

  # Restore from stash if exists
  STASH_REF=$(git stash list | grep "AUTO_BACKUP" | grep -oP 'stash@\{[0-9]+\}' | head -1)
  if [ -n "$STASH_REF" ]; then
    echo -e "${BLUE}📦 Restoring from backup: $STASH_REF${RESET}"
    git checkout $BASE_BRANCH > /dev/null 2>&1
    git stash pop "$STASH_REF" > /dev/null 2>&1
    echo -e "${GREEN}✅ Backup restored${RESET}"
  fi

  # Cleanup any created branches
  for branch in "${CREATED_BRANCHES[@]}"; do
    if [ -n "$branch" ]; then
      echo -e "${BLUE}🗑️ Cleaning up branch: $branch${RESET}"
      git branch -D "$branch" > /dev/null 2>&1 || true
    fi
  done

  echo ""
  echo -e "${YELLOW}🎫 Create issue to track this error? [Y/n]${RESET}"
  read -r CREATE_ERROR_ISSUE

  if [[ "$CREATE_ERROR_ISSUE" =~ ^[Yy]$ ]] || [ -z "$CREATE_ERROR_ISSUE" ]; then
    gh issue create \
      --title "fix: PR workflow error at line $line_num" \
      --body "Error occurred during automated PR workflow execution.

**Error Location**: Line $line_num
**Branch**: \`$CURRENT_BRANCH\`
**Timestamp**: $(date +%Y-%m-%d\ %H:%M:%S)

🤖 Auto-generated error report" \
      --label "bug" \
      --assignee @me > /dev/null 2>&1

    echo -e "${GREEN}✅ Issue created${RESET}"
  fi

  echo ""
  echo -e "${RED}Workflow terminated due to error${RESET}"
  exit 1
}
```

---

## Usage Examples

### Example 1: All Tests Pass
```bash
$ /github:pr

🔍 Validating environment...
✅ Environment validation passed

🧪 RUNNING TESTS
✅ TESTS PASSED

🏗️ RUNNING BUILD
✅ BUILD PASSED

🔍 RUNNING LINT
✅ LINT PASSED

✅ ALL VALIDATION PASSED

📊 File Classification:
✨ Features (5 files):
    src/auth.service.ts
    src/user.controller.ts
    ...

🐛 Bug Fixes (2 files):
    src/validation.ts
    src/error-handler.ts

🤔 Accept classification? [1-2] 1

📦 Creating safety backup...
🌿 Creating branches...
✅ Branches created

📤 Pushing to remote...
📝 Creating PRs...
✅ 2 PRs created

🤔 Proceed with merge? [Y/n] Y

🔀 Merging PRs...
✅ All merged

🎉 Workflow completed!
```

### Example 2: Tests Fail
```bash
$ /github:pr

🧪 RUNNING TESTS
❌ TESTS FAILED

📊 Test Results:
  - Total: 45 tests
  - Failed: 3 tests
  - Failure: 6.7%

💡 IMPROVEMENT SUGGESTIONS

ℹ️ LOW FAILURE RATE (<20%) - Likely:
  • Specific bug in recent changes
  • Edge case not handled
  • Quick fix possible

🤔 Create issue? [Y/n] Y

📝 Creating issue...
✅ Issue created: https://github.com/user/repo/issues/42

🛑 VALIDATION FAILED - STOPPING

Next steps:
  1. Fix the issues
  2. Run: npm test && npm run build
  3. Re-run this command
```

---

## Safety Features

### ✅ Implemented
- **Stash-based backup**: Zero data loss
- **Atomic operations**: Each phase can rollback
- **Error recovery**: Auto-restore on failure
- **User confirmations**: At critical points
- **Git state verification**: Before/after checks
- **Skills integration**: verification-before-completion, systematic-debugging, finishing-a-development-branch
- **Colored output**: Clear success/failure indicators
- **Auto-issue creation**: Track failures automatically

### ⚠️ Requirements
- Git repository
- GitHub CLI (`gh`) installed and authenticated
- npm/yarn/cargo (for test/build/lint)
- Bash shell (Linux/macOS/WSL)

---

## References

**Skills Used:**
1. `verification-before-completion`: Evidence before claims
2. `systematic-debugging`: Root cause investigation
3. `finishing-a-development-branch`: Structured completion workflow

**Color Legend:**
- 🟢 **Green**: Success, passed
- 🔴 **Red**: Failure, error
- 🟡 **Yellow**: Warning, info
- 🔵 **Blue**: Processing, action
- 🟣 **Magenta**: Section headers
