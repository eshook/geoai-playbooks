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
│   │   └── *.qmd            # Chapters
│   └── developers/          # Developer playbook (Quarto book)
│       ├── _quarto.yml      # Book configuration
│       ├── index.qmd        # Book landing page
│       └── *.qmd            # Chapters
├── shared/
│   ├── glossary.yml         # Single source of truth for terminology
│   ├── procedures.yml       # Shared procedures (strategic + operational)
│   ├── cross-references.yml # Maps chapters between the two books
│   ├── _glossary-content.qmd   # Includable glossary (Quarto include)
│   ├── _procedures-content.qmd # Includable procedures (Quarto include)
│   └── templates/           # Chapter templates for new content
├── scripts/
│   ├── build.sh             # Build both books
│   └── validate.sh          # Validate structure and cross-references
└── _book/                   # Build output (gitignored)
```

## Key Rules for Editing

1. **Always keep both books aligned.** If you add a chapter to one book that has a strategic/operational counterpart, add the corresponding chapter to the other book.

2. **Update cross-references.** When adding chapters, update `shared/cross-references.yml` with the mapping between the two books.

3. **Use shared glossary.** New terms must go in `shared/glossary.yml` with BOTH `context_decision_maker` and `context_developer` fields. Then update `shared/_glossary-content.qmd`.

4. **Use shared procedures.** Cross-cutting procedures go in `shared/procedures.yml` with both `strategic_summary` and `operational_steps`. Then update `shared/_procedures-content.qmd`.

5. **Use templates.** When creating new chapters, start from `shared/templates/chapter-decision-maker.qmd` or `shared/templates/chapter-developer.qmd`.

6. **Update `_quarto.yml`.** After adding a new `.qmd` chapter file, add it to the `chapters:` list in the corresponding book's `_quarto.yml`.

7. **Alignment Point callouts.** Every chapter should have a callout linking to its counterpart in the other book.

## Build Commands

```bash
# Build both books
bash scripts/build.sh

# Validate structure
bash scripts/validate.sh

# Build a single book
cd books/decision-makers && quarto render
cd books/developers && quarto render
```

## Content Conventions

- **Decision Maker chapters** focus on: Key Questions, Frameworks, Organizational Considerations, Next Steps
- **Developer chapters** focus on: Context (link to strategy), Procedures, Code Examples, Checklists
- Code examples use Python with `#| eval: false` (not executed during build)
- Use Mermaid diagrams for workflows: ````{mermaid}` blocks
- Use Quarto callouts for alignment points: `::: {.callout-tip}`

## Adding a New Topic (Step-by-Step)

1. Copy the appropriate template from `shared/templates/`
2. Create the `.qmd` file in the correct book directory
3. Create the counterpart `.qmd` in the other book directory
4. Add both files to their respective `_quarto.yml` chapter lists
5. Add a mapping to `shared/cross-references.yml`
6. Add any new terms to `shared/glossary.yml` and update `_glossary-content.qmd`
7. Add any new procedures to `shared/procedures.yml` and update `_procedures-content.qmd`
8. Run `bash scripts/validate.sh` to check your work
