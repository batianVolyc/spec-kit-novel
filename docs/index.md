# Spec Kit · Novel

*Turn spark ideas into finished fiction with a spec-driven workflow.*

Spec Kit · Novel repurposes the original Spec Kit infrastructure for long-form storytelling. The CLI, templates, and scripts now guide you from hazy concepts through world-building, plotting, drafting, and retcons—while keeping the same installation flow as upstream.

## Start Here

- [Installation Guide](installation.md)
- [Quick Start Guide](quickstart.md)
- [Local Development](local-development.md)

## Workflow Pillars

| Phase | Command | Focus |
| ----- | ------- | ----- |
| Ideation | `/spark` | Capture the pitch, ask targeted questions, offer refinement options, track decisions. |
| Lore | `/lore` | Build world bible, dual-identity dossiers, roster, and missing facts list. |
| Plotting | `/weave` | Shape acts, chapter beats, relationship dynamics, and update the project overview. |
| Drafting | `/draft` | Produce chapters with self-review, update timelines, and keep character continuity. |
| Adaptation | `/adapt` | Apply midstream changes across all artifacts with full traceability. |

Each command writes to structured Markdown files so both humans and AI agents can follow the evolving canon.

## Design Goals

- **Spec-first fiction** – Treat outlines, timelines, and dossiers as executable artefacts that drive drafts.
- **Human-quality prose** – Prompt profiles emphasise natural, varied language and discourage AI stock phrasing.
- **Continuity safety nets** – Automatic timeline rotation, adaptation logs, and character evolution tables keep sprawling narratives coherent.
- **Agent flexibility** – Works with Claude Code, Gemini CLI, Cursor, Copilot, Qwen Code, and more; prompts compensate when model knobs (e.g. temperature) are unavailable.

## Extending the Toolkit

- Adjust prompt behaviour via `.specify/config/prompt-profiles.toml`.
- Add helper scripts under `scripts/bash` or `scripts/powershell` and reference them in new command templates.
- Expand documentation or templates under `.specify/templates/story` to suit your genre or studio process.

Questions or ideas? Open an issue in the repository—the toolkit is meant to evolve with the writing communities that use it.
