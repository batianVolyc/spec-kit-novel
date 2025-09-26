<div align="center">
  <h1>📚 Spec Kit · Novel (2025 refresh)</h1>
  <p><em>A Spec Kit distribution tailored for long-form fiction and serial storytelling.</em></p>
</div>

Spec Kit · Novel builds on the upstream Spec Kit 0.0.54 template and swaps every workflow primitive for a novelist’s toolkit. You still run `specify init`, but the generated project bootstraps story-centric directories, prompt templates, and helper scripts. Shared guardrails—language, logging, and mode discipline—now live in one place: `memory/novel-playbook.md`.

---

## Getting Started

Install the CLI with `uv` (recommended):

```bash
uv tool install specify-cli --from git+https://github.com/batianVolyc/spec-kit-novel.git
specify init my-fiction-project
```

or run it ad hoc:

```bash
uvx --from git+https://github.com/batianVolyc/spec-kit-novel.git specify init my-fiction-project
```

`specify check` still verifies your local AI tools (Claude Code, Gemini CLI, Copilot, Cursor, etc.). Pick whichever agent you prefer; prompt profiles in `.specify/config/prompt-profiles.toml` keep tone and expectations consistent per phase.

---

## Story Workflow

`memory/novel-playbook.md` is the operating manual for every slash command. The workflow moves through five focused phases:

| Command | When to Use | What Happens |
| ------- | ----------- | ------------- |
| `/spark` | Exploring raw ideas | Reopens or creates the latest idea session, logs the conversation, updates the pending checklist, and rewrites the authoritative "创意基石" with any newly confirmed decisions. |
| `/lore` | Canon needs consolidation | Integrates confirmed details into `lore/world.md`, character dossiers, and the roster while keeping unresolved questions in `pending`. Logs every exchange and flags contradictions for follow-up. |
| `/weave` | Plot structure time | Maintains `plots/outline.md`, `plots/arcs.md`, and `project_overview.md`, capturing pacing, act structure, and a Watchlist of structural risks. Pending beats stay uncommitted until approved. |
| `/draft` | Writing chapters | 通过“主编→写手→主编”三段流程完成章节：主编汇总创作指南、写手撰稿、自审，主编审稿后定稿并同步时间线/角色档案；支持 `--auto` 参数连续创作多章。 |
| `/adapt` | Retcons or scope shifts | Runs a Plan → Apply → Verify loop across every impacted artefact, archives superseded material instead of deleting it, and records entries in the adaptation log volumes. |

Run any command as often as you need—each is idempotent and edits the existing artefacts in place. If you are unsure how a phase should behave, skim the matching section in the playbook.

---

## Project Layout

```
📁 my-fiction-project
├── ideas/                    # /spark sessions & pending checklists
├── lore/world.md             # Living world bible
├── characters/               # Individual dossiers + roster.md
├── plots/outline.md          # Confirmed chapter beats & pacing watchlist
├── plots/arcs.md             # Main & supporting arcs
├── chapters/
│   ├── draft/chapter_001_draft.md
│   ├── final/chapter_001_final.md
│   ├── plan/chapter_001_plan.md
│   └── editor/chapter_001_editor.md
├── timelines/timeline_001-030.md
├── logs/adaptations/
│   ├── index.md
│   └── adaptations_001-050.md
├── project_overview.md       # One-page synopsis for quick recall
└── .specify/
    ├── templates/commands/   # /spark → /adapt prompt templates
    ├── templates/story/      # World / character / outline blueprints
    ├── scripts/{bash,ps}/    # Helper scripts invoked by commands
    └── config/prompt-profiles.toml
```

Automation rules baked into the helper scripts:
- Timeline files roll every 30 chapters or when a volume crosses ~80k characters.
- Adaptation logs split into 50-entry volumes, linked from `logs/adaptations/index.md`.
- Chapter finals are the source of truth for numbering; drafts always reference the next available slot.

---

## Prompt System

Prompt profiles for popular agents live in `.specify/config/prompt-profiles.toml`. Each profile points back to the shared playbook instead of repeating boilerplate, then layers on phase-specific tone and response rules. Gemini command manifests in `.specify/templates/agents/gemini/commands/` mirror the core prompts so Gemini CLI users receive the same guidance.

If you customise language, tone, or logging rules, edit `memory/novel-playbook.md` first—every command template loads it on entry.

---

## Draft Workflow Details

- **主编 Persona（`memory/personas/editor.md`）**：读取创意基石、剧情纲要、角色档案、时间线与近三章终稿，覆写 `chapters/plan/chapter_XXX_plan.md` 形成《章节创作指南》，列出必读资料、分段结构、人物要点与风险提醒。
- **写手 Persona（`memory/personas/writer.md`）**：遵循创作指南，在 `chapters/draft/chapter_XXX_draft.md` 撰写草稿并填写 `Draft / Review Findings / Action Taken`，`Final Manuscript` 留待主编批准后填写。
- **主编审稿**：在 `chapters/editor/chapter_XXX_editor.md` 记录评语、评分与处理方案，可小修或退稿（最多两轮）。通过后同步 `Final Manuscript`、更新时间线与角色档案。
- **自动续写**：使用 `/draft --auto N` 可连续生成 N 章；脚本会返回 `AUTO_COUNT`，模板在每章定稿后自动减计数并重新运行脚本。若两轮重写仍不过或出现重大设定冲突，会立即停止自动流程并提示人工介入。

---

## Tips for a Smooth Session

- **Stay iterative.** Finish `/spark` rounds before `/lore`, and revisit `/spark` whenever major decisions shift.
- **Keep humans in the loop.** `/draft` performs a self-review but still expects you to accept or request changes.
- **Collaborative drafting.** `/draft` 自动生成《章节创作指南》，由主编与写手 Persona 协同执行，并可通过 `--auto` 持续创作多章。  
- **Use `/adapt` liberally.** It’s designed for late-game retcons, new POV characters, or structural overhauls.
- **Skim the logs.** Slash commands annotate every update with `LOG#` references so you can trace context quickly.

---

## Troubleshooting

- Missing templates or scripts? Re-run `specify init` or copy assets from `.specify/templates` and `.specify/scripts`.
- Timeline not rotating? Ensure the latest chapter is finalised—rotation only occurs after a final manuscript is written.
- Need extra automation? Add scripts under `scripts/bash` or `scripts/powershell` and wire them into custom commands inside `.specify/templates/commands`.

Tag issues or ideas if you want to extend the toolkit for other genres, collaborative rooms, or episodic formats.
