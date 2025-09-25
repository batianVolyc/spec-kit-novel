# Repository Guidelines

## Project Structure & Module Organization
Spec Kit · Novel extends the upstream Spec Kit CLI; all runtime code lives under `src/specify_cli`, organised by Typer commands, template managers, and release helpers. Story-focused prompts and scaffolds stay in `templates/`, while cross-shell helpers sit in `scripts/bash` and `scripts/powershell`. Contributor-facing docs live in `docs/`, reference memory in `memory/`, and distributable config under `config/`. When you add shipping assets, mirror the existing `pyproject.toml` include rules so packaging stays deterministic.

## Build, Test, and Development Commands
- `uv sync` — install Python 3.11 dependencies and local entry points.
- `uv run specify --help` — confirm the CLI is wired correctly before deeper work.
- `uv run specify init demo-story --ai claude` — generate a sample workspace to validate templates end-to-end.
- `uv run pytest` — execute unit and integration tests (add them under `tests/`).
- `uv run ruff check src` — lint for style regressions when Ruff is available.

## Coding Style & Naming Conventions
Use standard Python formatting (4-space indentation, type hints, f-strings) and keep command functions small enough to read comfortably in Typer’s help output. Favour `snake_case` for functions and module names, reserve `CamelCase` for classes, and document new CLI flags with concise docstrings. Templates should preserve existing placeholders such as `{SCRIPT}`, `$ARGUMENTS`, or `{{args}}` to keep agent integrations consistent.

## Testing Guidelines
House new test modules in `tests/` and mirror the CLI feature they exercise (e.g., `test_init.py`, `test_check.py`). Target functional coverage for new options, including the generated files they touch, and clean up temporary project directories in fixtures. Before opening a PR, run `uv run specify init` against a throwaway project to ensure scripts, templates, and agents collaborate without manual tweaks.

## Commit & Pull Request Guidelines
Match the Conventional Commit style used in history (e.g., `docs: require explicit slash transitions`) to keep changelog automation clean. Whenever `src/specify_cli/__init__.py` changes, bump the version in `pyproject.toml` and add a matching `CHANGELOG.md` entry. PRs should explain the problem, the solution, and any testing performed, with links to tracking issues when relevant. Flag breaking template or workflow adjustments so maintainers can coordinate release packaging updates.
