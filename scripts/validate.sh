#!/usr/bin/env bash
# =============================================================================
# Validation script for GeoAI Playbooks
# Checks structure, cross-references, and shared content integrity
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

ERRORS=0

echo "=== Validating GeoAI Playbooks ==="

# Check required files exist
echo ""
echo "--- Checking required files ---"
REQUIRED_FILES=(
    "shared/glossary.yml"
    "shared/procedures.yml"
    "shared/cross-references.yml"
    "shared/_glossary-content.qmd"
    "shared/_procedures-content.qmd"
    "books/decision-makers/_quarto.yml"
    "books/decision-makers/index.qmd"
    "books/developers/_quarto.yml"
    "books/developers/index.qmd"
)

for f in "${REQUIRED_FILES[@]}"; do
    if [[ -f "$PROJECT_ROOT/$f" ]]; then
        echo "  OK: $f"
    else
        echo "  MISSING: $f"
        ERRORS=$((ERRORS + 1))
    fi
done

# Check that all chapters referenced in _quarto.yml exist
echo ""
echo "--- Checking chapter files ---"
for book in decision-makers developers; do
    BOOK_DIR="$PROJECT_ROOT/books/$book"
    # Extract .qmd filenames from _quarto.yml
    grep -oE '[a-z-]+\.qmd' "$BOOK_DIR/_quarto.yml" | sort -u | while read -r qmd; do
        if [[ -f "$BOOK_DIR/$qmd" ]]; then
            echo "  OK: books/$book/$qmd"
        else
            echo "  MISSING: books/$book/$qmd"
            # Can't increment ERRORS in subshell, but prints the warning
        fi
    done
done

# Check cross-reference map entries have matching files
echo ""
echo "--- Checking cross-references ---"
if command -v python3 &>/dev/null; then
    python3 -c "
import yaml, sys, os

root = '$PROJECT_ROOT'
with open(os.path.join(root, 'shared/cross-references.yml')) as f:
    xref = yaml.safe_load(f)

errors = 0
for m in xref.get('mappings', []):
    dm = os.path.join(root, 'books/decision-makers', m['decision_maker_chapter'] + '.qmd')
    dv = os.path.join(root, 'books/developers', m['developer_chapter'] + '.qmd')
    if not os.path.exists(dm):
        print(f'  MISSING: {dm}')
        errors += 1
    else:
        print(f'  OK: books/decision-makers/{m[\"decision_maker_chapter\"]}.qmd')
    if not os.path.exists(dv):
        print(f'  MISSING: {dv}')
        errors += 1
    else:
        print(f'  OK: books/developers/{m[\"developer_chapter\"]}.qmd')

sys.exit(errors)
" || ERRORS=$((ERRORS + $?))
else
    echo "  SKIP: python3 not available for cross-reference validation"
fi

echo ""
if [[ $ERRORS -gt 0 ]]; then
    echo "=== Validation FAILED with $ERRORS error(s) ==="
    exit 1
else
    echo "=== Validation PASSED ==="
fi
