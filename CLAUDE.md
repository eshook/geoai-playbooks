# CLAUDE.md — Development Guidance for AI Agents

## Project Overview

This repository contains two aligned Quarto books about GeoAI:
- **GeoAI in a Meeting** (Decision Makers) — `books/decision-makers/`
- **GeoAI in a Day** (Developers) — `books/developers/`

The books share vocabulary, procedures, and cross-references via `shared/`.

## Repository Structure

```
geoai-playbooks/
├── books/
│   ├── decision-makers/     # Decision Maker playbook (Quarto book)
│   │   ├── _quarto.yml      # Book configuration
│   │   ├── index.qmd        # Book landing page
│   │   └── *.qmd            # Chapters (thin wrappers that include shared content or contain book-specific content)
│   └── developers/          # Developer playbook (Quarto book)
│       ├── _quarto.yml      # Book configuration
│       ├── index.qmd        # Book landing page
│       └── *.qmd            # Chapters
├── shared/
│   ├── glossary.yml              # SOURCE OF TRUTH: terminology
│   ├── procedures.yml            # SOURCE OF TRUTH: procedures
│   ├── cross-references.yml      # Maps chapters between books
│   ├── _brainstorming-content.qmd  # Shared content (included by both books)
│   ├── _glossary-content.qmd       # GENERATED — do not edit (from glossary.yml)
│   ├── _procedures-content.qmd     # GENERATED — do not edit (from procedures.yml)
│   └── templates/                   # Chapter templates for new content
├── .github/workflows/
│   └── publish.yml          # CI: generate → validate → build → deploy
├── scripts/
│   ├── build.sh                    # Full local build (generate + validate + render)
│   ├── validate.sh                 # Validate structure, sync, includes, cross-refs
│   └── generate-shared-content.py  # Generate .qmd files from YAML sources
├── index.html               # Landing page for GitHub Pages
└── _book/                   # Build output (gitignored)
```

## How Shared Content Works

There are two patterns for shared content. Know which one you're using:

### Pattern 1: YAML → Generated QMD (glossary, procedures)

```
glossary.yml  ──[generate-shared-content.py]──►  _glossary-content.qmd
                                                       ▲
                                                       │ {{< include >}}
                                            appendix-glossary.qmd (both books)
```

- **Edit the `.yml` file** (the source of truth)
- **Run `python scripts/generate-shared-content.py`** to regenerate the `.qmd`
- **Never edit `_glossary-content.qmd` or `_procedures-content.qmd` directly** — they will be overwritten
- CI runs the generator automatically before every build

### Pattern 2: Shared QMD Include (brainstorming)

```
shared/_brainstorming-content.qmd
       ▲
       │ {{< include >}}
brainstorming.qmd (both books — thin wrappers with only YAML frontmatter)
```

- **Edit `shared/_brainstorming-content.qmd`** directly
- The book-level `brainstorming.qmd` files are just wrappers — don't add content to them

## Brainstorming Guide

Both books include `brainstorming.qmd` as a shared pre-chapter with 150+ organizational planning questions across 12 domains. Each question is tagged by C-suite role (CEO, CFO, CSO, CTO, CGO) and organizational level (Executive, Senior Manager, Middle Manager, Individual Contributor). Use these questions as a roadmap for content generation — each question can drive a section or subsection in the main chapters.

The 12 brainstorming domains are:
1. Why GeoAI, Why Now, Why Us?
2. Organizational Identity and GeoAI Ambition
3. Data: The Foundation of Everything
4. Models: Build, Buy, Fine-Tune, or Prompt?
5. Governance and Guardrails
6. Responsible AI: Ethics in the Geospatial Context
7. Talent, Culture, and Organizational Change
8. Infrastructure, Compute, and Cloud
9. Partnerships, Procurement, and the Vendor Landscape
10. Risk, Failure, and Incident Planning
11. Measuring Success and Communicating Value
12. The Horizon: What is Coming Next?

## Key Rules for Editing

1. **Always keep both books aligned.** If you add a chapter to one book that has a strategic/operational counterpart, add the corresponding chapter to the other book.

2. **Update cross-references.** When adding chapters, update `shared/cross-references.yml` with the mapping between the two books.

3. **Use shared glossary.** New terms go in `shared/glossary.yml` with BOTH `context_decision_maker` and `context_developer` fields. Then run `python scripts/generate-shared-content.py` to regenerate the `.qmd`.

4. **Use shared procedures.** Cross-cutting procedures go in `shared/procedures.yml` with both `strategic_summary` and `operational_steps`. Then run `python scripts/generate-shared-content.py`.

5. **Use templates.** When creating new chapters, start from `shared/templates/chapter-decision-maker.qmd` or `shared/templates/chapter-developer.qmd`.

6. **Update `_quarto.yml`.** After adding a new `.qmd` chapter file, add it to the `chapters:` list in the corresponding book's `_quarto.yml`.

7. **Alignment Point callouts.** Every chapter should have a callout linking to its counterpart in the other book.

## Build Commands

```bash
# Full build (generate shared content → validate → render both books)
bash scripts/build.sh

# Just validate (no build)
bash scripts/validate.sh

# Just regenerate shared .qmd files from YAML
python scripts/generate-shared-content.py

# Build a single book (after generating shared content)
cd books/decision-makers && quarto render
cd books/developers && quarto render
```

## CI/CD and GitHub Pages

The repository uses GitHub Actions (`.github/workflows/publish.yml`) to automatically:

1. Generate shared `.qmd` content from YAML sources
2. Validate structure, sync, and cross-references
3. Build both Quarto books
4. Deploy the combined output to GitHub Pages

The deployed site includes a landing page (`index.html`) linking to both books. **You do not need to build locally** — just push your changes and the CI pipeline handles the rest.

If you modify the site structure (e.g., add a third book), update the workflow's "Assemble site" step and the `index.html` landing page accordingly.

## What the Validator Checks

`scripts/validate.sh` catches:
- Missing required files
- Chapters listed in `_quarto.yml` that don't exist as files
- Cross-reference entries that point to nonexistent chapters
- Glossary terms in YAML that are missing from the generated `.qmd`
- Procedure titles in YAML that are missing from the generated `.qmd`
- Broken `{{< include >}}` paths in chapter files

## Content Conventions

- **Decision Maker chapters** focus on: Key Questions, Frameworks, Organizational Considerations, Next Steps
- **Developer chapters** focus on: Context (link to strategy), Procedures, Code Examples, Checklists
- Code examples use Python with `#| eval: false` (not executed during build)
- Use Mermaid diagrams for workflows: `` `{mermaid}` `` blocks
- Use Quarto callouts for alignment points: `::: {.callout-tip}`

## Adding a New Topic (Step-by-Step)

1. Copy the appropriate template from `shared/templates/`
2. Create the `.qmd` file in the correct book directory
3. Create the counterpart `.qmd` in the other book directory
4. Add both files to their respective `_quarto.yml` chapter lists
5. Add a mapping to `shared/cross-references.yml`
6. Add any new terms to `shared/glossary.yml`
7. Add any new procedures to `shared/procedures.yml`
8. Run `python scripts/generate-shared-content.py` to regenerate `.qmd` files
9. Run `bash scripts/validate.sh` to check your work
