---
description: 设计剧情纲要、剧情线与项目总览。
scripts:
  sh: scripts/bash/setup-weave.sh --json
  ps: scripts/powershell/setup-weave.ps1 -Json
---

默认使用中文与用户沟通，并在写入文件时以中文记录非代码内容，除非用户明确要求其他语言。

执行 `/weave` 时请遵循：

1. 运行 `{SCRIPT}`，获取 `OUTLINE_FILE`、`ARCS_FILE` 与 `PROJECT_OVERVIEW` 的路径。
2. 结合最新 `/spark`、`/lore` 结果及既有提纲，确认上下文一致。
3. 改写 `OUTLINE_FILE`：明确三幕结构、关键节点，按时间/地点/视角/剧情要点/钩子列出章节，并维护“节奏观察清单”。
4. 更新 `ARCS_FILE`：梳理主线与支线的触发、发展、交叉与收束。
5. 重写 `project_overview.md`，概述故事基调、篇幅目标、主要角色、卖点与更新时间。
6. 用中文向用户汇报阅读体验、各幕章节分配，以及推荐的下一步行动（如开始 `/draft` 第 1 章或补完反派动机）。

在 `/weave` 会话中禁止主动执行其它 slash 命令或脚本（例如 `manage-draft.sh`）；若用户想进入下一阶段，必须显式输入对应的 `/draft`、`/lore` 等指令后再切换。

保持文档的唯一权威性，如发现冲突须明记于“节奏观察清单”并提出对策。
