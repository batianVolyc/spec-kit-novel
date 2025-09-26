# Quick Start Guide

Spec Kit · Novel keeps the familiar `specify` CLI while turning the workflow toward fiction writing. This guide walks through the `/spark` → `/adapt` loop and highlights what changed in the 2025 refresh.

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
- Story-facing directories (`ideas/`, `lore/`, `characters/`, `plots/`, `chapters/`, `timelines/`, `logs/adaptations/`)
- `.specify/templates` with slash-command prompts and story templates
- `.specify/scripts` with helper scripts for both bash and PowerShell
- `.specify/config/prompt-profiles.toml` pointing every profile back to the shared playbook
- `memory/novel-playbook.md` describing the language, logging, and mode discipline rules that every command loads automatically

## 3. Shape the Concept — `/spark`

```
/spark 现代外科医生误入开元盛世，在长安城开医馆济世，卷入朝堂与豪门爱恨。
```

Each invocation updates the latest `ideas/session-YYYYMMDD_xx.md`, appends to the conversation log, and keeps a tidy pending checklist. The reply summarises the concept, groups clarifying questions, and reminds you which decisions still need confirmation.

Repeat until the creative brief feels stable—only then move on to `/lore`.

## 4. Lock the Setting — `/lore`

```
/lore 补完长安城坊市秩序、太医署、豪门世家背景，并记录主要人物的双身份。
```

`/lore` rewrites `lore/world.md`, updates or creates character dossiers under `characters/`, and refreshes `roster.md`. Anything still unsettled stays in the `lore/pending` checklist and is referenced with a `LOG#` tag.

## 5. Build the Outline — `/weave`

```
/weave 长篇爽文，计划 120 章，每章约 3500 字，三幕结构。
```

Outputs include:
- `plots/outline.md` — act structure, chapter beats with time/location/POV, pacing watchlist
- `plots/arcs.md` — main and supporting arcs, plus backup beats for volatile threads
- `project_overview.md` — refreshed elevator pitch, audience promise, and scale

## 6. Draft Chapters — `/draft`

```
/draft --auto 3 开篇第一章，聚焦主角初到长安的醒来与救治街坊。
```

执行 `/draft` 会触发“主编 → 写手 → 主编”三段协作：
1. **主编 persona** 汇总创意基石、纲要、角色档案、近三章终稿，覆写 `chapters/plan/chapter_001_plan.md` 为《章节创作指南》；
2. **写手 persona** 依据指南撰写草稿，填充 `Draft` / `Review Findings` / `Action Taken` 区块；
3. **主编 persona** 审稿并写入 `chapters/editor/chapter_001_editor.md`，可小修草稿或退稿（最多两轮）。通过后填写 `Final Manuscript`、复制终稿到 `chapters/final`、并更新时间线/角色档案/改写日志。

`--auto 3` 表示从当前章起连续创作三章。每章定稿后自动减计数、重新运行脚本并生成下一章；若遇到两次退稿仍不过或出现设定冲突，会停止自动流程并提示人工介入。

## 7. Adapt & Retcon — `/adapt`

```
/adapt 女配角在第 45 章决定与主角竞争医馆，需要回溯前十章铺垫并更新后续节奏。
```

`/adapt` plans, applies, and verifies the changes, then records the outcome in `logs/adaptations/adaptations_XXX-YYY.md`. It touches outlines, chapters, timelines, or dossiers as needed so continuity stays intact.

---

## Where to Go Next

- Fine-tune style or review behaviour in `.specify/config/prompt-profiles.toml`.
- Add custom helper scripts under `scripts/bash` or `scripts/powershell` if you need extra automation.
- Update `memory/novel-playbook.md` whenever your studio norms change—every command will pick up the new rules the next time it runs.

Happy writing!
