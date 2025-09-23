#!/usr/bin/env bash

set -euo pipefail

JSON_MODE=false
for arg in "$@"; do
    case "$arg" in
        --json)
            JSON_MODE=true
            ;;
        --help|-h)
            cat <<USAGE
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
        if [[ -d "$dir/.git" ]] || [[ -d "$dir/logs" ]] || [[ -d "$dir/.specify" ]]; then
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

LOG_DIR="$REPO_ROOT/logs/adaptations"
mkdir -p "$LOG_DIR"

index_file="$LOG_DIR/index.md"
if [[ ! -f "$index_file" ]]; then
    cat <<IDX > "$index_file"
# Adaptation Log Index

- [adaptations_001-050.md](adaptations_001-050.md)
IDX
fi

select_log_file() {
    local latest=""
    local latest_end=0
    for file in "$LOG_DIR"/adaptations_*_*.md; do
        [[ -e "$file" ]] || continue
        base=$(basename "$file")
        if [[ "$base" =~ adaptations_([0-9]{3})-([0-9]{3})\.md ]]; then
            end=$((10#${BASH_REMATCH[2]}))
            if [[ "$end" -gt "$latest_end" ]]; then
                latest_end="$end"
                latest="$file"
            fi
        fi
    done
    if [[ -z "$latest" ]]; then
        echo ""
    else
        echo "$latest"
    fi
}

current_log=$(select_log_file)

if [[ -z "$current_log" ]]; then
    start=1
    end=50
else
    start=$(basename "$current_log" | sed -E 's/adaptations_([0-9]{3})-([0-9]{3})\.md/\1/')
    end=$(basename "$current_log" | sed -E 's/adaptations_([0-9]{3})-([0-9]{3})\.md/\2/')
    start=$((10#$start))
    end=$((10#$end))
fi

create_log_file() {
    local start_num="$1"
    local end_num="$2"
    local start_label=$(printf "%03d" "$start_num")
    local end_label=$(printf "%03d" "$end_num")
    local target="$LOG_DIR/adaptations_${start_label}-${end_label}.md"
    if [[ ! -f "$target" ]]; then
        TEMPLATE="$REPO_ROOT/.specify/templates/story/adaptation-log-template.md"
        if [[ -f "$TEMPLATE" ]]; then
            sed "s/\[RANGE\]/${start_label}-${end_label}/" "$TEMPLATE" > "$target"
        else
            cat <<LOG > "$target"
# Adaptation Log ${start_label}-${end_label}

| Entry | Date | Trigger | Affected Artifacts | Summary |
| ----- | ---- | ------- | ------------------ | ------- |
LOG
        fi
        if ! grep -q "adaptations_${start_label}-${end_label}.md" "$index_file"; then
            echo "- [adaptations_${start_label}-${end_label}.md](adaptations_${start_label}-${end_label}.md)" >> "$index_file"
        fi
    fi
    echo "$target"
}

should_rollover=false
if [[ -n "$current_log" ]]; then
    entry_count=$(grep -E '^\| [0-9]+' "$current_log" | wc -l | tr -d ' ')
    size_bytes=$(wc -c < "$current_log" | tr -d ' ')
    if [[ "$entry_count" -ge 50 ]] || [[ "$size_bytes" -ge 80000 ]]; then
        should_rollover=true
    fi
fi

if [[ "$should_rollover" == "true" ]]; then
    start=$((end + 1))
    end=$((start + 49))
    current_log="$(create_log_file "$start" "$end")"
else
    current_log="$(create_log_file "$start" "$end")"
fi

PROJECT_OVERVIEW="$REPO_ROOT/project_overview.md"

if $JSON_MODE; then
    printf '{"REPO_ROOT":"%s","ADAPTATION_LOG":"%s","INDEX_FILE":"%s","PROJECT_OVERVIEW":"%s"}\n' \
        "$REPO_ROOT" "$current_log" "$index_file" "$PROJECT_OVERVIEW"
else
    cat <<INFO
REPO_ROOT: $REPO_ROOT
ADAPTATION_LOG: $current_log
INDEX_FILE: $index_file
PROJECT_OVERVIEW: $PROJECT_OVERVIEW
INFO
fi
