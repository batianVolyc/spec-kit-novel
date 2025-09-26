---
description: 设计剧情纲要、剧情线与项目总览。
scripts:
  sh: scripts/bash/setup-weave.sh --json
  ps: scripts/powershell/setup-weave.ps1 -Json
---

遵循 `memory/novel-playbook.md` 的规则，仅在作品已进入结构设计阶段时使用 `/weave`。

执行要点：

1. 运行 `{SCRIPT}` 获取 `OUTLINE_FILE`、`ARCS_FILE`、`PROJECT_OVERVIEW`、`LOG_FILE`、`PENDING_FILE`。
2. 基于最新的创意基石、`lore/world.md`、角色档案与既有纲要资料校验上下文，避免出现设定冲突。
3. 将当前往返记录进 `LOG_FILE` 并保持追加式写入；必要时标记主题标签（如 `#结构`、`#风险`）。
4. 在 `PENDING_FILE` 维护仍待确认的结构调整或备选剧情，使用复选框并附 `LOG#`。获批前不要写入正式提纲。
5. 重写 `OUTLINE_FILE`：清楚标注幕结构、节奏要点和阅读体验，替换过时内容并在“决策索引”登记对应 `LOG#`；风险项放入“Watchlist”。
6. 更新 `ARCS_FILE`：区分主线与支线，仅保留已确认的剧情节点，未确认走向继续留在 `PENDING_FILE`。
7. 改写 `project_overview.md`，整合确认过的定位、篇幅与卖点，并引用关联 `LOG#`；未敲定事项移至待确认或 Watchlist。
8. 向作者汇报整体阅读体验、关键决策与剩余问题，然后停下等待下一步。

收到新 slash 指令之前，不要进入写作或改稿流程。
