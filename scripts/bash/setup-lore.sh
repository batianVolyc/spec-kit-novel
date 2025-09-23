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
mkdir -p "$LORE_DIR" "$CHAR_DIR"

WORLD_FILE="$LORE_DIR/world.md"
WORLD_TEMPLATE="$REPO_ROOT/.specify/templates/story/world-template.md"
if [[ ! -f "$WORLD_FILE" ]]; then
    if [[ -f "$WORLD_TEMPLATE" ]]; then
        sed "s/\[TITLE\]/TODO Title/" "$WORLD_TEMPLATE" > "$WORLD_FILE"
    else
        echo "# World Overview" > "$WORLD_FILE"
        echo "(fill in after /lore)" >> "$WORLD_FILE"
    fi
fi

ROSTER_FILE="$CHAR_DIR/roster.md"
if [[ ! -f "$ROSTER_FILE" ]]; then
    cat <<ROSTER > "$ROSTER_FILE"
# Character Roster

| Name | Role | Status |
| ---- | ---- | ------ |
ROSTER
fi

CHAR_TEMPLATE="$REPO_ROOT/.specify/templates/story/character-template.md"

if $JSON_MODE; then
    printf '{"REPO_ROOT":"%s","WORLD_FILE":"%s","CHARACTERS_DIR":"%s","CHARACTER_TEMPLATE":"%s","ROSTER_FILE":"%s"}\n' \
        "$REPO_ROOT" "$WORLD_FILE" "$CHAR_DIR" "$CHAR_TEMPLATE" "$ROSTER_FILE"
else
    cat <<INFO
REPO_ROOT: $REPO_ROOT
WORLD_FILE: $WORLD_FILE
CHARACTERS_DIR: $CHAR_DIR
CHARACTER_TEMPLATE: $CHAR_TEMPLATE
ROSTER_FILE: $ROSTER_FILE
INFO
fi
