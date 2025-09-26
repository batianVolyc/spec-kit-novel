# Local Development Guide

These notes help you iterate on the Spec Kit · Novel CLI without cutting a release. The process mirrors upstream Spec Kit, with the main differences being the story-focused templates and scripts.

## 1. Clone and Branch

```bash
git clone https://github.com/your-org/spec-kit-novel.git
cd spec-kit-novel
git checkout -b feature/my-experiment
```

## 2. Run the CLI In-Place

You can execute the CLI directly for fastest feedback:

```bash
python -m src.specify_cli --help
python -m src.specify_cli init demo-fiction --ai claude --ignore-agent-tools --script sh
```

or via the shebang:

```bash
python src/specify_cli/__init__.py check
```

## 3. Editable Install

```bash
uv venv
source .venv/bin/activate  # Windows PowerShell: .venv\Scripts\Activate.ps1
uv pip install -e .

specify --help
```

The editable install automatically picks up file changes under `src/`, `templates/`, `scripts/`, and `config/` thanks to the packaging configuration.

## 4. uvx From the Repo

```bash
uvx --from . specify init demo-novel --ai gemini --ignore-agent-tools --script ps
```

You can also target a pushed branch:

```bash
git push origin feature/my-experiment
uvx --from git+https://github.com/your-org/spec-kit-novel.git@feature/my-experiment specify init demo-branch
```

## 5. Verify Story Assets

After `specify init`, check that overlays worked:

```bash
ls ideas lore characters plots chapters timelines logs
ls .specify/templates/commands
cat project_overview.md
```

Scripts live in both `scripts/` and `.specify/scripts/` so Slash commands work regardless of agent path expectations.

## 6. Test Script Permissions (POSIX)

```bash
find scripts -name "*.sh" -maxdepth 2 -exec ls -l {} \;
```

## 7. Build a Wheel (Optional)

```bash
uv build
ls dist/
```

Install the resulting wheel inside a fresh virtual env to ensure templates/scripts/config were packaged correctly.

## 8. Reset Sandbox Quickly

```bash
rm -rf demo-fiction
python -m src.specify_cli init demo-fiction --ai claude --ignore-agent-tools --script sh
```

## 9. Rapid Reference

| Action | Command |
| ------ | ------- |
| Run CLI | `python -m src.specify_cli ...` |
| Editable install | `uv pip install -e .` |
| uvx from repo | `uvx --from . specify ...` |
| uvx from branch | `uvx --from git+URL@branch specify ...` |
| Build wheel | `uv build` |

## 10. Common Pitfalls

| Symptom | Fix |
|---------|-----|
| New command template not copied | Ensure it exists under `templates/commands` and rerun `specify init` |
| Missing prompt profiles | Copy `config/prompt-profiles.toml` into `.specify/config` (it references `memory/novel-playbook.md`) or re-run init |
| Timeline not rotating | Confirm chapter finals were written; rotation happens on finalisation |
| Adaptation log overflow | `/adapt` will create new volumes past entry 50 or ~80k characters |

Happy hacking—ping the repository with issues or ideas for additional story-centric helpers.
