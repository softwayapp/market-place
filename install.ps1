# SoftwayApp Marketplace Installer (Windows PowerShell)
# Quick install script for Claude Code plugin

$ErrorActionPreference = "Stop"

$PLUGIN_NAME = "softwayapp-marketplace"
$PLUGIN_DIR = "$env:USERPROFILE\.claude\plugins\$PLUGIN_NAME"
$REPO_URL = "https://github.com/softwayapp/market-place.git"

Write-Host "🚀 Installing SoftwayApp Development Marketplace..." -ForegroundColor Cyan
Write-Host ""

# Remove existing installation
if (Test-Path $PLUGIN_DIR) {
    Write-Host "📦 Removing existing installation..." -ForegroundColor Yellow
    Remove-Item -Path $PLUGIN_DIR -Recurse -Force
}

# Clone repository
Write-Host "⬇️  Downloading plugin..." -ForegroundColor Cyan
git clone --depth 1 $REPO_URL $PLUGIN_DIR

# Verify installation
if (Test-Path "$PLUGIN_DIR\.claude\plugin.json") {
    Write-Host ""
    Write-Host "✅ Installation successful!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📍 Installed to: $PLUGIN_DIR" -ForegroundColor White
    Write-Host ""
    Write-Host "📦 Available features:" -ForegroundColor Cyan
    Write-Host "   • 32+ Skills (Backend, Frontend, DevOps, Security, Quality, Documentation)"
    Write-Host "   • 4 Commands (/font, /analyze, /test, /deploy)"
    Write-Host "   • 3 Agents (Backend Architect, Performance Engineer, Security Auditor)"
    Write-Host ""
    Write-Host "🎯 Next steps:" -ForegroundColor Yellow
    Write-Host "   1. Restart Claude Code"
    Write-Host "   2. Use commands: /font, /analyze, /test, /deploy"
    Write-Host "   3. Explore skills by category in $PLUGIN_DIR\skills\"
    Write-Host ""
    Write-Host "📚 Documentation: https://github.com/softwayapp/market-place" -ForegroundColor Cyan
} else {
    Write-Host "❌ Installation failed. Please check your internet connection and try again." -ForegroundColor Red
    exit 1
}
