#!/bin/bash
# Install all marketplace skills and commands to global Claude Code directory

set -e

SKILLS_DIR="$HOME/.claude/skills"
COMMANDS_DIR="$HOME/.claude/commands"
REPO_URL="https://github.com/softwayapp/market-place.git"
TEMP_DIR="/tmp/market-place-temp"

echo "🚀 Installing marketplace skills and commands to global Claude Code directory..."
echo ""

# Create directories if they don't exist
mkdir -p "$SKILLS_DIR"
mkdir -p "$COMMANDS_DIR"

# Clone repository to temp directory
echo "⬇️  Downloading marketplace..."
if [ -d "$TEMP_DIR" ]; then
    rm -rf "$TEMP_DIR"
fi

git clone --depth 1 --quiet "$REPO_URL" "$TEMP_DIR" 2>&1 | grep -v "Cloning into" || true

if [ ! -d "$TEMP_DIR/skills" ]; then
    echo "❌ Failed to download marketplace. Please check your internet connection and git installation."
    echo "   You can also install manually by cloning: $REPO_URL"
    exit 1
fi

# Copy all skills
echo "📦 Copying skills..."
for category in backend frontend devops security quality documentation; do
    if [ -d "$TEMP_DIR/skills/$category" ]; then
        for skill_dir in "$TEMP_DIR/skills/$category"/*; do
            if [ -d "$skill_dir" ]; then
                skill_name=$(basename "$skill_dir")
                rm -rf "$SKILLS_DIR/$skill_name" 2>/dev/null || true
                cp -r "$skill_dir" "$SKILLS_DIR/$skill_name"
            fi
        done
    fi
done

# Copy all commands (including subdirectories)
echo "📋 Copying commands..."
if [ -d "$TEMP_DIR/commands" ]; then
    # Copy all .md files in commands directory
    find "$TEMP_DIR/commands" -maxdepth 1 -name "*.md" -type f -exec cp {} "$COMMANDS_DIR/" \; 2>/dev/null || true

    # Copy all subdirectories (github, init, etc.)
    for subdir in "$TEMP_DIR/commands"/*; do
        if [ -d "$subdir" ]; then
            subdir_name=$(basename "$subdir")
            rm -rf "$COMMANDS_DIR/$subdir_name" 2>/dev/null || true
            cp -r "$subdir" "$COMMANDS_DIR/$subdir_name"
        fi
    done
fi

# Clean up temp directory
echo "🧹 Cleaning up..."
rm -rf "$TEMP_DIR"

# Count installed items
SKILL_COUNT=$(find "$SKILLS_DIR" -name "SKILL.md" -type f 2>/dev/null | wc -l)
COMMAND_COUNT=$(find "$COMMANDS_DIR" -name "*.md" -type f 2>/dev/null | wc -l)

echo ""
echo "✅ Installation complete!"
echo ""
echo "📍 Installed $SKILL_COUNT skills to: $SKILLS_DIR"
echo "📍 Installed $COMMAND_COUNT commands to: $COMMANDS_DIR"
echo ""
echo "📦 Available commands:"
echo "   • /font - Download Pretendard fonts"
echo "   • /analyze - Code quality analysis"
echo "   • /test - Run tests with coverage"
echo "   • /deploy - Deployment automation"
echo "   • /init:expo, /init:next, /init:react - Project initialization"
echo "   • /github:issue, /github:pr - GitHub operations"
echo ""
echo "📦 Available skills include:"
echo "   • @api-generator, @clean-architecture-scaffolder, @database-migration"
echo "   • @font-download, @component-generator, @accessibility-audit"
echo "   • @ci-cd-setup, @docker-optimizer, @k8s-deployment"
echo "   • @vulnerability-scan, @code-security-audit, @secrets-detection"
echo "   • @test-generator, @e2e-test-builder, @coverage-analyzer"
echo ""
echo "🎯 Ready to use - no restart needed!"
echo ""
echo "Try it now: Type '/font' or '/init:expo' or '@font-download' in Claude Code"
