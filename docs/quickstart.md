# Quick Start Guide

Spec Kit · Novel keeps the familiar `specify` CLI while turning the workflow toward fiction writing. This guide walks through the end-to-end loop using the new `/spark` → `/adapt` command set.

## 1. Install the CLI

```bash
uv tool install specify-cli --from git+https://github.com/batianVolyc/spec-kit-novel.git
# or
uvx --from git+https://github.com/batianVolyc/spec-kit-novel.git specify init dream-project
```

> Tip: Run `specify check` to verify your preferred AI agent (Claude Code, Gemini CLI, Cursor, etc.) is available before starting a session.

## 2. Initialise a Project

```bash
specify init moonlit-chang-an-tales
```

After the command finishes you’ll have:
- `ideas/` for spark sessions
- `lore/` and `characters/` for world + cast records
- `plots/` for outlines and arc sheets
- `chapters/draft` & `chapters/final` for manuscripts
- `timelines/` and `logs/adaptations/` for continuity trails
- `.specify/` with all command templates, scripts, and prompt profiles

## 3. Shape the Concept — `/spark`

Run `/spark` with your rough pitch:

```
/spark 现代外科医生误入开元盛世，在长安城开医馆济世，卷入朝堂与豪门爱恨。
```

Each invocation updates the matching `ideas/session-YYYYMMDD_xx.md` file and replies with:
- A concise summary of the idea as currently understood
- Grouped clarifying questions (scope, cast, tone, logistics)
- Optional enhancement paths labelled Option A/B/C
- A risk/watchlist section and a decision checklist

Repeat until you are satisfied—only then move on to `/lore`.

## 4. Lock the Setting — `/lore`

```
/lore 重点描写长安城坊市秩序、太医署、豪门世家背景，并补充主要人物双身份。
```

The tool updates `lore/world.md`, every relevant character dossier under `characters/`, and the roster table. Any missing facts appear in a `## Gaps` section so you can fill them later.

## 5. Build the Outline — `/weave`

```
/weave 长篇爽文，计划 120 章，每章约 3500 字，三幕结构。
```

Outputs:
- `plots/outline.md` with act structure, chapter beats (time/location/POV), relationship dynamics, and a pacing watchlist
- `plots/arcs.md` describing main and secondary arcs plus intersections
- A refreshed `project_overview.md` summarising premise, cast, scale, and hook for quick reference

## 6. Draft Chapters — `/draft`

```
/draft 开篇第一章，聚焦主角初到长安的醒来与救治街坊。
```

The script prepares `chapters/draft/chapter_001_draft.md`. You receive:
- **Draft Manuscript** — raw prose
- **Review Findings** — continuity checks (outline alignment, character voice, “AI phrase” audit, etc.)
- **Action Taken** — adjustments made before finalising
- **Final Manuscript** — only present when the review passes

Upon final approval the tool:
- Writes `chapters/final/chapter_001_final.md`
- Appends an entry to the appropriate timeline file (rolling every 30 chapters or ~20k tokens)
- Updates each involved character’s continuity log

Use natural language to request more chapters (`“继续下一章”`) or add `--auto N` when your agent supports CLI flags.

## 7. Adapt & Retcon — `/adapt`

```
/adapt 女配角在第 45 章突然决定和男主竞争医馆，调整之后的任务和情感走向。
```

`/adapt` plans, applies, and verifies complex changes, then records them in `logs/adaptations/adaptations_XXX-YYY.md`. It also amends outlines, character dossiers, timelines, and prior chapters when required. Use it for:
- New characters or altered motivations
- Retroactive fixes to earlier chapters (with archived versions for traceability)
- Changing planned length, word counts, or tone (updates `project_overview.md`)

---

## Where to Go Next

- Tweak prompt behaviour in `.specify/config/prompt-profiles.toml` to match your narrative voice.
- Add custom helper scripts under `scripts/bash` or `scripts/powershell` if you want extra automation.
- Keep a human review loop—this toolkit aims for “human-quality drafts”, but your judgement closes the gap.

Happy writing!
