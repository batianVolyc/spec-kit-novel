#!/usr/bin/env bash

set -euo pipefail

JSON_MODE=false
FORCE_NEW=false
for arg in "$@"; do
    case "$arg" in
        --json)
            JSON_MODE=true
            ;;
        --fresh)
            FORCE_NEW=true
            ;;
        --help|-h)
            cat <<'USAGE'
Usage: start-spark-session.sh [--json] [--fresh]
  --json     Output machine-readable JSON
  --fresh    Ignore existing sessions and create a brand new file
USAGE
            exit 0
            ;;
        *)
            ;;
    esac
done

find_repo_root() {
    local dir="${1:-$(pwd)}"
    while [[ "$dir" != "/" ]]; do
        if [[ -d "$dir/.git" ]] || [[ -d "$dir/ideas" ]] || [[ -d "$dir/.specify" ]]; then
            echo "$dir"
            return 0
        fi
        dir="$(dirname "$dir")"
    done
    return 1
}

find_latest_session() {
    local dir="$1"
    find "$dir" -maxdepth 1 -type f -name 'session-*.md' -print 2>/dev/null | sort | tail -n 1
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(find_repo_root "$SCRIPT_DIR" 2>/dev/null || true)"
if [[ -z "$REPO_ROOT" ]]; then
    echo "Error: could not determine repository root" >&2
    exit 1
fi

IDEA_DIR="$REPO_ROOT/ideas"
mkdir -p "$IDEA_DIR"
LOG_DIR="$IDEA_DIR/conversation"
PENDING_DIR="$IDEA_DIR/pending"
mkdir -p "$LOG_DIR" "$PENDING_DIR"

SESSION_FILE=""
REUSED="false"

if [[ "$FORCE_NEW" == "false" ]]; then
    latest_session="$(find_latest_session "$IDEA_DIR")"
    if [[ -n "$latest_session" ]]; then
        SESSION_FILE="$latest_session"
        REUSED="true"
    fi
fi

if [[ -z "$SESSION_FILE" ]]; then
    session_stamp="$(date +%Y%m%d)"
    index=1
    while :; do
        suffix=$(printf "%02d" "$index")
        candidate="session-${session_stamp}_${suffix}.md"
        SESSION_FILE="$IDEA_DIR/$candidate"
        [[ -e "$SESSION_FILE" ]] || break
        index=$((index + 1))
        if [[ "$index" -gt 99 ]]; then
            echo "Error: too many idea sessions for today" >&2
            exit 1
        fi
    done

    TEMPLATE=""
    for candidate in \
        "$REPO_ROOT/.specify/templates/story/idea-session-template.md" \
        "$REPO_ROOT/templates/story/idea-session-template.md"; do
        if [[ -f "$candidate" ]]; then
            TEMPLATE="$candidate"
            break
        fi
    done

    if [[ -n "$TEMPLATE" ]]; then
        sed "s/\[DATE\]/$(date +%Y-%m-%d)/" "$TEMPLATE" > "$SESSION_FILE"
    else
        cat <<HEADER > "$SESSION_FILE"
# 创意基石 $(date +%Y-%m-%d)

### 创意概览
- 

### 人物设定
- 

### 世界与规则
- 

### 故事情节（已确认）
- 

### 风险与待决
- 

## 决策索引
- (引用 LOG#$(date +%Y%m%d)-01) 初始化
HEADER
    fi
fi

export NOVEL_IDEA_SESSION="$SESSION_FILE"
SESSION_NAME="$(basename "${SESSION_FILE}" .md)"
SESSION_LOG="$LOG_DIR/${SESSION_NAME}-conversation.md"
SESSION_PENDING="$PENDING_DIR/${SESSION_NAME}-pending.md"

export NOVEL_IDEA_SESSION_LOG="$SESSION_LOG"
export NOVEL_IDEA_SESSION_PENDING="$SESSION_PENDING"

if [[ ! -f "$SESSION_LOG" ]]; then
    session_label="$(date +%Y-%m-%d)"
    cat <<'LOG' > "$SESSION_LOG"
# /spark 对话记录 $session_label

> 仅记录用户与 /spark 之间的往返对话。请使用 `#### [LOG#YYYYMMDD-XX] 角色` 标题记录每条发言，XX 递增；正文保持原话，便于引用。

#### [LOG#$(date +%Y%m%d)-01] 系统

欢迎使用 `/spark`，请按照上述格式继续记录。

---

LOG
fi

if [[ ! -f "$SESSION_PENDING" ]]; then
    cat <<'PENDING' > "$SESSION_PENDING"
# /spark 待确认事项

- 记录所有尚未得到作者确认的提案、问题与待办，并标注来源 `LOG#`。
- 勾选或移动至创意基石前，请再次向作者确认。

---

PENDING
fi

if [[ "$JSON_MODE" == "true" ]]; then
    reuse_flag=$([[ "$REUSED" == "true" ]] && echo true || echo false)
    printf '{"REPO_ROOT":"%s","IDEA_DIR":"%s","SESSION_FILE":"%s","SESSION_LOG":"%s","SESSION_PENDING":"%s","REUSED":%s}\n' \
        "$REPO_ROOT" "$IDEA_DIR" "$SESSION_FILE" "$SESSION_LOG" "$SESSION_PENDING" "$reuse_flag"
else
    echo "REPO_ROOT: $REPO_ROOT"
    echo "IDEA_DIR: $IDEA_DIR"
    if [[ "$REUSED" == "true" ]]; then
        echo "SESSION_FILE: $SESSION_FILE (reused existing session)"
    else
        echo "SESSION_FILE: $SESSION_FILE"
    fi
    echo "SESSION_LOG: $SESSION_LOG"
    echo "SESSION_PENDING: $SESSION_PENDING"
fi
