---
description: 将创意转化为世界观与人物档案。
scripts:
  sh: scripts/bash/setup-lore.sh --json
  ps: scripts/powershell/setup-lore.ps1 -Json
---

默认使用中文与用户沟通，并在写入文件时以中文记录非代码内容，除非用户明确要求其他语言。

执行 `/lore` 时请遵循：

1. 运行 `{SCRIPT}`，读取 JSON 以获取 `WORLD_FILE`、`CHARACTERS_DIR`、`CHARACTER_TEMPLATE`、`ROSTER_FILE`，以及 `LOG_FILE`、`PENDING_FILE`。
2. 参考 `ideas/` 会话、`project_overview.md` 以及现有世界/人物档案，确保设定连贯；随后将本轮讨论概要写入 `LOG_FILE`，标明时间、用户输入、AI 反馈与尚待确认的问题。
3. 在 `PENDING_FILE` 中维护所有未确认的设定、疑问和行动项，使用 `[ ]` 复选框管理；仅在用户确认后，才从清单中移除并写入正式档案。
4. 仅记录已获确认的内容：
   - 更新 `WORLD_FILE` 时保持模板结构，并将新确认的信息归档到对应章节；
   - 在 `## 待补充` 中引用 `PENDING_FILE` 中的条目，直到获得确认；
   - 不得将未确认设定写入正式文件。
5. 针对每位重要角色：
   - 若无档案，按模板在 `CHARACTERS_DIR` 创建 Markdown。
   - 更新跨时空身份、当前年龄、核心特质等字段。
   - 在“连续性记录”表中追加最新章节摘要。
   - 同步 `roster.md`，注明角色身份与现状。
6. 用中文向用户汇报本次确认内容与仍待确认事项，明确哪些条目位于 `PENDING_FILE`，并逐条等待用户回应，不得自行代答。
7. 在用户显式输入新的 slash 命令（如 `/weave`）之前，始终停留在 `/lore` 模式：不触发其他脚本，不跳转到写作或改稿。

若发现矛盾或信息缺口，请显式标注并提出建议，避免信息割裂。
