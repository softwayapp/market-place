#!/bin/bash

# validate-skills.sh - Validate skill structure and metadata

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "🔍 Validating Skills..."
echo ""

# Counter for validation results
total_skills=0
valid_skills=0
invalid_skills=0

# Required frontmatter fields
REQUIRED_FIELDS=("name" "description" "version" "author" "category" "status")

# Validate a single SKILL.md file
validate_skill() {
    local skill_file=$1
    local skill_dir=$(dirname "$skill_file")
    local skill_name=$(basename "$skill_dir")

    echo "📝 Validating: $skill_name"

    # Check if file exists
    if [ ! -f "$skill_file" ]; then
        echo -e "${RED}❌ SKILL.md not found in $skill_dir${NC}"
        return 1
    fi

    # Check frontmatter exists
    if ! grep -q "^---" "$skill_file"; then
        echo -e "${RED}❌ Missing frontmatter in $skill_file${NC}"
        return 1
    fi

    # Extract frontmatter
    local frontmatter=$(sed -n '/^---$/,/^---$/p' "$skill_file" | sed '1d;$d')

    # Check required fields
    local missing_fields=()
    for field in "${REQUIRED_FIELDS[@]}"; do
        if ! echo "$frontmatter" | grep -q "^$field:"; then
            missing_fields+=("$field")
        fi
    done

    if [ ${#missing_fields[@]} -gt 0 ]; then
        echo -e "${RED}❌ Missing required fields: ${missing_fields[*]}${NC}"
        return 1
    fi

    # Validate version format (semver)
    local version=$(echo "$frontmatter" | grep "^version:" | cut -d: -f2 | tr -d ' ')
    if ! [[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo -e "${RED}❌ Invalid version format: $version (expected semver: X.Y.Z)${NC}"
        return 1
    fi

    # Check category is valid
    local category=$(echo "$frontmatter" | grep "^category:" | cut -d: -f2 | tr -d ' ')
    local valid_categories=("backend" "frontend" "devops" "security" "quality" "documentation")

    if [[ ! " ${valid_categories[@]} " =~ " ${category} " ]]; then
        echo -e "${YELLOW}⚠️  Invalid category: $category${NC}"
        echo "   Valid categories: ${valid_categories[*]}"
    fi

    # Check status is valid
    local status=$(echo "$frontmatter" | grep "^status:" | cut -d: -f2 | tr -d ' ')
    local valid_statuses=("beta" "stable" "deprecated")

    if [[ ! " ${valid_statuses[@]} " =~ " ${status} " ]]; then
        echo -e "${YELLOW}⚠️  Invalid status: $status${NC}"
        echo "   Valid statuses: ${valid_statuses[*]}"
    fi

    # Check for required sections
    local required_sections=("목적" "사용 시기" "작동 방식" "예제")
    for section in "${required_sections[@]}"; do
        if ! grep -q "## $section" "$skill_file"; then
            echo -e "${YELLOW}⚠️  Missing recommended section: $section${NC}"
        fi
    done

    # Check file size (warn if too large)
    local file_size=$(wc -c < "$skill_file")
    if [ $file_size -gt 50000 ]; then
        echo -e "${YELLOW}⚠️  Large file size: $file_size bytes (consider splitting)${NC}"
    fi

    echo -e "${GREEN}✅ Valid${NC}"
    return 0
}

# Find and validate all SKILL.md files
if [ -n "$1" ]; then
    # Validate specific skill
    if [ -f "$1/SKILL.md" ]; then
        validate_skill "$1/SKILL.md"
    elif [ -f "$1" ]; then
        validate_skill "$1"
    else
        echo -e "${RED}❌ Invalid path: $1${NC}"
        exit 1
    fi
else
    # Validate all skills
    for skill_file in skills/*/*/SKILL.md; do
        if [ -f "$skill_file" ]; then
            total_skills=$((total_skills + 1))

            if validate_skill "$skill_file"; then
                valid_skills=$((valid_skills + 1))
            else
                invalid_skills=$((invalid_skills + 1))
            fi

            echo ""
        fi
    done

    # Print summary
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📊 Validation Summary"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Total skills: $total_skills"
    echo -e "${GREEN}Valid skills: $valid_skills${NC}"
    if [ $invalid_skills -gt 0 ]; then
        echo -e "${RED}Invalid skills: $invalid_skills${NC}"
        exit 1
    else
        echo -e "${GREEN}All skills are valid! ✨${NC}"
    fi
fi
