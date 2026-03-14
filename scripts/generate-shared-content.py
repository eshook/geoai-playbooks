#!/usr/bin/env python3
"""
Generate Quarto-includable .qmd files from YAML source files.

This script is the single source of truth pipeline:
    glossary.yml    →  _glossary-content.qmd
    procedures.yml  →  _procedures-content.qmd

Run via:  python scripts/generate-shared-content.py
Called by: scripts/build.sh (before quarto render)
Called by: .github/workflows/publish.yml (CI)
"""

import sys
import textwrap
from pathlib import Path

try:
    import yaml
except ImportError:
    sys.exit("ERROR: PyYAML is required. Install with: pip install pyyaml")

SHARED_DIR = Path(__file__).resolve().parent.parent / "shared"


def generate_glossary():
    """Generate _glossary-content.qmd from glossary.yml."""
    src = SHARED_DIR / "glossary.yml"
    dst = SHARED_DIR / "_glossary-content.qmd"

    with open(src) as f:
        data = yaml.safe_load(f)

    lines = [
        "<!-- Generated from shared/glossary.yml by scripts/generate-shared-content.py -->",
        "<!-- DO NOT EDIT — edit glossary.yml and re-run the generator -->",
        "",
    ]

    for term in data["terms"]:
        definition = term["definition"].strip()
        lines.append(f"**{term['term']}**")
        lines.append(f": {definition}")
        lines.append("")

    dst.write_text("\n".join(lines) + "\n")
    print(f"  Generated {dst.relative_to(SHARED_DIR.parent)}")


def generate_procedures():
    """Generate _procedures-content.qmd from procedures.yml."""
    src = SHARED_DIR / "procedures.yml"
    dst = SHARED_DIR / "_procedures-content.qmd"

    with open(src) as f:
        data = yaml.safe_load(f)

    lines = [
        "<!-- Generated from shared/procedures.yml by scripts/generate-shared-content.py -->",
        "<!-- DO NOT EDIT — edit procedures.yml and re-run the generator -->",
        "",
    ]

    for i, proc in enumerate(data["procedures"]):
        if i > 0:
            lines.append("---")
            lines.append("")

        lines.append(f"## {proc['title']}")
        lines.append("")

        summary = proc["strategic_summary"].strip()
        # Replace {{term:...}} references with bold text
        import re
        summary = re.sub(r"\{\{term:(.+?)\}\}", r"**\1**", summary)
        lines.append(f"**Strategic Summary:** {summary}")
        lines.append("")

        lines.append("**Operational Steps:**")
        lines.append("")
        for step in proc["operational_steps"]:
            step_text = re.sub(r"\{\{term:(.+?)\}\}", r"**\1**", step)
            lines.append(f"1. {step_text}")
        lines.append("")

    dst.write_text("\n".join(lines) + "\n")
    print(f"  Generated {dst.relative_to(SHARED_DIR.parent)}")


def main():
    print("Generating shared content from YAML sources...")
    generate_glossary()
    generate_procedures()
    print("Done.")


if __name__ == "__main__":
    main()
