---
description: 设计剧情纲要、剧情线与项目总览。
scripts:
  sh: scripts/bash/setup-weave.sh --json
  ps: scripts/powershell/setup-weave.ps1 -Json
---

默认使用中文与用户沟通，并在写入文件时以中文记录非代码内容，除非用户明确要求其他语言。

执行 `/weave` 时请遵循：

1. 运行 `{SCRIPT}`，获取 `OUTLINE_FILE`、`ARCS_FILE`、`PROJECT_OVERVIEW` 以及 `LOG_FILE`、`PENDING_FILE`。
2. 将以下文件视为已确认的参考基石：`ideas/` 中最新创意基石、`lore/world.md`、`characters/` 下各角色档案、既有 `OUTLINE_FILE`、`ARCS_FILE`、`PROJECT_OVERVIEW`。对话日志与 `PENDING_FILE` 仅作为溯源工具，不得直接采纳为事实。
3. 在此基础上结合最新 `/spark`、`/lore` 结果，确认上下文一致；随后以 `#### [LOG#YYYYMMDD-XX] 角色` 形式把本轮发言原文追加到 `LOG_FILE`，可在行尾标注 `#结构`、`#确认` 等标签，禁止改写旧日志。
4. 在 `PENDING_FILE` 中维护所有未确认的结构调整、篇章安排与节奏建议，使用 `[ ]` 复选框，并在每条记录中标注来源 `LOG#`；仅在用户确认后，将条目转移至正式提纲文件。
5. 改写 `OUTLINE_FILE` 时需重读现有内容，融合已确认的最新信息：保持三幕结构与节奏清单，若新决定与旧设定冲突，应以新决定替换旧描述，并在相关行注明 `(引用 LOG#...)`；`## 决策索引` 中记录本次确认的条目。
6. 更新 `ARCS_FILE` 时仅保留已确认的主线与支线，替换冲突节点，并在“决策索引”登记对应 `LOG#`；未确认的候选走向继续保存在 `PENDING_FILE`。
7. 重写 `project_overview.md` 时，仅整合经过确认的定位、篇幅与卖点，并在“决策索引”中标注更新来源；仍待确认的事项请留在 `PENDING_FILE` 并在文中引用。
8. 用中文向用户汇报阅读体验、各幕安排与待确认列表；提出问题或选项后须停下等待用户回复，绝不自行决定下一步。

在 `/weave` 会话中禁止主动执行其它 slash 命令或脚本（例如 `manage-draft.sh`）；若用户想进入下一阶段，必须显式输入对应的 `/draft`、`/lore` 等指令后再切换。

收到新指令前保持 `/weave` 会话上下文，不得启动章节写作或改稿等其他模式任务。

保持文档的唯一权威性，如发现冲突须明记于“节奏观察清单”并提出对策。
