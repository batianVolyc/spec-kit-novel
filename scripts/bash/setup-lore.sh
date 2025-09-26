#!/usr/bin/env bash

set -euo pipefail

JSON_MODE=false
for arg in "$@"; do
    case "$arg" in
        --json)
            JSON_MODE=true
            ;;
        --help|-h)
            cat <<'USAGE'
Usage: $0 [--json]
  --json    Output machine-readable JSON
USAGE
            exit 0
            ;;
        *) ;;
    esac
done

find_repo_root() {
    local dir="${1:-$(pwd)}"
    while [[ "$dir" != "/" ]]; do
        if [[ -d "$dir/.git" ]] || [[ -d "$dir/lore" ]] || [[ -d "$dir/.specify" ]]; then
            echo "$dir"
            return 0
        fi
        dir="$(dirname "$dir")"
    done
    return 1
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(find_repo_root "$SCRIPT_DIR" 2>/dev/null || true)"
if [[ -z "$REPO_ROOT" ]]; then
    echo "Error: could not determine repository root" >&2
    exit 1
fi

LORE_DIR="$REPO_ROOT/lore"
CHAR_DIR="$REPO_ROOT/characters"
LOG_DIR="$LORE_DIR/conversation"
PENDING_DIR="$LORE_DIR/pending"
mkdir -p "$LORE_DIR" "$CHAR_DIR" "$LOG_DIR" "$PENDING_DIR"

WORLD_FILE="$LORE_DIR/world.md"
WORLD_TEMPLATE=""
for candidate in \
    "$REPO_ROOT/.specify/templates/story/world-template.md" \
    "$REPO_ROOT/templates/story/world-template.md"; do
    if [[ -f "$candidate" ]]; then
        WORLD_TEMPLATE="$candidate"
        break
    fi
done
if [[ ! -f "$WORLD_FILE" ]]; then
    if [[ -n "$WORLD_TEMPLATE" ]]; then
        sed "s/\[TITLE\]/TODO Title/" "$WORLD_TEMPLATE" > "$WORLD_FILE"
    else
        cat <<'WORLD_FALLBACK' > "$WORLD_FILE"
# 世界设定概览

**故事标题**： TODO Title
**题材风格**： 
**主要时代 / 地点**： 
**超自然或科技设定**： 

## 核心支柱
- **主题焦点**： 
- **情绪氛围**： 
- **冲突核心**： 

## 地理与社会结构
| 项目 | 说明 |
| ---- | ---- |
| 中心城市 / 关键地点 | 
| 地理区域与地标 | 
| 社会阶层与权力分配 | 
| 技术或文化发展水平 | 
| 经济与贸易特点 | 

## 能力体系与限制
- **能力 / 技艺**： 
- **限制与代价**： 
- **规训与禁忌**： 

## 历史脉络
1. **近期事件** —— 
2. **隐秘真相** —— 
3. **紧张热点** —— 

## 文化风貌
- **礼俗与仪式**： 
- **语言与表达**： 
- **日常生活与饮食**： 
- **信仰体系**： 

## 故事钩子
- **开端契机**： 
- **前期筹码**： 
- **后续升级路径**： 

## 待补充问题
- 

## 决策索引
- (引用 LOG#) 
WORLD_FALLBACK
    fi
fi

ROSTER_FILE="$CHAR_DIR/roster.md"
if [[ ! -f "$ROSTER_FILE" ]]; then
    cat <<'ROSTER' > "$ROSTER_FILE"
# Character Roster

| Name | Role | Status |
| ---- | ---- | ------ |
ROSTER
fi

CHAR_TEMPLATE=""
for candidate in \
    "$REPO_ROOT/.specify/templates/story/character-template.md" \
    "$REPO_ROOT/templates/story/character-template.md"; do
    if [[ -f "$candidate" ]]; then
        CHAR_TEMPLATE="$candidate"
        break
    fi
done

LOG_FILE="$LOG_DIR/lore-$(date +%Y%m%d).md"
if [[ ! -f "$LOG_FILE" ]]; then
    cat <<'LOG' > "$LOG_FILE"
# /lore 对话记录 $(date +%Y-%m-%d)

> 记录与 /lore 相关的往返内容。每条发言请使用 `#### [LOG#YYYYMMDD-XX] 角色` 标题继续编号，正文保持原话，可在行尾添加标签。

#### [LOG#$(date +%Y%m%d)-01] 系统

欢迎使用 `/lore`，请沿用以上格式写入新的对话记录。

---

LOG
fi

PENDING_FILE="$PENDING_DIR/todo.md"
if [[ ! -f "$PENDING_FILE" ]]; then
    cat <<'PENDING' > "$PENDING_FILE"
# /lore 待确认事项

- 收录尚未获得作者确认的设定、问题与行动项，并标注来源 `LOG#`。
- 在写入世界观或角色档案前，请再次与作者确认并勾选完成。

---

PENDING
fi

if $JSON_MODE; then
    printf '{"REPO_ROOT":"%s","WORLD_FILE":"%s","CHARACTERS_DIR":"%s","CHARACTER_TEMPLATE":"%s","ROSTER_FILE":"%s","LOG_FILE":"%s","PENDING_FILE":"%s"}\n' \
        "$REPO_ROOT" "$WORLD_FILE" "$CHAR_DIR" "$CHAR_TEMPLATE" "$ROSTER_FILE" "$LOG_FILE" "$PENDING_FILE"
else
    cat <<'INFO'
REPO_ROOT: $REPO_ROOT
WORLD_FILE: $WORLD_FILE
CHARACTERS_DIR: $CHAR_DIR
CHARACTER_TEMPLATE: $CHAR_TEMPLATE
ROSTER_FILE: $ROSTER_FILE
LOG_FILE: $LOG_FILE
PENDING_FILE: $PENDING_FILE
INFO
fi
