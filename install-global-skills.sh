#!/bin/bash
# Install all marketplace skills to global ~/.claude/skills/ directory

SKILLS_DIR="$HOME/.claude/skills"
MARKETPLACE_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "🚀 Installing marketplace skills to global Claude Code skills directory..."
echo ""

# Create skills directory if it doesn't exist
mkdir -p "$SKILLS_DIR"

# Copy all skills
echo "📦 Copying skills..."
cp -r "$MARKETPLACE_DIR/skills/backend/"* "$SKILLS_DIR/" 2>/dev/null || true
cp -r "$MARKETPLACE_DIR/skills/frontend/"* "$SKILLS_DIR/" 2>/dev/null || true
cp -r "$MARKETPLACE_DIR/skills/devops/"* "$SKILLS_DIR/" 2>/dev/null || true
cp -r "$MARKETPLACE_DIR/skills/security/"* "$SKILLS_DIR/" 2>/dev/null || true
cp -r "$MARKETPLACE_DIR/skills/quality/"* "$SKILLS_DIR/" 2>/dev/null || true
cp -r "$MARKETPLACE_DIR/skills/documentation/"* "$SKILLS_DIR/" 2>/dev/null || true

# Count installed skills
SKILL_COUNT=$(find "$SKILLS_DIR" -name "SKILL.md" | wc -l)

echo ""
echo "✅ Installation complete!"
echo ""
echo "📍 Installed $SKILL_COUNT skills to: $SKILLS_DIR"
echo ""
echo "📦 Available skills include:"
echo "   • API Generator, Clean Architecture, CQRS, Database Migration"
echo "   • Font Downloader, Component Generator, Accessibility Audit"
echo "   • CI/CD Setup, Docker Optimizer, K8s Deployment"
echo "   • Vulnerability Scanner, Security Audit, Secrets Detection"
echo "   • Test Generator, E2E Builder, Coverage Analyzer"
echo "   • API Docs, README Generator, Changelog, JSDoc"
echo ""
echo "🎯 Skills are now ready to use - no restart needed!"
echo "   Try: @api-generator, @font-download, @test-generator"
