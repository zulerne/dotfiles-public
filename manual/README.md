# Manual Configs

Files that are not managed by stow — copy manually.

## Claude Code (`~/.claude/`)

Save changes from current machine to repo:

```bash
cp ~/.claude/CLAUDE.md manual/claude/
cp ~/.claude/settings.json manual/claude/
cp ~/.claude/keybindings.json manual/claude/
cp -R ~/.claude/skills/ manual/claude/skills/
```

Apply configs on a new machine:

```bash
cp manual/claude/CLAUDE.md ~/.claude/
cp manual/claude/settings.json ~/.claude/
cp manual/claude/keybindings.json ~/.claude/
cp -R manual/claude/skills/ ~/.claude/skills/
```
