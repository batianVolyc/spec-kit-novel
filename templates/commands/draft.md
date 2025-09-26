---
description: 生成章节草稿并完成主编-写手协同审稿流程。
scripts:
  sh: scripts/bash/manage-draft.sh --json
  ps: scripts/powershell/manage-draft.ps1 -Json
---

在执行前阅读 `memory/novel-playbook.md` 并加载 Persona 设定：主编（`memory/personas/editor.md`）与写手（`memory/personas/writer.md`）。仅在作者明确要求进入写作阶段时启动。

- 若 JSON 中 `AUTO_COUNT` > 1，在后续章节开始前重新运行脚本时，需要手动追加参数（POSIX：`--auto-count 剩余数`，PowerShell：`-AutoCount 剩余数`）。
- 若 `$ARGUMENTS` 包含 `--auto`：
  - 可接受写法：`--auto 20`、`--auto=20`、`--auto20`；若未提供数字则默认 1。
  - 该数字表示从当前章节起需要连续创作的章数；首次运行脚本时据此设置 `AUTO_COUNT`。
  - 每成功定稿一章后，`AUTO_COUNT` 减一；若仍 ≥1，则继续下一章，否则停止自动流程并等待作者指令。

## 总体原则
- `{SCRIPT}` 的 JSON 输出包含：`PLAN_FILE`、`EDITOR_LOG`、`DRAFT_FILE`、`FINAL_FILE`、`TIMELINE_FILE`、`ADAPTATION_LOG`、`RECENT_FINALS`、`AUTO_COUNT`。
- `AUTO_COUNT > 1` 表示作者授权自动连续创作多章。完成当前章后，若无阻塞，可以减一计数并再次运行 `{SCRIPT}`，直至计数耗尽或流程被终止。
- 每章最多允许两轮“写手→主编→写手”重写；如两轮后仍不过关，标记为“需人工介入”，停止自动续写并提示作者。

## 流程步骤

1. **运行脚本并整理资料**  
   - 解析 `$ARGUMENTS` 得出 `auto_remaining`（默认为 1）。在仓库根目录执行 `{SCRIPT}`，并在命令后追加当前的 `--auto-count auto_remaining`（或 `-AutoCount auto_remaining`）。
   - 若处于自动续写流程且尚有剩余章节，每次进入新章节前都需重新运行脚本并使用更新后的剩余计数。
   - 解析 JSON，确认各文件路径与 `AUTO_COUNT`。
   - 收集必读资料：`project_overview.md`、`plots/outline.md`、`plots/arcs.md`、相关角色档案、时间线、`RECENT_FINALS` 列表中的终稿。

2. **主编 Persona：编写章节创作指南**  
   - 以主编身份整合资料，覆写 `PLAN_FILE`（参考模板结构）。
   - 需明确：章节目标、参考资料列表（含文件路径）、分段结构、人物要点、情节要素、伏笔与风险提醒。
   - 如发现缺口或异议，记录在风险区并标注 `LOG#`，同步到待确认事项。

3. **写手 Persona：根据指南撰写草稿**  
   - 切换到写手 persona，研读最新 `PLAN_FILE` 与参考文件。
   - 在 `DRAFT_FILE` 写出四个区块：
     1. `Draft` —— 章节正文，按计划分段，可附小标题。
     2. `Review Findings` —— 自检总结，指出潜在风险或待主编决定的事项。
     3. `Action Taken` —— 本次为满足计划所做的调整，或列出仍需主编裁定的问题。
     4. `Final Manuscript` —— 留空，等待主编批准后填写。
   - 避免 AI 风语句，确保角色声音、世界观与设定一致；引用资料时附 `LOG#`。

4. **主编 Persona：审稿与修订**  
   - 回到主编 persona，对照 `PLAN_FILE`、`DRAFT_FILE`、既有资料逐条审查。
   - 在 `EDITOR_LOG` 记录：判定结果（通过/小修/退稿）、评分、详细反馈与建议动作。
   - 如仅需小修，可在 `DRAFT_FILE` 内直接标注并修改句段，列明修改原因。
   - 若需重写：
     - 更新 `PLAN_FILE` 的相关段落或风险列表。
     - 在 `EDITOR_LOG` 写明退稿理由与重写指引。
     - 将当前轮次记为“退稿第 N 次”，引导写手进入下一轮（最多两轮）。
   - 审稿通过后：
     - 在 `DRAFT_FILE` 的 `Final Manuscript` 填入最终文本，确保与 Draft 匹配。
     - 将终稿同步到 `FINAL_FILE`。
     - 更新时间线表格、角色档案连续性记录、及必要的日志（均需引用 `LOG#`）。

5. **输出总结与自动续写**  
   - 向用户报告：章节摘要、审稿结论、已更新文件、剩余自动计数、风险或待确认事项。  
   - 若 `AUTO_COUNT` 仍大于 1 且流程顺利：
     - 计算 `auto_remaining = AUTO_COUNT - 1`，在回复中说明剩余章数。
     - 在下一章开始前重新运行 `{SCRIPT}`，附上新的 `--auto-count auto_remaining` / `-AutoCount auto_remaining`，然后回到步骤 1。
   - 若出现阻塞（两次退稿后仍不过、发现重大设定冲突、脚本执行失败等）：
     - 停止自动流程，记录原因与建议的下一步，等待作者指示。

在收到作者新指令前，始终保持 `/draft` 模式；除 `--auto` 授权情况外，不得自行切换到其他 Slash 命令。
