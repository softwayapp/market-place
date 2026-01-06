# Install all marketplace skills and commands to global Claude Code directory

$ErrorActionPreference = "Continue"  # Changed to Continue to handle git output

$SKILLS_DIR = "$env:USERPROFILE\.claude\skills"
$COMMANDS_DIR = "$env:USERPROFILE\.claude\commands"
$REPO_URL = "https://github.com/softwayapp/market-place.git"
$TEMP_DIR = "$env:TEMP\market-place-temp"

Write-Host "🚀 Installing marketplace skills and commands to global Claude Code directory..." -ForegroundColor Cyan
Write-Host ""

# Create directories if they don't exist
New-Item -ItemType Directory -Force -Path $SKILLS_DIR | Out-Null
New-Item -ItemType Directory -Force -Path $COMMANDS_DIR | Out-Null

# Clone repository to temp directory
Write-Host "⬇️  Downloading marketplace..." -ForegroundColor Cyan
if (Test-Path $TEMP_DIR) {
    Remove-Item -Path $TEMP_DIR -Recurse -Force -ErrorAction SilentlyContinue
}

# Clone with progress suppressed
$null = git clone --depth 1 --quiet $REPO_URL $TEMP_DIR 2>&1

if (-not (Test-Path "$TEMP_DIR\skills")) {
    Write-Host "❌ Failed to download marketplace. Please check your internet connection and git installation." -ForegroundColor Red
    Write-Host "   You can also install manually by cloning: $REPO_URL" -ForegroundColor Yellow
    exit 1
}

# Copy all skills
Write-Host "📦 Copying skills..." -ForegroundColor Cyan
$categories = @("backend", "frontend", "devops", "security", "quality", "documentation")
$skillsCopied = 0

foreach ($category in $categories) {
    $categoryPath = Join-Path $TEMP_DIR "skills\$category"
    if (Test-Path $categoryPath) {
        Get-ChildItem -Path $categoryPath -Directory -ErrorAction SilentlyContinue | ForEach-Object {
            $destPath = Join-Path $SKILLS_DIR $_.Name
            if (Test-Path $destPath) {
                Remove-Item -Path $destPath -Recurse -Force -ErrorAction SilentlyContinue
            }
            Copy-Item -Path $_.FullName -Destination $destPath -Recurse -Force -ErrorAction SilentlyContinue
            $skillsCopied++
        }
    }
}

# Copy all commands (including subdirectories)
Write-Host "📋 Copying commands..." -ForegroundColor Cyan
$commandsCopied = 0
$commandsPath = Join-Path $TEMP_DIR "commands"

if (Test-Path $commandsPath) {
    # Copy all .md files in commands directory
    Get-ChildItem -Path $commandsPath -Filter "*.md" -ErrorAction SilentlyContinue | ForEach-Object {
        Copy-Item -Path $_.FullName -Destination $COMMANDS_DIR -Force -ErrorAction SilentlyContinue
        $commandsCopied++
    }

    # Copy all subdirectories (github, init, etc.)
    Get-ChildItem -Path $commandsPath -Directory -ErrorAction SilentlyContinue | ForEach-Object {
        $destDir = Join-Path $COMMANDS_DIR $_.Name
        if (Test-Path $destDir) {
            Remove-Item -Path $destDir -Recurse -Force -ErrorAction SilentlyContinue
        }
        Copy-Item -Path $_.FullName -Destination $destDir -Recurse -Force -ErrorAction SilentlyContinue
        $subCommandCount = (Get-ChildItem -Path $_.FullName -Filter "*.md" -Recurse).Count
        $commandsCopied += $subCommandCount
    }
}

# Clean up temp directory
Write-Host "🧹 Cleaning up..." -ForegroundColor Cyan
Remove-Item -Path $TEMP_DIR -Recurse -Force -ErrorAction SilentlyContinue

# Count installed items
$skillCount = (Get-ChildItem -Path $SKILLS_DIR -Recurse -Filter "SKILL.md" -ErrorAction SilentlyContinue).Count
$commandCount = (Get-ChildItem -Path $COMMANDS_DIR -Recurse -Filter "*.md" -ErrorAction SilentlyContinue).Count

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
Write-Host "   • /init:expo, /init:next, /init:react - Project initialization"
Write-Host "   • /github:issue, /github:pr - GitHub operations"
Write-Host ""
Write-Host "📦 Available skills include:" -ForegroundColor Cyan
Write-Host "   • @api-generator, @clean-architecture-scaffolder, @database-migration"
Write-Host "   • @font-download, @component-generator, @accessibility-audit"
Write-Host "   • @ci-cd-setup, @docker-optimizer, @k8s-deployment"
Write-Host "   • @vulnerability-scan, @code-security-audit, @secrets-detection"
Write-Host "   • @test-generator, @e2e-test-builder, @coverage-analyzer"
Write-Host ""
Write-Host "🎯 Ready to use - no restart needed!" -ForegroundColor Yellow
Write-Host ""
Write-Host "Try it now: Type '/font' or '/init:expo' or '@font-download' in Claude Code" -ForegroundColor Cyan
