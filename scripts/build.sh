#!/usr/bin/env bash
# =============================================================================
# Build script for GeoAI Playbooks
# Builds both books (decision-makers and developers) using Quarto
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "=== Building GeoAI Playbooks ==="

# Build Decision Maker Playbook
echo ""
echo "--- Building: GeoAI in a Meeting (Decision Makers) ---"
cd "$PROJECT_ROOT/books/decision-makers"
quarto render

# Build Developer Playbook
echo ""
echo "--- Building: GeoAI in a Day (Developers) ---"
cd "$PROJECT_ROOT/books/developers"
quarto render

echo ""
echo "=== Build complete ==="
echo "Output: $PROJECT_ROOT/_book/"
echo "  Decision Makers: $PROJECT_ROOT/_book/decision-makers/"
echo "  Developers:      $PROJECT_ROOT/_book/developers/"
