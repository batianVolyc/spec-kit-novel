# Repository Guidelines

## Project Structure & Module Organisation
Spec Kit · Novel extends the upstream Spec Kit CLI; runtime code lives under `src/specify_cli`, organised by Typer commands, template managers, and release helpers. Story-focused prompts and scaffolds stay in `templates/`, while cross-shell helpers sit in `scripts/bash` and `scripts/powershell`. Contributor-facing docs live in `docs/`, reference memory in `memory/`, and distributable config under `config/`. Include new assets in `pyproject.toml`'s force-include list so wheels ship a deterministic toolkit.

## Build, Test, and Development Commands
- `uv sync` — install Python 3.11 dependencies and local entry points.
- `uv run specify --help` — confirm the CLI wiring after edits.
- `uv run specify init demo-story --ai claude` — generate a sample workspace to validate templates end-to-end.
- `uv run pytest` — execute unit and integration tests (add them under `tests/`).
- `uv run ruff check src` — lint for style regressions when Ruff is available.

## Coding Style & Naming Conventions
Use standard Python formatting (4-space indentation, type hints, f-strings) and keep command functions small enough to read comfortably in Typer’s help output. Prefer `snake_case` for functions and module names, reserve `CamelCase` for classes, and document new CLI flags with concise docstrings. Templates should preserve existing placeholders such as `{SCRIPT}`, `$ARGUMENTS`, `{ARGS}`, or `{{args}}` so agent integrations stay compatible.

## Testing Guidelines
House new test modules in `tests/` and mirror the CLI feature they cover (e.g., `test_init.py`, `test_check.py`). Target functional coverage for new options, including the generated files they touch, and clean up temporary project directories in fixtures. Before opening a PR, run `uv run specify init` against a throwaway project to ensure scripts, templates, config, and memory overlays land correctly.

## Commit & Pull Request Guidelines
Match the Conventional Commit style used in history (e.g., `docs: require explicit slash transitions`) to keep changelog automation clean. Whenever `src/specify_cli/__init__.py` changes, bump the version in `pyproject.toml` and add a matching `CHANGELOG.md` entry. PRs should explain the problem, the solution, and any testing performed, with links to tracking issues when relevant. Flag breaking template or workflow adjustments so maintainers can coordinate release packaging updates.
