#!/bin/bash

# generate-catalog.sh - Generate marketplace catalog from skills

set -e

echo "📚 Generating Marketplace Catalog..."

CATALOG_FILE=".claude-plugin/catalog.json"
TEMP_FILE=$(mktemp)

# Initialize catalog
cat > "$TEMP_FILE" <<EOF
{
  "generated": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "version": "1.0.0",
  "categories": {},
  "skills": [],
  "statistics": {
    "totalSkills": 0,
    "byCategory": {},
    "byStatus": {
      "stable": 0,
      "beta": 0,
      "deprecated": 0
    }
  }
}
EOF

total_skills=0
declare -A category_count
declare -A status_count

# Process each skill
for skill_file in skills/*/*/SKILL.md; do
    if [ ! -f "$skill_file" ]; then
        continue
    fi

    skill_dir=$(dirname "$skill_file")
    category=$(basename "$(dirname "$skill_dir")")

    # Extract frontmatter
    frontmatter=$(sed -n '/^---$/,/^---$/p' "$skill_file" | sed '1d;$d')

    # Extract fields
    name=$(echo "$frontmatter" | grep "^name:" | cut -d: -f2- | sed 's/^ *//')
    description=$(echo "$frontmatter" | grep "^description:" | cut -d: -f2- | sed 's/^ *//')
    version=$(echo "$frontmatter" | grep "^version:" | cut -d: -f2- | sed 's/^ *//')
    author=$(echo "$frontmatter" | grep "^author:" | cut -d: -f2- | sed 's/^ *//')
    status=$(echo "$frontmatter" | grep "^status:" | cut -d: -f2- | sed 's/^ *//')
    tags=$(echo "$frontmatter" | grep "^tags:" | cut -d: -f2- | sed 's/^ *//')

    # Update counters
    total_skills=$((total_skills + 1))
    category_count[$category]=$((${category_count[$category]:-0} + 1))
    status_count[$status]=$((${status_count[$status]:-0} + 1))

    echo "  📝 $name ($category) - v$version"
done

# Update statistics in catalog
node -e "
const fs = require('fs');
const catalog = JSON.parse(fs.readFileSync('$TEMP_FILE', 'utf8'));

catalog.statistics.totalSkills = $total_skills;
catalog.statistics.byCategory = $(echo "${!category_count[@]}" | jq -R -s -c 'split(" ") | map(select(length > 0))' | jq -c '. as \$keys | reduce range(0; length) as \$i ({}; . + {(\$keys[\$i]): 0})');
catalog.statistics.byStatus = {
    stable: ${status_count[stable]:-0},
    beta: ${status_count[beta]:-0},
    deprecated: ${status_count[deprecated]:-0}
};

fs.writeFileSync('$CATALOG_FILE', JSON.stringify(catalog, null, 2));
console.log('✅ Catalog generated: $CATALOG_FILE');
" 2>/dev/null || {
    # Fallback if node is not available
    cp "$TEMP_FILE" "$CATALOG_FILE"
    echo "⚠️  Node.js not found, generated basic catalog"
}

rm -f "$TEMP_FILE"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 Catalog Statistics"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Total skills: $total_skills"
echo ""
echo "By category:"
for category in "${!category_count[@]}"; do
    echo "  - $category: ${category_count[$category]}"
done
echo ""
echo "By status:"
for status in "${!status_count[@]}"; do
    echo "  - $status: ${status_count[$status]}"
done
echo ""
echo "✨ Catalog generation complete!"
