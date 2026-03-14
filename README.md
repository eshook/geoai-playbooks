# GeoAI Playbooks

Two aligned Quarto books for adopting Geospatial AI (GeoAI) at your organization:

| Book | Audience | Focus |
|------|----------|-------|
| **GeoAI in a Meeting** | Decision Makers | Strategy, governance, risk, talent, investment |
| **GeoAI in a Day** | Developers | Data engineering, model lifecycle, deployment, responsible AI |

Both books open with a shared **Organizational Brainstorming & Planning Guide** — a comprehensive set of 150+ questions organized across 12 domains (from "Why GeoAI?" to "What's coming next?") that surface the issues organizations need to think through before populating the playbooks. Each question is framed from two perspectives: the **Boardroom** (CXO-level strategic concerns) and the **Bullpen** (developer/data-scientist operational realities).

The two books share a common glossary, procedures, and cross-references so that strategic decisions made by leadership are directly visible in the operational guidance developers follow.

## Quick Start

### Prerequisites

- [Quarto](https://quarto.org/docs/get-started/) (1.3+)
- Python 3.10+ (for code examples)

### Build

```bash
# Build both books
bash scripts/build.sh

# Validate structure and cross-references
bash scripts/validate.sh
```

Output goes to `_book/decision-makers/` and `_book/developers/`.

### Preview a Single Book

```bash
cd books/decision-makers && quarto preview
# or
cd books/developers && quarto preview
```

## Repository Structure

```
geoai-playbooks/
├── books/
│   ├── decision-makers/        # "GeoAI in a Meeting" playbook
│   │   ├── _quarto.yml
│   │   ├── index.qmd
│   │   ├── brainstorming.qmd   # Shared pre-chapter (150+ planning questions)
│   │   ├── strategy.qmd
│   │   ├── governance.qmd
│   │   ├── data-strategy.qmd
│   │   ├── risk.qmd
│   │   ├── talent.qmd
│   │   └── investment.qmd
│   └── developers/             # "GeoAI in a Day" playbook
│       ├── _quarto.yml
│       ├── index.qmd
│       ├── brainstorming.qmd   # Shared pre-chapter (150+ planning questions)
│       ├── getting-started.qmd
│       ├── data-engineering.qmd
│       ├── model-lifecycle.qmd
│       ├── deployment.qmd
│       ├── responsible-ai.qmd
│       └── tooling.qmd
├── shared/                     # Shared content between books
│   ├── glossary.yml            # Term definitions with dual context
│   ├── procedures.yml          # Procedures with strategic + operational views
│   ├── cross-references.yml    # Chapter mapping between books
│   ├── _glossary-content.qmd   # Quarto-includable glossary
│   ├── _procedures-content.qmd # Quarto-includable procedures
│   └── templates/              # Templates for new chapters
├── scripts/
│   ├── build.sh                # Build both books
│   └── validate.sh             # Validate structure integrity
├── CLAUDE.md                   # AI agent development guidance
└── README.md                   # This file
```

## How the Two Books Align

```
Decision Maker Playbook              Developer Playbook
========================              ==================
Brainstorming Guide        ◄──────►   Brainstorming Guide
(shared pre-chapter)                  (shared pre-chapter)

Strategy & Vision          ───────►   Getting Started
                                      (understand org strategy)

Governance Framework       ───────►   Model Lifecycle
                                      (navigate review gates)

Data Strategy              ───────►   Data Engineering
                                      (build within constraints)

Risk Management            ───────►   Responsible AI
                                      (implement risk thresholds)

Building GeoAI Teams       ───────►   Getting Started
                                      (understand your role)
```

Cross-references are tracked in `shared/cross-references.yml` and enforced by `scripts/validate.sh`.

## Shared Content

### Glossary (`shared/glossary.yml`)

Every term includes:
- `definition` — plain-language explanation
- `context_decision_maker` — why it matters for strategy
- `context_developer` — how it shows up in daily work

### Procedures (`shared/procedures.yml`)

Every procedure includes:
- `strategic_summary` — 2-3 sentence overview for leadership
- `operational_steps` — concrete actions for developers

### Cross-References (`shared/cross-references.yml`)

Maps each decision-maker chapter to its developer counterpart with a description of the relationship.

## Next Steps for AI Agents

See [CLAUDE.md](CLAUDE.md) for detailed development guidance. Here is a summary:

### Expanding Content

0. **Use the Brainstorming Guide as a roadmap.** The 150+ questions in `brainstorming.qmd` are organized into 12 domains. Each question is a potential section or subsection in the playbooks. AI agents should use these questions to drive content generation — pick a question, research it, and write the corresponding guidance in the appropriate chapter.

1. **Add depth to existing chapters.** Current chapters are frameworks with example content. Flesh out each section with organization-specific detail, more code examples, and real-world scenarios.

2. **Add new topic pairs.** Use the templates in `shared/templates/` to create new chapter pairs. Always create both the decision-maker and developer versions together.

3. **Expand the glossary.** Add new terms to `shared/glossary.yml` as you write content. Always include both context fields. Update `shared/_glossary-content.qmd` to match.

4. **Add more procedures.** As you identify cross-cutting workflows, add them to `shared/procedures.yml` and update `shared/_procedures-content.qmd`.

### Suggested New Chapters

| Decision Maker Topic | Developer Topic |
|---------------------|-----------------|
| Partnerships & Vendors | Working with External APIs & Services |
| Communication & Reporting | Visualization & Dashboards |
| Regulatory Compliance | Compliance Testing & Audit Trails |
| Change Management | Migration & Versioning Strategies |
| Measuring Success | Metrics Implementation & Monitoring |

### Quality Checks

- Run `bash scripts/validate.sh` after structural changes
- Ensure every chapter has an "Alignment Point" callout linking to the other book
- Keep code examples using `#| eval: false` unless you set up the Python environment
- Use Mermaid diagrams for workflows — they render natively in Quarto

## License

[Add your license here]
