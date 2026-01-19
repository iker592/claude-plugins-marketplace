# Contributing

## Development Setup

```bash
cd enterprise-py-developer
claude --plugin-dir .
```

## Adding Components

### New Skill
Create `skills/skill-name/SKILL.md` with:
- Clear trigger keywords
- uv-based examples
- pytest for testing
- Docker with uv images

### New Command
Create `commands/command-name.md` following existing patterns.

### New Agent
Create `agents/agent-name.md` with expertise and delegation criteria.

## Testing

Test all changes locally before submitting:
```bash
claude --plugin-dir ./enterprise-py-developer
```

## Standards

- ✅ Use uv (NOT pip)
- ✅ Use pytest (NEVER unittest)
- ✅ Docker with uv base images
- ✅ Type hints required
- ✅ Format with ruff
