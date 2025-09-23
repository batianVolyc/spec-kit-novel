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

    TEMPLATE="$REPO_ROOT/.specify/templates/story/idea-session-template.md"
    if [[ -f "$TEMPLATE" ]]; then
        sed "s/\[DATE\]/$(date +%Y-%m-%d)/" "$TEMPLATE" > "$SESSION_FILE"
    else
        cat <<HEADER > "$SESSION_FILE"
# Idea Session $(date +%Y-%m-%d)

## Initial Spark
> 

## Clarifying Questions

## Notes from Discussion

## Candidate Enhancements

## Decisions and Next Steps
HEADER
    fi
fi

export NOVEL_IDEA_SESSION="$SESSION_FILE"

if [[ "$JSON_MODE" == "true" ]]; then
    reuse_flag=$([[ "$REUSED" == "true" ]] && echo true || echo false)
    printf '{"REPO_ROOT":"%s","IDEA_DIR":"%s","SESSION_FILE":"%s","REUSED":%s}\n' \
        "$REPO_ROOT" "$IDEA_DIR" "$SESSION_FILE" "$reuse_flag"
else
    echo "REPO_ROOT: $REPO_ROOT"
    echo "IDEA_DIR: $IDEA_DIR"
    if [[ "$REUSED" == "true" ]]; then
        echo "SESSION_FILE: $SESSION_FILE (reused existing session)"
    else
        echo "SESSION_FILE: $SESSION_FILE"
    fi
fi
