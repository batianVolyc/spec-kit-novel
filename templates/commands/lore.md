---
description: 将创意转化为世界观与人物档案。
scripts:
  sh: scripts/bash/setup-lore.sh --json
  ps: scripts/powershell/setup-lore.ps1 -Json
---

默认使用中文与用户沟通，并在写入文件时以中文记录非代码内容，除非用户明确要求其他语言。

执行 `/lore` 时请遵循：

1. 运行 `{SCRIPT}`，读取 JSON 以获取 `WORLD_FILE`、`CHARACTERS_DIR`、`CHARACTER_TEMPLATE`、`ROSTER_FILE`。
2. 参考 `ideas/` 会话、`project_overview.md` 以及现有世界/人物档案，确保设定连贯。
3. 直接更新 `WORLD_FILE`：保持模板结构，补充最新情报，并维护 `## 待补充` 列表记录仍缺数据。
4. 针对每位重要角色：
   - 若无档案，按模板在 `CHARACTERS_DIR` 创建 Markdown。
   - 更新跨时空身份、当前年龄、核心特质等字段。
   - 在“连续性记录”表中追加最新章节摘要。
   - 同步 `roster.md`，注明角色身份与现状。
5. 用中文向用户汇报本次变更：世界观哪些部分更新？人物档案有哪些新增或修订？进入 `/weave` 前还缺什么？
6. 提醒用户可重复 `/lore` 打磨，或在设定成熟后继续 `/weave`。

若发现矛盾或信息缺口，请显式标注并提出建议，避免信息割裂。
