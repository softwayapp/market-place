#!/bin/bash
# SoftwayApp Marketplace Installer
# Quick install script for Claude Code plugin

set -e

PLUGIN_NAME="softwayapp-marketplace"
PLUGIN_DIR="$HOME/.claude/plugins/$PLUGIN_NAME"
REPO_URL="https://github.com/softwayapp/market-place.git"

echo "🚀 Installing SoftwayApp Development Marketplace..."
echo ""

# Remove existing installation
if [ -d "$PLUGIN_DIR" ]; then
    echo "📦 Removing existing installation..."
    rm -rf "$PLUGIN_DIR"
fi

# Clone repository
echo "⬇️  Downloading plugin..."
git clone --depth 1 "$REPO_URL" "$PLUGIN_DIR"

# Verify installation
if [ -f "$PLUGIN_DIR/.claude/plugin.json" ]; then
    echo ""
    echo "✅ Installation successful!"
    echo ""
    echo "📍 Installed to: $PLUGIN_DIR"
    echo ""
    echo "📦 Available features:"
    echo "   • 32+ Skills (Backend, Frontend, DevOps, Security, Quality, Documentation)"
    echo "   • 4 Commands (/font, /analyze, /test, /deploy)"
    echo "   • 3 Agents (Backend Architect, Performance Engineer, Security Auditor)"
    echo ""
    echo "🎯 Next steps:"
    echo "   1. Restart Claude Code"
    echo "   2. Use commands: /font, /analyze, /test, /deploy"
    echo "   3. Explore skills by category in ~/.claude/plugins/$PLUGIN_NAME/skills/"
    echo ""
    echo "📚 Documentation: https://github.com/softwayapp/market-place"
else
    echo "❌ Installation failed. Please check your internet connection and try again."
    exit 1
fi
