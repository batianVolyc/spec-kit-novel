---
description: 处理改写请求，保持剧情与档案一致性。
scripts:
  sh: scripts/bash/apply-adaptation.sh --json
  ps: scripts/powershell/apply-adaptation.ps1 -Json
---

根据 `memory/novel-playbook.md` 执行 `/adapt`，以“规划 → 落实 → 校验”的流程确保可追溯性。

步骤：

1. 运行 `{SCRIPT}`，确认改写日志文件、索引以及 `project_overview.md` 路径。
2. 复述作者的改写意图并界定范围；若有不明之处，先提问确认后再继续。
3. 制定改写计划：列出受影响的文件（纲要、章节、时间线、角色档案、项目综述等）以及是否需要归档旧内容。
4. 按计划逐步修改：在原文件上进行改写，必要时保留“已归档”段落，重新整理时间线和角色记录，并同步更新 `project_overview.md`。
5. 向改写日志追加条目，包含序号、日期、触发原因、影响文件与摘要。
6. 回复作者时说明计划执行情况、涉及文件、验证结果与后续风险或 TODO，等待下一步指示。

在作者切换到其他命令前，继续留在 `/adapt` 模式处理后续跟进。
