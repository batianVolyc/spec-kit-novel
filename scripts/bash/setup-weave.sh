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
mkdir -p "$PLOTS_DIR"

OUTLINE_FILE="$PLOTS_DIR/outline.md"
OUTLINE_TEMPLATE="$REPO_ROOT/.specify/templates/story/outline-template.md"
if [[ ! -f "$OUTLINE_FILE" ]]; then
    if [[ -f "$OUTLINE_TEMPLATE" ]]; then
        sed "s/\[TITLE\]/TODO Title/" "$OUTLINE_TEMPLATE" > "$OUTLINE_FILE"
    else
        echo "# Story Outline" > "$OUTLINE_FILE"
    fi
fi

ARCS_FILE="$PLOTS_DIR/arcs.md"
ARCS_TEMPLATE="$REPO_ROOT/.specify/templates/story/arc-template.md"
if [[ ! -f "$ARCS_FILE" ]]; then
    if [[ -f "$ARCS_TEMPLATE" ]]; then
        sed "s/ARC-1/ARC-1/" "$ARCS_TEMPLATE" > "$ARCS_FILE"
    else
        echo "# Plot Arcs" > "$ARCS_FILE"
    fi
fi

PROJECT_OVERVIEW="$REPO_ROOT/project_overview.md"
PROJECT_TEMPLATE="$REPO_ROOT/.specify/templates/story/project-overview-template.md"
if [[ ! -f "$PROJECT_OVERVIEW" ]]; then
    if [[ -f "$PROJECT_TEMPLATE" ]]; then
        sed "s/\[TITLE\]/TODO Title/" "$PROJECT_TEMPLATE" > "$PROJECT_OVERVIEW"
    else
        cat <<OV > "$PROJECT_OVERVIEW"
# Project Overview

(Generated after /weave completes.)
OV
    fi
fi

if $JSON_MODE; then
    printf '{"REPO_ROOT":"%s","PLOTS_DIR":"%s","OUTLINE_FILE":"%s","ARCS_FILE":"%s","PROJECT_OVERVIEW":"%s"}\n' \
        "$REPO_ROOT" "$PLOTS_DIR" "$OUTLINE_FILE" "$ARCS_FILE" "$PROJECT_OVERVIEW"
else
    cat <<INFO
REPO_ROOT: $REPO_ROOT
PLOTS_DIR: $PLOTS_DIR
OUTLINE_FILE: $OUTLINE_FILE
ARCS_FILE: $ARCS_FILE
PROJECT_OVERVIEW: $PROJECT_OVERVIEW
INFO
fi
