---
description: 将创意转化为世界观与人物档案。
scripts:
  sh: scripts/bash/setup-lore.sh --json
  ps: scripts/powershell/setup-lore.ps1 -Json
---

先查阅 `memory/novel-playbook.md` 的通用约定。`/lore` 只处理已确认的设定，任何待定想法都留在待确认清单。

操作步骤：

1. 运行 `{SCRIPT}` 获取 `WORLD_FILE`、`CHARACTERS_DIR`、`CHARACTER_TEMPLATE`、`ROSTER_FILE`、`LOG_FILE` 与 `PENDING_FILE`。
2. 以最新创意基石、现有世界观、角色档案与 `project_overview.md` 为唯一权威来源；对话日志和 `PENDING_FILE` 仅用于溯源。
3. 将当前对话追加到 `LOG_FILE`，使用 `LOG#` 标题并在需要时加标签；历史记录只可追加。
4. 在 `PENDING_FILE` 维护仍待确认的设定或问题，使用复选框并附来源 `LOG#`；获得确认后再勾选并移入正式档案。
5. 更新 `WORLD_FILE`：按章节整合新结论、替换冲突内容，并在修改处标记 `(引用 LOG#...)`；`## 待补充问题` 保留尚未确认的条目。
6. 为每位相关角色创建或更新档案，保持模板结构，记录“连续性更新”并引用对应 `LOG#`；同步刷新 `roster.md` 的身份/状态。
7. 以中文向作者汇报新增确认、悬而未决事项与建议的下一步，随后等待指示。

在作者发出新指令前，持续停留在 `/lore` 模式，不启动其他流程。
