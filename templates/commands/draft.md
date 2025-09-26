---
description: 生成章节草稿并执行主编-写手协同审稿，可在 `--auto` 模式下连续创作多章。
scripts:
  sh: scripts/bash/manage-draft.sh --json
  ps: scripts/powershell/manage-draft.ps1 -Json
---

在执行前务必阅读 `memory/novel-playbook.md`，并加载以下 Persona：
- 主编：`memory/personas/editor.md`
- 写手：`memory/personas/writer.md`

仅在作者明确进入写作阶段时运行 `/draft`。保持中文输出，并遵守“绝不跨 Slash”原则。

### 处理自动续写参数
- `$ARGUMENTS` 支持 `--auto 20`、`--auto=20`、`--auto20` 等写法；若缺省数字则视为 1。
- 解析后记为 `auto_target`，首章执行 `{SCRIPT}` 时无需传参；若返回 JSON 中 `AUTO_COUNT` 为 0，则以 `auto_target` 代入。
- 进入下一章前，应以最新剩余计数重新执行 `{SCRIPT}`，即 POSIX 追加 `--auto-count 剩余数`，PowerShell 追加 `-AutoCount 剩余数`。

### 总体流程概览
1. 运行脚本获取 `PLAN_FILE`、`EDITOR_LOG`、`DRAFT_FILE`、`FINAL_FILE`、`TIMELINE_FILE`、`ADAPTATION_LOG`、`RECENT_FINALS`、`AUTO_COUNT`。
2. 主编 persona 生成/更新章节计划，写入 TODO 清单并记录尝试计数（写手重写次数、主编接管次数）。
3. 写手 persona 依据计划撰写草稿，仅输出正文与给主编的待确认事项；不要自判“无风险”。
4. 主编 persona 审稿，判定通过/小修/退稿；
   - 退稿时更新尝试计数，同步 TODO，并要求写手重写（最多两轮）。
   - 若两轮仍不过关，主编需亲自重写或小修使其达标，并将“主编接管次数”加 1。
5. 通过后，主编完成定稿：填充 `Final Manuscript`、同步终稿文件、更新时间线与角色档案。
6. 输出摘要，并根据剩余自动章节数决定是否继续下一章；遇到阻塞要立即停止自动续写并报告原因。

### 文件写入约定
- 写入文件时使用 `Shell` 工具（例如 `cat <<'EOF' > "$PLAN_FILE"`），不要依赖 `WriteFile` 差异输出。
- 每次写入后如需展示内容，请使用 `ReadFile` 查看完整结果，避免前后重复展示 diff。
- 文件结构：
  - `PLAN_FILE` 基于 `templates/story/chapter-plan-template.md`，必须更新 TODO 表与尝试计数。
  - `EDITOR_LOG` 需记录审稿轮次、结论、评分、详细反馈与 TODO。
  - `DRAFT_FILE` 至少包含：
    1. `### Draft`
    2. `### Writer Notes`（写手列出潜在问题或待确认事项）
    3. `### Final Manuscript`（写手阶段留空）

### 详细步骤
1. **运行脚本 / 整理资料**
   - 在仓库根目录执行 `{SCRIPT}`，必要时附带 `--auto-count` / `-AutoCount`。
   - 解析 JSON，确认所有文件路径与当前 `AUTO_COUNT`；若值为 0 且解析出的 `auto_target` > 0，则视为授权连续创作 `auto_target` 章。
   - 准备参考资料：`project_overview.md`、`plots/outline.md`、`plots/arcs.md`、相关角色档案（含可能登场者）、时间线文件、`RECENT_FINALS` 终稿等。

2. **主编 persona：生成章节计划**
   - 以主编身份阅读资料，覆写 `PLAN_FILE`。
   - 填写章节目标、TODO 清单、参考资料路径、分段结构、人物要点、情节元素、风险提醒；更新“写手重写次数”“主编接管次数”。
   - 使用 `Shell` 命令覆写文件，随后 `ReadFile` 展示计划概要即可。

3. **写手 persona：撰写草稿**
   - 读取最新 `PLAN_FILE`，按照计划撰写草稿正文，将草稿写入 `DRAFT_FILE`。
   - `### Writer Notes` 中列出需要主编确认的风险或疑问，切勿写“无风险”。`### Final Manuscript` 保持空白。
   - 写入完成后，可用 `ReadFile` 展示草稿全文或摘要（一次即可）。

4. **主编 persona：审稿**
   - 再次阅读 `PLAN_FILE`、`DRAFT_FILE` 与参考资料，输出审稿结果：通过 / 小修 / 退稿。
   - 在 `EDITOR_LOG` 记录评分、详细反馈、建议动作，并同步更新 TODO。
   - 决策逻辑：
     - 若退稿，需将 `PLAN_FILE` 中“写手重写次数”加 1，并指导写手修改；写手重新执行步骤 3。
     - 若“写手重写次数”已达 2 仍不过关，主编需亲自修订或重写草稿直至可定稿，并将“主编接管次数”加 1。
     - 若仅需小修，可在后台修改 `DRAFT_FILE`，并记录修改内容。

5. **定稿与资料同步**
   - 审稿通过后，将最终文本填入 `DRAFT_FILE` 的 `### Final Manuscript`，并写入 `FINAL_FILE`。
   - 更新对应的时间线条目、角色档案连续性记录、以及必要的改写日志，均需引用 `LOG#`。
   - 使用 `ReadFile` 展示最终稿一次，随后输出简洁摘要。

6. **输出总结与自动续写**
   - 汇报本章摘要、审稿结论、关键更新文件、风险或待确认事项、当前尝试计数。
   - 若 `AUTO_COUNT`（或剩余计数）> 1 且流程成功，计算 `auto_remaining = AUTO_COUNT - 1`，提示“继续下一章（剩余 auto_remaining 章）”，重新执行 `{SCRIPT}` 并回到步骤 1。
   - 若遇阻（脚本失败、两轮退稿且主编仍无法定稿等），需立即停止自动续写并说明原因，等待作者指示。

在收到作者新的指令前，请保持在 `/draft` 模式内，不得主动切换到其他 Slash 命令或脚本。
