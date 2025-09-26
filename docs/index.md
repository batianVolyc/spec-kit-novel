# Spec Kit · Novel

*Turn spark ideas into finished fiction with a spec-driven workflow.*

This distribution repurposes the Spec Kit 0.0.54 infrastructure for long-form storytelling. Installation is identical to upstream, but the generated project, slash commands, and helper scripts now orbit five story phases. Shared guardrails—language, logging, and continuity etiquette—live in `memory/novel-playbook.md`, which every command loads before acting.

## Start Here

- [Installation Guide](installation.md)
- [Quick Start Guide](quickstart.md)
- [Local Development](local-development.md)

## Workflow Pillars

| Phase | Command | Focus |
| ----- | ------- | ----- |
| Ideation | `/spark` | Capture the pitch, ask targeted questions, log decisions, and keep a concise pending checklist. |
| Lore | `/lore` | Consolidate canon into world bibles, character dossiers, and the roster while flagging gaps. |
| Plotting | `/weave` | Shape acts, chapter beats, and pacing, updating the project overview plus a structural Watchlist. |
| Drafting | `/draft` | 主编 persona 汇总创作指南、写手 persona 撰稿，主编复审后同步终稿/时间线/角色档案；支持 `--auto` 连续创作多章。 |
| Adaptation | `/adapt` | Apply retcons or scope changes with a Plan → Apply → Verify cadence and detailed adaptation logs. |

Each phase writes to structured Markdown artefacts so both humans and AI agents can follow (and audit) the evolving canon.

## Design Goals

- **Spec-first fiction** – Treat outlines, timelines, and dossiers as executable artefacts that guide drafting.
- **Unified guardrails** – A single playbook trims prompt repetition and keeps language/tone guidance aligned across agents.
- **Continuity safety nets** – Timeline rotation, adaptation volumes, and LOG# annotations make sprawling narratives tractable.
- **Agent flexibility** – Works with Claude Code, Gemini CLI, Cursor, Copilot, Qwen Code, and more; prompt profiles compensate when model knobs (e.g. temperature) are unavailable.

## Extending the Toolkit

- Tweak style or response rules in `.specify/config/prompt-profiles.toml` (all profiles refer back to the shared playbook).
- Add helper scripts under `scripts/bash` or `scripts/powershell` and reference them from new slash commands.
- Evolve the story templates in `.specify/templates/story` to match your studio’s format or editorial needs.

Questions or ideas? Open an issue—the toolkit is meant to evolve with the communities that rely on it.
