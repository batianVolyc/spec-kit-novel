---
description: 设计剧情纲要、剧情线与项目总览。
scripts:
  sh: scripts/bash/setup-weave.sh --json
  ps: scripts/powershell/setup-weave.ps1 -Json
---

默认使用中文与用户沟通，并在写入文件时以中文记录非代码内容，除非用户明确要求其他语言。

执行 `/weave` 时请遵循：

1. 运行 `{SCRIPT}`，获取 `OUTLINE_FILE`、`ARCS_FILE`、`PROJECT_OVERVIEW` 以及 `LOG_FILE`、`PENDING_FILE`。
2. 结合最新 `/spark`、`/lore` 结果及既有提纲，确认上下文一致；随后在 `LOG_FILE` 记录本轮讨论要点，区分用户输入、AI 建议与尚待确认的节点。
3. 在 `PENDING_FILE` 中维护所有未确认的结构调整、篇章安排与节奏建议，使用 `[ ]` 复选框标记；仅在用户确认后，将条目转移至正式提纲文件。
4. 改写 `OUTLINE_FILE` 时仅写入已确认的章节与节奏信息，保持三幕结构、关键节点与“节奏观察清单”同步。
5. 更新 `ARCS_FILE` 以记录已确认的主线与支线；未确认的候选走向继续保留在 `PENDING_FILE`。
6. 重写 `project_overview.md` 时，仅整合经过确认的定位、篇幅与卖点，备注仍待确认事项及其所在清单。
7. 用中文向用户汇报阅读体验、各幕安排与待确认列表；提出问题或选项后须停下等待用户回复，绝不自行决定下一步。

在 `/weave` 会话中禁止主动执行其它 slash 命令或脚本（例如 `manage-draft.sh`）；若用户想进入下一阶段，必须显式输入对应的 `/draft`、`/lore` 等指令后再切换。

收到新指令前保持 `/weave` 会话上下文，不得启动章节写作或改稿等其他模式任务。

保持文档的唯一权威性，如发现冲突须明记于“节奏观察清单”并提出对策。
