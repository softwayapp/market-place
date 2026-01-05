#!/bin/bash

# sync-marketplace.sh - Sync marketplace with latest changes

set -e

echo "🔄 Syncing Marketplace..."
echo ""

# Validate all skills first
echo "Step 1: Validating skills..."
./scripts/validate-skills.sh

echo ""
echo "Step 2: Generating catalog..."
./scripts/generate-catalog.sh

echo ""
echo "Step 3: Updating plugin.json..."

# Update plugin.json with latest skill list
node -e "
const fs = require('fs');
const path = require('path');

const pluginPath = '.claude-plugin/plugin.json';
const plugin = JSON.parse(fs.readFileSync(pluginPath, 'utf8'));

// Scan all skills
const skills = [];
const categories = fs.readdirSync('skills');

categories.forEach(category => {
    const categoryPath = path.join('skills', category);
    if (fs.statSync(categoryPath).isDirectory()) {
        const skillDirs = fs.readdirSync(categoryPath);

        skillDirs.forEach(skillDir => {
            const skillPath = path.join(categoryPath, skillDir, 'SKILL.md');
            if (fs.existsSync(skillPath)) {
                const content = fs.readFileSync(skillPath, 'utf8');

                // Extract frontmatter
                const frontmatterMatch = content.match(/^---\n([\s\S]*?)\n---/);
                if (frontmatterMatch) {
                    const lines = frontmatterMatch[1].split('\n');
                    const metadata = {};

                    lines.forEach(line => {
                        const match = line.match(/^(\w+):\s*(.+)$/);
                        if (match) {
                            metadata[match[1]] = match[2].trim();
                        }
                    });

                    skills.push({
                        id: metadata.name || skillDir,
                        name: metadata.name || skillDir,
                        category: category,
                        path: path.join('skills', category, skillDir),
                        version: metadata.version || '0.0.0',
                        status: metadata.status || 'beta',
                        description: metadata.description || ''
                    });
                }
            }
        });
    }
});

// Update plugin.json
plugin.skills = skills;

// Update metadata
plugin.catalog = plugin.catalog || {};
plugin.catalog.lastUpdated = new Date().toISOString();
plugin.catalog.totalSkills = skills.length;

fs.writeFileSync(pluginPath, JSON.stringify(plugin, null, 2));
console.log('✅ Updated plugin.json with', skills.length, 'skills');
"

echo ""
echo "Step 4: Updating marketplace.json..."

node -e "
const fs = require('fs');

const marketplacePath = '.claude-plugin/marketplace.json';
const marketplace = JSON.parse(fs.readFileSync(marketplacePath, 'utf8'));

marketplace.catalog.lastUpdated = new Date().toISOString();
marketplace.metadata.updatedAt = new Date().toISOString();

fs.writeFileSync(marketplacePath, JSON.stringify(marketplace, null, 2));
console.log('✅ Updated marketplace.json');
"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✨ Sync Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Next steps:"
echo "  1. Review changes: git diff"
echo "  2. Commit: git add . && git commit -m 'chore: sync marketplace'"
echo "  3. Push: git push"
