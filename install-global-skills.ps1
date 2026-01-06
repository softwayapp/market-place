# Install all marketplace skills and commands to global Claude Code directory

$ErrorActionPreference = "Stop"

$SKILLS_DIR = "$env:USERPROFILE\.claude\skills"
$COMMANDS_DIR = "$env:USERPROFILE\.claude\commands"
$MARKETPLACE_DIR = $PSScriptRoot

Write-Host "🚀 Installing marketplace skills and commands to global Claude Code directory..." -ForegroundColor Cyan
Write-Host ""

# Create directories if they don't exist
New-Item -ItemType Directory -Force -Path $SKILLS_DIR | Out-Null
New-Item -ItemType Directory -Force -Path $COMMANDS_DIR | Out-Null

# Copy all skills
Write-Host "📦 Copying skills..." -ForegroundColor Cyan
@("backend", "frontend", "devops", "security", "quality", "documentation") | ForEach-Object {
    $categoryPath = Join-Path $MARKETPLACE_DIR "skills\$_"
    if (Test-Path $categoryPath) {
        Get-ChildItem -Path $categoryPath -Directory | ForEach-Object {
            Copy-Item -Path $_.FullName -Destination $SKILLS_DIR -Recurse -Force
        }
    }
}

# Copy all commands
Write-Host "📋 Copying commands..." -ForegroundColor Cyan
Get-ChildItem -Path (Join-Path $MARKETPLACE_DIR "commands") -Filter "*.md" | ForEach-Object {
    Copy-Item -Path $_.FullName -Destination $COMMANDS_DIR -Force
}

# Count installed items
$skillCount = (Get-ChildItem -Path $SKILLS_DIR -Recurse -Filter "SKILL.md").Count
$commandCount = (Get-ChildItem -Path $COMMANDS_DIR -Filter "*.md").Count

Write-Host ""
Write-Host "✅ Installation complete!" -ForegroundColor Green
Write-Host ""
Write-Host "📍 Installed $skillCount skills to: $SKILLS_DIR" -ForegroundColor White
Write-Host "📍 Installed $commandCount commands to: $COMMANDS_DIR" -ForegroundColor White
Write-Host ""
Write-Host "📦 Available commands:" -ForegroundColor Cyan
Write-Host "   • /font - Download Pretendard fonts"
Write-Host "   • /analyze - Code quality analysis"
Write-Host "   • /test - Run tests with coverage"
Write-Host "   • /deploy - Deployment automation"
Write-Host ""
Write-Host "📦 Available skills include:" -ForegroundColor Cyan
Write-Host "   • @api-generator, @clean-architecture-scaffolder, @database-migration"
Write-Host "   • @font-download, @component-generator, @accessibility-audit"
Write-Host "   • @ci-cd-setup, @docker-optimizer, @k8s-deployment"
Write-Host "   • @vulnerability-scan, @code-security-audit, @secrets-detection"
Write-Host "   • @test-generator, @e2e-test-builder, @coverage-analyzer"
Write-Host ""
Write-Host "🎯 Ready to use - no restart needed!" -ForegroundColor Yellow
