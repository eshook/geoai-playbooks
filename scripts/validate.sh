#!/usr/bin/env bash
# =============================================================================
# Validation script for GeoAI Playbooks
# Checks structure, cross-references, shared content sync, and include paths
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

ERRORS=0

echo "=== Validating GeoAI Playbooks ==="

# ---- Check required files exist ----
echo ""
echo "--- Checking required files ---"
REQUIRED_FILES=(
    "shared/glossary.yml"
    "shared/procedures.yml"
    "shared/cross-references.yml"
    "shared/_glossary-content.qmd"
    "shared/_procedures-content.qmd"
    "shared/_brainstorming-content.qmd"
    "books/decision-makers/_quarto.yml"
    "books/decision-makers/index.qmd"
    "books/developers/_quarto.yml"
    "books/developers/index.qmd"
    "scripts/generate-shared-content.py"
)

for f in "${REQUIRED_FILES[@]}"; do
    if [[ -f "$PROJECT_ROOT/$f" ]]; then
        echo "  OK: $f"
    else
        echo "  MISSING: $f"
        ERRORS=$((ERRORS + 1))
    fi
done

# ---- Check that all chapters referenced in _quarto.yml exist ----
echo ""
echo "--- Checking chapter files ---"
for book in decision-makers developers; do
    BOOK_DIR="$PROJECT_ROOT/books/$book"
    grep -oE '[a-z-]+\.qmd' "$BOOK_DIR/_quarto.yml" | sort -u | while read -r qmd; do
        if [[ -f "$BOOK_DIR/$qmd" ]]; then
            echo "  OK: books/$book/$qmd"
        else
            echo "  MISSING: books/$book/$qmd"
        fi
    done
done

# ---- Check cross-reference map entries have matching files ----
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

# ---- Check YAML↔QMD sync (glossary and procedures) ----
echo ""
echo "--- Checking YAML-to-QMD sync ---"
if command -v python3 &>/dev/null; then
    python3 -c "
import yaml, sys, os

root = '$PROJECT_ROOT'
errors = 0

# Check glossary: every term in YAML must appear in the generated .qmd
with open(os.path.join(root, 'shared/glossary.yml')) as f:
    glossary = yaml.safe_load(f)
with open(os.path.join(root, 'shared/_glossary-content.qmd')) as f:
    glossary_qmd = f.read()

for term in glossary['terms']:
    if term['term'] not in glossary_qmd:
        print(f'  OUT OF SYNC: glossary term \"{term[\"term\"]}\" missing from _glossary-content.qmd')
        errors += 1

# Check procedures: every procedure title in YAML must appear in the generated .qmd
with open(os.path.join(root, 'shared/procedures.yml')) as f:
    procedures = yaml.safe_load(f)
with open(os.path.join(root, 'shared/_procedures-content.qmd')) as f:
    procedures_qmd = f.read()

for proc in procedures['procedures']:
    if proc['title'] not in procedures_qmd:
        print(f'  OUT OF SYNC: procedure \"{proc[\"title\"]}\" missing from _procedures-content.qmd')
        errors += 1

if errors == 0:
    print('  OK: glossary.yml ↔ _glossary-content.qmd')
    print('  OK: procedures.yml ↔ _procedures-content.qmd')

sys.exit(errors)
" || ERRORS=$((ERRORS + $?))
else
    echo "  SKIP: python3 not available for sync validation"
fi

# ---- Check include paths resolve to real files ----
echo ""
echo "--- Checking include paths ---"
INCLUDE_ERRORS=0
grep -r '{{< include' "$PROJECT_ROOT/books/" --include='*.qmd' -h | \
    sed 's/.*{{< include \(.*\) >}}.*/\1/' | \
    sort -u | while read -r rel_path; do
    # Include paths are relative to the file that contains them.
    # All our includes use ../../shared/ so resolve from any book dir.
    resolved="$PROJECT_ROOT/books/decision-makers/$rel_path"
    if [[ -f "$resolved" ]]; then
        echo "  OK: $rel_path"
    else
        echo "  BROKEN INCLUDE: $rel_path"
    fi
done

# ---- Summary ----
echo ""
if [[ $ERRORS -gt 0 ]]; then
    echo "=== Validation FAILED with $ERRORS error(s) ==="
    exit 1
else
    echo "=== Validation PASSED ==="
fi
