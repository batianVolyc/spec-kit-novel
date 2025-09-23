<div align="center">
  <h1>📚 Spec Kit · Novel</h1>
  <p><em>A spec-driven assistant tailored for long-form fiction and serial storytelling.</em></p>
</div>

Spec Kit · Novel keeps the beloved installation flow of the upstream Spec Kit while swapping every command, template, and helper script for a novelist’s workflow. Use the same `specify` CLI you already know, but drive ideation, world-building, plotting, drafting, and revisions for books instead of codebases.

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

`specify check` still verifies your local AI tools (Claude Code, Gemini CLI, Copilot, Cursor, etc.). Pick whichever agent you prefer; the prompt profiles supplied with the toolkit handle tone and guidance per phase.

---

## Story Workflow at a Glance

| Command | When to Use | What Happens |
| ------- | ----------- | ------------- |
| `/spark` | Raw idea just landed | Opens/updates an idea session, summarises the pitch, surfaces clarifying questions (scope, cast, tone, logistics) and proposes tasteful enhancements without derailing your premise. |
| `/lore` | Concept approved | Generates/refreshes `lore/world.md`, individual character dossiers, and the roster. Dual identities, current ages, and open questions stay visible. |
| `/weave` | Ready to plot | Builds `plots/outline.md`, `plots/arcs.md`, and rewrites `project_overview.md` with scale, target word counts, and act pacing. Includes a watchlist of structural risks. |
| `/draft` | Writing chapters | Manages chapter lifecycle (`chapters/draft` → `chapters/final`), performs self-review, updates character continuity logs, and extends the rolling timeline (new file every 30 chapters or ~20k tokens). Supports natural language or `--auto` batching. |
| `/adapt` | Midstream changes | Processes retcons, new characters, alternate endings, or emergency rewrites. Applies edits across outline, chapters, timelines, character files, and records them in the adaptation log volumes. |

Re-run any step as often as you need; the toolkit always edits in place, acting as the single source of truth.

---

## 会话管理提示

- `/spark` 默认会复用 `ideas/` 中最新的会话文件。退出后重新进入 Gemini 或其他代理，无需额外操作，直接继续对话即可。
- 只有当你明确想开启全新灵感时，再使用 `/spark --fresh …`。脚本会建立新的 `session-YYYYMMDD_xx.md`，并将该文件设为新的上下文。
- 如果存在空白或误建的会话文件，删除它们可以避免下次被自动复用。
- `/lore`、`/weave`、`/draft`、`/adapt` 在重复执行时都会直接更新既有文件，不会额外生成重复副本，可放心多次调用。
- 想确认当前 `/spark` 复用哪份记录，可执行 `./.specify/scripts/bash/start-spark-session.sh --json`（或对应 PowerShell 脚本）查看 `SESSION_MODE` 值。

---

## Project Layout

```
📁 my-fiction-project
├── ideas/                    # Spark session transcripts
├── lore/world.md             # Living world bible
├── characters/               # Individual dossiers + roster.md
├── plots/outline.md          # Chapter beats, act pacing, watchlist
├── plots/arcs.md             # Main/secondary arcs and intersections
├── chapters/
│   ├── draft/chapter_001_draft.md
│   └── final/chapter_001_final.md
├── timelines/timeline_001-030.md
├── logs/adaptations/
│   ├── index.md
│   └── adaptations_001-050.md
├── project_overview.md       # One-page synopsis for quick recall
└── .specify/
    ├── templates/commands/   # /spark → /adapt prompt templates
    ├── templates/story/      # World/character/outline blueprints
    ├── scripts/{bash,ps}/    # Helper scripts invoked by commands
    └── config/prompt-profiles.toml
```

Key automation rules:
- Timeline files roll over every 30 chapters or when they exceed ~20k-token length (≈80k characters).
- Adaptation logs split into volumes (`001-050`, `051-100`, …) to keep context light; an `index.md` links them all.
- Character dossiers record every appearance with chapter, context, and evolution notes to maintain continuity.

---

## Prompt Profiles & Tone Control

`config/prompt-profiles.toml` defines tailored guidance for each phase:
- `spark`: warm, inquisitive, slightly exploratory (~20–30% divergence allowed).
- `lore`: archivist voice, tables for structured facts, explicit gaps list.
- `weave`: narrative architect with act structure awareness and pacing watchlist.
- `draft`: professional novelist output + mandatory self-review before finalising.
- `adapt`: continuity director who plans–applies–verifies every change and records it.

Adjust the profiles to match your voice. If your CLI cannot tweak model temperature, these prompts keep styles consistent across stages.

---

## Tips for a Smooth Session

- **Stay iterative.** Finish `/spark` rounds before `/lore`, and don’t hesitate to revisit `/spark` if direction changes midstream.
- **Use `/adapt` generously.** It is the safety valve for retcons, new characters, or “what if we kill the heroine in chapter 60?” moments.
- **Review hooks.** `/draft` surfaces continuity findings and next-chapter hooks—treat these as checklists before moving on.
- **Keep humans in the loop.** The toolkit biases towards natural, non-AI prose, but final judgement always belongs to you.

---

## Troubleshooting

- Templates or scripts missing? Re-run `specify init` or copy resources from `.specify/templates/story` and `.specify/scripts`.
- Timeline not splitting? Confirm chapter finals are committed; the helper scripts only rotate after chapters are marked FINAL.
- Need to extend automation? Add new scripts under `scripts/bash` or `scripts/powershell` and wire them into custom commands in `.specify/templates/commands`.

Happy writing! Tag issues or ideas in the repository if you want to extend the toolkit for other genres or workflows.
