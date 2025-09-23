# Installation Guide

Spec Kit · Novel reuses the upstream `specify` CLI but ships a different set of scripts, templates, and prompts tuned for fiction writing. Installation steps match the original toolkit, only the repository URL changes.

## Prerequisites

- Python **3.11+**
- [uv](https://docs.astral.sh/uv/) for installing/running the CLI
- [Git](https://git-scm.com/downloads)
- At least one supported AI assistant (Claude Code, Gemini CLI, Cursor, Copilot, Qwen Code, etc.)

## Install or Run Once

```bash
# Persistent installation (recommended)
uv tool install specify-cli --from git+https://github.com/batianVolyc/spec-kit-novel.git

# One-off execution
uvx --from git+https://github.com/batianVolyc/spec-kit-novel.git specify init <PROJECT_NAME>
```

`specify check` still validates available agents so you can confirm your environment before starting a session.

## Initialising a Project

```bash
specify init <PROJECT_NAME>
# or work in place
specify init --here
```

Useful flags:

| Flag | Purpose |
| ---- | ------- |
| `--ai <assistant>` | Pre-selects the AI agent (claude, gemini, copilot, cursor, qwen, opencode, codex, windsurf, kilocode, auggie, roo). |
| `--script {sh,ps}` | Force Bash or PowerShell automation scripts. Auto-detects from OS otherwise. |
| `--ignore-agent-tools` | Skip agent detection if you only want the templates. |
| `--no-git` | Prevents auto-initialising a Git repository. |
| `--here` / `--force` | Initialise inside the current directory, optionally overwriting existing files. |

All automation scripts ship in both Bash (`scripts/bash/*.sh`) and PowerShell (`scripts/powershell/*.ps1`) variants. The CLI copies them into your project and `.specify/scripts` so Slash commands can run on any platform.

## After Initialisation

You should see the novel toolkit directories:
- `ideas/`, `lore/`, `characters/`, `plots/`, `chapters/`, `timelines/`, `logs/adaptations/`
- `project_overview.md`
- `.specify/templates/commands` containing `/spark`, `/lore`, `/weave`, `/draft`, `/adapt`
- `.specify/config/prompt-profiles.toml` for prompt tuning

From there you can launch your AI agent and start with `/spark`.

## Troubleshooting

- **Missing scripts/templates** – Re-run `specify init` or copy from `.specify/templates/story` into your workspace.
- **Permission issues on macOS/Linux** – `specify init` ensures `.sh` files are executable. If you add custom scripts later, run `chmod +x` manually.
- **Git credential prompts** – Configure your preferred credential helper (e.g. Git Credential Manager) as you would for any Git-backed project.
