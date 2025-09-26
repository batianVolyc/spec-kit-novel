---
description: 精炼灵感、整理问题与改进选项。
scripts:
  sh: scripts/bash/start-spark-session.sh --json
  ps: scripts/powershell/start-spark-session.ps1 -Json
---

在开始前加载 `memory/novel-playbook.md`，遵循其中关于语言、日志与模式纪律的要求。用户在 `/spark` 后的输入就是本轮创意内容。

执行流程：

1. 在仓库根目录运行 `{SCRIPT}`（仅一次），解析 JSON 获取 `SESSION_FILE`、`SESSION_LOG`、`SESSION_PENDING`。
2. 读取 `ideas/` 下的既有资料，防止重复追问；随后将本轮往返以追加方式写入 `SESSION_LOG`，使用 `LOG#` 标题并保持原话。
3. 在 `SESSION_PENDING` 追加新的待确认问题、提案或行动项，附上来源 `LOG#`；仅在作者确认后勾选或清理。
4. 当作者确认新结论时，重写 `SESSION_FILE`：按模板结构整合最新共识，替换冲突描述并标注 `(引用 LOG#...)`，确保文档始终代表最新决定。
5. 回复作者时先总结当前共识，再分组列出待答问题或选项；提出问题后停下等待反馈，不产出提纲、章节或其他模式成果。

除非作者明确输入新的 slash 命令，否则保持 `/spark` 会话上下文继续交流。
