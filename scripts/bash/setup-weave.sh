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
        if [[ -d "$dir/.git" ]] || [[ -d "$dir/plots" ]] || [[ -d "$dir/.specify" ]]; then
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

PLOTS_DIR="$REPO_ROOT/plots"
LOG_DIR="$PLOTS_DIR/conversation"
PENDING_DIR="$PLOTS_DIR/pending"
mkdir -p "$PLOTS_DIR" "$LOG_DIR" "$PENDING_DIR"

OUTLINE_FILE="$PLOTS_DIR/outline.md"
OUTLINE_TEMPLATE=""
for candidate in \
    "$REPO_ROOT/.specify/templates/story/outline-template.md" \
    "$REPO_ROOT/templates/story/outline-template.md"; do
    if [[ -f "$candidate" ]]; then
        OUTLINE_TEMPLATE="$candidate"
        break
    fi
done
if [[ ! -f "$OUTLINE_FILE" ]]; then
    if [[ -n "$OUTLINE_TEMPLATE" ]]; then
        sed "s/\[TITLE\]/TODO Title/" "$OUTLINE_TEMPLATE" > "$OUTLINE_FILE"
    else
        echo "# Story Outline" > "$OUTLINE_FILE"
    fi
fi

ARCS_FILE="$PLOTS_DIR/arcs.md"
ARCS_TEMPLATE=""
for candidate in \
    "$REPO_ROOT/.specify/templates/story/arc-template.md" \
    "$REPO_ROOT/templates/story/arc-template.md"; do
    if [[ -f "$candidate" ]]; then
        ARCS_TEMPLATE="$candidate"
        break
    fi
done
if [[ ! -f "$ARCS_FILE" ]]; then
    if [[ -n "$ARCS_TEMPLATE" ]] ; then
        sed "s/ARC-1/ARC-1/" "$ARCS_TEMPLATE" > "$ARCS_FILE"
    else
        echo "# Plot Arcs" > "$ARCS_FILE"
    fi
fi

PROJECT_OVERVIEW="$REPO_ROOT/project_overview.md"
PROJECT_TEMPLATE=""
for candidate in \
    "$REPO_ROOT/.specify/templates/story/project-overview-template.md" \
    "$REPO_ROOT/templates/story/project-overview-template.md"; do
    if [[ -f "$candidate" ]]; then
        PROJECT_TEMPLATE="$candidate"
        break
    fi
done
if [[ ! -f "$PROJECT_OVERVIEW" ]]; then
    if [[ -n "$PROJECT_TEMPLATE" ]]; then
        sed "s/\[TITLE\]/TODO Title/" "$PROJECT_TEMPLATE" > "$PROJECT_OVERVIEW"
    else
        cat <<'OV' > "$PROJECT_OVERVIEW"
# Project Overview

(Generated after /weave completes.)
OV
    fi
fi

LOG_FILE="$LOG_DIR/weave-$(date +%Y%m%d).md"
if [[ ! -f "$LOG_FILE" ]]; then
    cat <<'LOG' > "$LOG_FILE"
# /weave 对话记录 $(date +%Y-%m-%d)

> 记录与 /weave 相关的讨论。每条发言请使用 `#### [LOG#YYYYMMDD-XX] 角色` 标题继续编号，正文保持原话，可在行尾添加标签。待确认决策请同步到 pending 清单。

#### [LOG#$(date +%Y%m%d)-01] 系统

欢迎使用 `/weave`，请沿用以上格式写入新的对话记录。

---

LOG
fi

PENDING_FILE="$PENDING_DIR/todo.md"
if [[ ! -f "$PENDING_FILE" ]]; then
    cat <<'PENDING' > "$PENDING_FILE"
# /weave 待确认事项

- 汇总尚未确认的结构调整、篇章安排与节奏建议，并标注来源 `LOG#`。
- 作者确认后，再写入 `outline.md`、`arcs.md` 等正式文档。

---

PENDING
fi

if $JSON_MODE; then
    printf '{"REPO_ROOT":"%s","PLOTS_DIR":"%s","OUTLINE_FILE":"%s","ARCS_FILE":"%s","PROJECT_OVERVIEW":"%s","LOG_FILE":"%s","PENDING_FILE":"%s"}\n' \
        "$REPO_ROOT" "$PLOTS_DIR" "$OUTLINE_FILE" "$ARCS_FILE" "$PROJECT_OVERVIEW" "$LOG_FILE" "$PENDING_FILE"
else
    cat <<'INFO'
REPO_ROOT: $REPO_ROOT
PLOTS_DIR: $PLOTS_DIR
OUTLINE_FILE: $OUTLINE_FILE
ARCS_FILE: $ARCS_FILE
PROJECT_OVERVIEW: $PROJECT_OVERVIEW
LOG_FILE: $LOG_FILE
PENDING_FILE: $PENDING_FILE
INFO
fi
