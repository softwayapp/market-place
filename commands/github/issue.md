---
description: Create GitHub issue with auto type detection (bug/feature/task)
argument-hint: [issue-title]
allowed-tools: Bash, Read, Write, Grep, Glob
model: claude-sonnet-4-5-20250929
---

# GitHub Issue Auto-creation

Issue Title: **$ARGUMENTS**

## ⚠️ CRITICAL SAFETY RULES

**READ-ONLY Git Operations:**
```bash
# ✅ ALLOWED (Information gathering)
git status --porcelain
git diff --staged
git diff
git log --oneline -10
git branch --show-current

# ❌ FORBIDDEN (Modifying operations)
git add
git commit
git push
git checkout
git merge
git reset
git stash
```

**Skills Integration:**
- Reference: `~/.claude/plugins/cache/superpowers-marketplace/superpowers/3.6.2/skills/verification-before-completion/SKILL.md`
- Reference: `~/.claude/plugins/cache/superpowers-marketplace/superpowers/3.6.2/skills/finishing-a-development-branch/SKILL.md`
- **Principle**: Evidence before claims - verify git state, never modify it

---

## Execution Process

### 0. Command Type Detection (Priority Check)

**CRITICAL**: First check if this is an issue close request:

**Close Issue Keywords**:
- Korean: "닫아줘", "닫기", "클로즈", "완료", "종료"
- English: "close", "finish", "complete", "done"
- Pattern: "#숫자 닫아줘", "이슈 닫아줘", "close #9"

**If close request detected**:
```bash
# Extract issue number (if specified)
if [[ "$ARGUMENTS" =~ \#?([0-9]+) ]]; then
  ISSUE_NUM="${BASH_REMATCH[1]}"
else
  # Get most recently created issue
  ISSUE_NUM=$(gh issue list --author "@me" --limit 1 --json number -q '.[0].number')
fi

# Analyze what was accomplished (READ-ONLY)
CHANGED_FILES=$(git diff main...HEAD --name-only 2>/dev/null | head -10)
COMMIT_COUNT=$(git log main..HEAD --oneline 2>/dev/null | wc -l)
RECENT_COMMITS=$(git log main..HEAD --oneline 2>/dev/null | head -5)

# Close the issue with completion message
gh issue close $ISSUE_NUM --comment "✅ 작업 완료

📊 변경 내용:
- 변경된 파일: $COMMIT_COUNT개 커밋, $(echo "$CHANGED_FILES" | wc -l)개 파일
- 주요 변경 사항:
$(echo "$CHANGED_FILES" | head -5 | sed 's/^/  - /')

📝 최근 커밋:
$(echo "$RECENT_COMMITS" | sed 's/^/  - /')

🤖 Closed via Claude Code"

echo "✅ Issue #$ISSUE_NUM closed successfully"
```

**Otherwise, proceed with issue creation flow:**

---

### 1. Git State Analysis (READ-ONLY)

**STEP 1: Verify git repository**
```bash
# Check if in git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo "❌ Not a git repository. Cannot analyze changes."
  exit 1
fi
```

**STEP 2: Collect current state (READ-ONLY ONLY)**
```bash
# Current branch
CURRENT_BRANCH=$(git branch --show-current)

# Staged changes
STAGED_FILES=$(git diff --staged --name-only)
STAGED_COUNT=$(echo "$STAGED_FILES" | grep -v '^$' | wc -l)

# Unstaged changes
UNSTAGED_FILES=$(git diff --name-only)
UNSTAGED_COUNT=$(echo "$UNSTAGED_FILES" | grep -v '^$' | wc -l)

# Untracked files
UNTRACKED_FILES=$(git ls-files --others --exclude-standard)
UNTRACKED_COUNT=$(echo "$UNTRACKED_FILES" | grep -v '^$' | wc -l)

# Total changes
TOTAL_CHANGES=$((STAGED_COUNT + UNSTAGED_COUNT + UNTRACKED_COUNT))

# Recent commits on current branch
RECENT_COMMITS=$(git log --oneline -5 2>/dev/null)

# Branch comparison with main
if git show-ref --verify --quiet refs/heads/main; then
  BASE_BRANCH="main"
elif git show-ref --verify --quiet refs/heads/master; then
  BASE_BRANCH="master"
else
  BASE_BRANCH=""
fi

if [ -n "$BASE_BRANCH" ]; then
  BRANCH_DIFF=$(git diff $BASE_BRANCH...HEAD --name-only 2>/dev/null)
  BRANCH_DIFF_COUNT=$(echo "$BRANCH_DIFF" | grep -v '^$' | wc -l)
else
  BRANCH_DIFF=""
  BRANCH_DIFF_COUNT=0
fi
```

**STEP 3: Safety verification**
```bash
# ⚠️ WARNING: Check for unsaved work
if [ $TOTAL_CHANGES -gt 0 ]; then
  echo "⚠️ WARNING: You have $TOTAL_CHANGES unsaved changes:"
  echo "  - Staged: $STAGED_COUNT files"
  echo "  - Unstaged: $UNSTAGED_COUNT files"
  echo "  - Untracked: $UNTRACKED_COUNT files"
  echo ""
  echo "🛡️ This command will NOT modify your git state."
  echo "📋 Changes will be documented in the issue for reference."
fi
```

---

### 2. Context Analysis (Automatic)

Analyze conversation history and git state to automatically determine issue type:

**Type Detection Priority:**
1. **Bug**: Keywords (에러, 버그, 문제, 오류, error, bug, fail, crash) OR stack trace detected
2. **Feature**: Keywords (추가, 구현, 기능, 개선, add, feature, implement, enhance)
3. **Task**: Keywords (리팩토링, 작업, cleanup, refactor, task) OR TodoWrite items exist
4. **Branch Type**: Extract from current branch name (feature/*, fix/*, docs/*)

**Branch Type Detection:**
```bash
if [[ "$CURRENT_BRANCH" =~ ^feature/ ]]; then
  DETECTED_TYPE="Feature"
elif [[ "$CURRENT_BRANCH" =~ ^fix/ ]]; then
  DETECTED_TYPE="Bug"
elif [[ "$CURRENT_BRANCH" =~ ^docs/ ]]; then
  DETECTED_TYPE="Documentation"
elif [[ "$CURRENT_BRANCH" =~ ^refactor/ ]]; then
  DETECTED_TYPE="Task"
else
  # Fallback to keyword detection
  DETECTED_TYPE="Feature"  # Default
fi
```

---

### 3. Auto Information Collection

#### For Bug type:
- Extract error messages from conversation
- Search related file paths (use Grep to find error locations)
- **Collect staged/unstaged changes** (READ-ONLY git diff)
- Collect stack traces
- Environment info (Node.js version, OS, git branch)

**Example Collection:**
```bash
# Find error patterns in changed files
CHANGED_FILES_WITH_ERRORS=$(git diff --name-only | while read file; do
  if grep -l "error\|exception\|fail" "$file" 2>/dev/null; then
    echo "  - $file"
  fi
done)

# Collect error context
ERROR_CONTEXT="
## 🐛 Bug Context

**Branch**: \`$CURRENT_BRANCH\`
**Files with potential issues**:
$CHANGED_FILES_WITH_ERRORS

**Staged changes**: $STAGED_COUNT files
**Unstaged changes**: $UNSTAGED_COUNT files

**Changed files**:
$(git diff --staged --name-only | sed 's/^/  - /')
"
```

#### For Feature type:
- Extract feature request background from conversation
- Organize use cases
- **Document current work progress** (git diff summary)
- Ask priority (high/medium/low)
- Estimate impact scope

**Example Collection:**
```bash
FEATURE_CONTEXT="
## 💡 Feature Context

**Branch**: \`$CURRENT_BRANCH\`
**Current progress**: $BRANCH_DIFF_COUNT files changed from $BASE_BRANCH

**Files involved**:
$(echo "$BRANCH_DIFF" | sed 's/^/  - /')

**Recent commits**:
$(echo "$RECENT_COMMITS" | sed 's/^/  - /')
"
```

#### For Task type:
- Get current TodoWrite items
- **Document staged/unstaged work** (git status --porcelain)
- Generate checklist from conversation
- List related component files

**Example Collection:**
```bash
TASK_CONTEXT="
## 📋 Task Context

**Branch**: \`$CURRENT_BRANCH\`
**Work in progress**:
  - Staged: $STAGED_COUNT files
  - Unstaged: $UNSTAGED_COUNT files
  - Untracked: $UNTRACKED_COUNT files

**Modified files**:
$(git status --porcelain | sed 's/^/  /')

**Commits on this branch**:
$(echo "$RECENT_COMMITS" | sed 's/^/  - /')
"
```

---

### 4. Template Selection and Creation

Read appropriate template based on determined type:
- `~/.claude/templates/github-issues/bug.md`
- `~/.claude/templates/github-issues/feature.md`
- `~/.claude/templates/github-issues/task.md`

**If templates don't exist**, use default format:

```markdown
## 📝 Description
[Auto-generated from conversation context]

## 🔍 Current State
[Git state analysis - from Step 1]

## 📊 Changes Summary
[Staged/unstaged/untracked files - READ-ONLY analysis]

## ✅ Acceptance Criteria
[Auto-generated from conversation or ask user]

## 🔗 Related Files
[Files from git diff analysis]

---
🤖 Generated via Claude Code
Branch: $CURRENT_BRANCH
```

---

### 5. Comprehensive Label & Metadata Check

**STEP 1: Get ALL available repository metadata**
```bash
# Get available labels
AVAILABLE_LABELS=$(gh label list --json name -q '.[].name')

# Get available milestones
AVAILABLE_MILESTONES=$(gh api repos/:owner/:repo/milestones --jq '.[].title' 2>/dev/null)

# Get available projects
AVAILABLE_PROJECTS=$(gh project list --owner @me --format json --jq '.[].title' 2>/dev/null)

# Get repository assignees
AVAILABLE_ASSIGNEES=$(gh api repos/:owner/:repo/assignees --jq '.[].login' 2>/dev/null)
```

**STEP 2: Intelligent Label Selection**

**Auto Label Mapping with Fallback Strategy:**
- Bug type:
  - Primary: `bug` (if exists)
  - Fallback: `bugfix` → `defect` → `fix` → no label

- Feature type:
  - Primary: `feature` (if exists)
  - Fallback: `enhancement` → `new feature` → `improvement` → no label

- Task type:
  - Primary: `task` (if exists)
  - Fallback: `chore` → `refactor` → `maintenance` → no label

- Documentation type:
  - Primary: `documentation` (if exists)
  - Fallback: `docs` → no label

**Component detection (optional, only if labels exist):**
```bash
# Auto-detect component labels from file paths
if echo "$BRANCH_DIFF" | grep -q "src/auth"; then
  COMPONENT_LABELS="$COMPONENT_LABELS auth"
fi

if echo "$BRANCH_DIFF" | grep -q "src/api"; then
  COMPONENT_LABELS="$COMPONENT_LABELS api"
fi

# Only add component labels if they exist in repository
for label in $COMPONENT_LABELS; do
  if echo "$AVAILABLE_LABELS" | grep -q "^$label$"; then
    SELECTED_LABELS="$SELECTED_LABELS --label \"$label\""
  fi
done
```

**STEP 3: Priority Auto-determination**
- Error/crash related → `high` (if priority labels exist)
- Security related → `critical` (if priority labels exist)
- Performance improvement → `medium`
- General features → `low`

**STEP 4: Build label arguments safely**
```bash
LABEL_ARGS=""

# Only add labels that actually exist
if echo "$AVAILABLE_LABELS" | grep -q "^$PRIMARY_LABEL$"; then
  LABEL_ARGS="--label \"$PRIMARY_LABEL\""
elif echo "$AVAILABLE_LABELS" | grep -q "^$FALLBACK_LABEL$"; then
  LABEL_ARGS="--label \"$FALLBACK_LABEL\""
fi

# If no matching labels found, skip labels entirely (prevents failure)
if [ -z "$LABEL_ARGS" ]; then
  echo "ℹ️ No matching labels found. Creating issue without labels."
fi
```

---

### 6. User Confirmation (SAFETY GATE)

**STEP 1: Present summary for verification**
```
📋 Issue Summary (for confirmation):

**Title**: $ARGUMENTS
**Type**: $DETECTED_TYPE
**Labels**: $SELECTED_LABELS (or "none" if no matches)

**Git State Snapshot**:
  - Branch: $CURRENT_BRANCH
  - Staged: $STAGED_COUNT files
  - Unstaged: $UNSTAGED_COUNT files
  - Commits: $(echo "$RECENT_COMMITS" | wc -l) on this branch

**⚠️ Safety Check**:
  - This command will NOT modify your git state
  - Your local changes are safe
  - Issue will reference current work state

**Files to be referenced**:
$(git status --porcelain | head -10 | sed 's/^/  /')

🤔 Proceed with issue creation? [Y/n]
```

**STEP 2: Wait for confirmation**
- If user confirms: Proceed to Step 7
- If user declines: Abort safely, no changes made

---

### 7. Issue Creation (Safe Execution)

```bash
# Write issue body to temporary file
cat > /tmp/issue-body.md <<EOF
$ISSUE_BODY_CONTENT
EOF

# Execute issue creation
if [ -n "$LABEL_ARGS" ]; then
  # With labels
  gh issue create \
    --title "$ARGUMENTS" \
    --body-file /tmp/issue-body.md \
    $LABEL_ARGS \
    --assignee @me
else
  # Without labels (safe fallback)
  gh issue create \
    --title "$ARGUMENTS" \
    --body-file /tmp/issue-body.md \
    --assignee @me
fi

# Capture result
ISSUE_URL=$(gh issue list --author "@me" --limit 1 --json url -q '.[0].url')
ISSUE_NUMBER=$(gh issue list --author "@me" --limit 1 --json number -q '.[0].number')
```

---

### 8. Post-Creation Actions

**STEP 1: Return result**
```bash
echo "✅ Issue created successfully!"
echo "🔗 URL: $ISSUE_URL"
echo "📝 Issue #$ISSUE_NUMBER"
```

**STEP 2: Update TodoWrite (for Task types)**
```bash
if [ "$DETECTED_TYPE" = "Task" ]; then
  # Add issue reference to TodoWrite
  echo "📋 Adding issue to TodoWrite..."
  # TodoWrite integration here
fi
```

**STEP 3: Verify git state unchanged (Safety verification)**
```bash
# Verify no changes were made
FINAL_STAGED=$(git diff --staged --name-only | wc -l)
FINAL_UNSTAGED=$(git diff --name-only | wc -l)

if [ "$FINAL_STAGED" -eq "$STAGED_COUNT" ] && [ "$FINAL_UNSTAGED" -eq "$UNSTAGED_COUNT" ]; then
  echo "✅ Git state verification passed - no modifications made"
else
  echo "⚠️ WARNING: Git state changed unexpectedly!"
  echo "  Before: Staged=$STAGED_COUNT, Unstaged=$UNSTAGED_COUNT"
  echo "  After: Staged=$FINAL_STAGED, Unstaged=$FINAL_UNSTAGED"
fi
```

---

## Usage Examples

### Close Issue (Most Recent)
```
User: "/github:issue 이슈 닫아줘"

→ Detect close keyword: "닫아줘" ✅
→ Get most recent issue: #9
→ Analyze changes (READ-ONLY): git diff main...HEAD
→ Close with completion summary:
  ✅ 작업 완료

  📊 변경 내용:
  - 3개 커밋, 5개 파일 변경
  - src/auth.service.ts
  - src/auth.controller.ts

  📝 최근 커밋:
  - feat: 사용자 인증 추가
  - fix: 토큰 검증 로직 수정

  🤖 Closed via Claude Code
→ Issue #9 closed ✅
```

### Close Specific Issue
```
User: "/github:issue 9번 닫아줘"

→ Extract issue number: #9
→ Analyze work done (git diff)
→ Close with summary
✅ Done
```

### Bug Report with Git State
```
User: "auth.service.ts:45 keeps throwing token error..."
[Working on fix, files are staged]

User: "/github:issue 토큰 만료 에러 수정"

→ Git state analysis (READ-ONLY):
  - Branch: fix/token-expiry
  - Staged: 2 files (auth.service.ts, auth.controller.ts)
  - Unstaged: 1 file (README.md)

→ Type detection: Bug (from branch "fix/")
→ Label check: gh label list
  - Found: "bug" ✅

→ Collect error context from conversation + git diff
→ User confirmation:
  📋 Issue Summary:
  Type: Bug
  Branch: fix/token-expiry
  Files: auth.service.ts, auth.controller.ts

  ⚠️ Your staged changes are safe - won't be modified

  Proceed? [Y]

→ Create issue with context
→ Verify git state unchanged ✅
→ Issue #10 created: https://github.com/user/repo/issues/10
```

### Feature Request with Work in Progress
```
User: "/github:issue 사용자 알림 시스템 추가"

→ Git state analysis:
  - Branch: feature/user-notifications
  - Work in progress: 5 staged, 3 unstaged, 2 untracked
  - 8 commits since main

→ Type detection: Feature (from branch "feature/")
→ Label check: "feature" not found → fallback "enhancement" ✅
→ Collect work context:
  - Files: notification.service.ts, notification.controller.ts, ...
  - Commits: "feat: notification service", "feat: email integration", ...

→ User confirmation
→ Create issue documenting current progress
→ Git state verified unchanged ✅
```

---

## Safety Measures & Skills Integration

### Skills Referenced:
1. **verification-before-completion** (`~/.claude/plugins/.../skills/verification-before-completion/SKILL.md`)
   - Evidence before claims
   - Run verification commands
   - Never assume state

2. **finishing-a-development-branch** (`~/.claude/plugins/.../skills/finishing-a-development-branch/SKILL.md`)
   - Verify tests before completion
   - Present structured options
   - Clean workflow

### Safety Checklist:
- ✅ **READ-ONLY git operations** (status, diff, log)
- ❌ **NO git modifications** (add, commit, push, checkout, merge, reset)
- ✅ **User confirmation** before issue creation
- ✅ **Git state verification** before and after
- ✅ **Fallback strategies** for labels, templates
- ✅ **Comprehensive metadata check** (labels, milestones, projects)
- ✅ **Error recovery** (save body to file if creation fails)

### Additional Safety Features:
- **Unsaved work warning**: Alert user about staged/unstaged changes
- **Branch protection**: Never switch branches or modify HEAD
- **State preservation**: Verify git state unchanged after execution
- **Graceful degradation**: Skip labels/metadata if unavailable
- **gh CLI check**: Verify gh installed before execution
- **Template fallback**: Use default if custom template missing
- **Failure recovery**: Save issue body to file for manual creation

---

## Integration Points

### With Other Commands:
- **After** work is done: `/github:issue` to document
- **Before** `/github:pr`: Create tracking issue first
- **With** TodoWrite: Auto-link issues to tasks

### With Skills:
- Follows `verification-before-completion` principles
- Can trigger `finishing-a-development-branch` for completion workflow
- Uses `systematic-debugging` for bug context collection

---

## Execution Flow Summary

### Flow A: Issue Close
```
Input: /github:issue "이슈 닫아줘"
  ↓
[1] Detect close keywords ✅
  ↓
[2] Extract issue number or get most recent
  ↓
[3] Analyze work done (READ-ONLY git diff)
  ↓
[4] Generate completion summary
  ↓
[5] Execute gh issue close with comment
  ↓
[6] Return confirmation
```

### Flow B: Issue Creation (Safe)
```
Input: /github:issue "새로운 기능 추가"
  ↓
[1] Safety: Verify git repository
  ↓
[2] READ-ONLY: Collect git state (status, diff, log)
  ↓
[3] Safety: Warn about unsaved changes
  ↓
[4] Analysis: Detect type from branch/keywords/conversation
  ↓
[5] Metadata: Check labels, milestones, projects (gh commands)
  ↓
[6] Intelligent: Map labels with fallback strategy
  ↓
[7] Collection: Gather context from conversation + git state
  ↓
[8] Template: Load or use default format
  ↓
[9] SAFETY GATE: Present summary, request confirmation
  ↓
[10] Execution: Create issue (only if confirmed)
  ↓
[11] Verification: Check git state unchanged
  ↓
[12] Return: Issue URL + number + verification status
```

---

## Red Flags - STOP Execution

**Abort if:**
- Not in a git repository
- gh CLI not installed or not authenticated
- User declines confirmation
- Any git WRITE operation attempted
- Git state verification fails

**Never:**
- Modify git state (add, commit, push, checkout, etc.)
- Proceed without user confirmation
- Assume labels exist without checking
- Claim success without verification
- Skip safety checks for "efficiency"

**Always:**
- Verify git repository first
- Use READ-ONLY git operations
- Check all metadata availability
- Request user confirmation
- Verify state unchanged after execution
- Provide evidence for all claims
