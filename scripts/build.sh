#!/usr/bin/env bash
# =============================================================================
# Build script for GeoAI Playbooks
# 1. Generates shared .qmd content from YAML sources
# 2. Validates structure
# 3. Builds both books using Quarto
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "=== Building GeoAI Playbooks ==="

# Step 1: Generate shared content from YAML sources
echo ""
echo "--- Generating shared content from YAML ---"
python3 "$SCRIPT_DIR/generate-shared-content.py"

# Step 2: Validate structure
echo ""
echo "--- Validating structure ---"
bash "$SCRIPT_DIR/validate.sh"

# Step 3: Build Decision Maker Playbook
echo ""
echo "--- Building: GeoAI in a Meeting (Decision Makers) ---"
cd "$PROJECT_ROOT/books/decision-makers"
quarto render

# Step 4: Build Developer Playbook
echo ""
echo "--- Building: GeoAI in a Day (Developers) ---"
cd "$PROJECT_ROOT/books/developers"
quarto render

echo ""
echo "=== Build complete ==="
echo "Output: $PROJECT_ROOT/_book/"
echo "  Decision Makers: $PROJECT_ROOT/_book/decision-makers/"
echo "  Developers:      $PROJECT_ROOT/_book/developers/"
