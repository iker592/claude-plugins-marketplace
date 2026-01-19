# Brain Plugin for Claude Code

Comprehensive Claude Code plugin for the **Brain** knowledge management system. Provides skills, commands, agents, hooks, and MCP servers for intelligent knowledge management, habit tracking, AI research, and personal productivity.

## 📦 What's Included

This single plugin contains **ALL** component types:

- **4 Skills** - Auto-invoked capabilities
- **4 Slash Commands** - User-invocable commands
- **4 Subagents** - Specialized expert personas
- **4 Hooks** - Lifecycle event handlers
- **3 MCP Servers** - External tool integrations

## 🎯 Component Overview

### Skills (`skills/`)
Auto-invoked by Claude when relevant keywords are detected:

| Skill | Triggers | Purpose |
|-------|----------|---------|
| **knowledge-search** | "find", "search", "where is" | Search Brain repository |
| **habit-tracker** | "log habit", "streak", "analyze" | Track and analyze habits |
| **ai-research** | "summarize paper", "explain concept" | AI/ML research assistant |
| **content-organizer** | "organize", "categorize", "structure" | Maintain Brain structure |

### Commands (`commands/`)
Slash commands you invoke directly:

| Command | Usage | Purpose |
|---------|-------|---------|
| **/brain:search** | `/brain:search <query>` | Search knowledge base |
| **/brain:add-habit** | `/brain:add-habit <habit:details>` | Log daily habit |
| **/brain:ai-summary** | `/brain:ai-summary <paper-url>` | Summarize AI paper |
| **/brain:plan-day** | `/brain:plan-day [date]` | Create daily plan |

### Agents (`agents/`)
Specialized experts Claude delegates to:

| Agent | Expertise | When to Delegate |
|-------|-----------|------------------|
| **knowledge-curator** | Repository organization | Complex reorganization tasks |
| **habit-analyst** | Behavioral analysis | Deep habit pattern analysis |
| **research-assistant** | AI/ML research | Literature reviews, learning paths |
| **project-planner** | Strategic planning | Project roadmaps, goal setting |

### Hooks (`hooks/`)
Automated workflows triggered by events:

| Hook | Event | Purpose |
|------|-------|---------|
| **auto-tag.sh** | PostToolUse (Write/Edit) | Add metadata tags to files |
| **session-start.sh** | SessionStart | Log session beginning |
| **session-end.sh** | SessionEnd | Generate session summary |
| **validate-command.sh** | PreToolUse (Bash) | Validate bash safety |

### MCP Servers (`servers/`)
External tool integrations:

| Server | Tools Provided | Purpose |
|--------|----------------|---------|
| **knowledge-server.py** | search_brain, get_file, list_topics | Brain repository access |
| **habit-api.py** | log_habit, get_streak, analyze_habits | Habit tracking tools |
| **web-research.py** | fetch_paper, search_arxiv, save_summary | Research paper tools |

## 🚀 Installation

### Local Installation

```bash
# Navigate to Brain directory
cd /home/user/Brain

# Test plugin locally
claude --plugin-dir ./brain-plugin

# Or add to Claude Code config
# ~/.claude/settings.json:
{
  "plugins": {
    "brain": {
      "path": "/home/user/Brain/brain-plugin"
    }
  }
}
```

### From GitHub (After Merge)

```bash
# Add plugin from GitHub
/plugin install iker592/Brain/brain-plugin

# Or add Brain as marketplace
/plugin marketplace add iker592/Brain
/plugin install brain
```

## 📖 Usage Examples

### Using Skills (Automatic)

```
You: "Find my notes on transformers"
Claude: [Auto-invokes knowledge-search skill]
       → "Found in AI-ML-DL/Architectures/transformers.md:15"

You: "What's my exercise streak?"
Claude: [Auto-invokes habit-tracker skill]
       → "7-day streak! Last logged: Jan 10"

You: "Explain attention mechanism"
Claude: [Auto-invokes ai-research skill]
       → [Provides detailed explanation]
```

### Using Commands (Manual)

```bash
# Search knowledge base
/brain:search quantum computing

# Log a habit
/brain:add-habit exercise:gym 60min upper body

# Summarize AI paper
/brain:ai-summary https://arxiv.org/abs/1706.03762

# Plan your day
/brain:plan-day tomorrow
```

### Delegating to Agents

```
You: "Reorganize my AI-ML-DL directory structure"
Claude: "This is a complex reorganization task.
         Let me delegate to the knowledge-curator agent."
        [Invokes knowledge-curator agent]

You: "Analyze my habit patterns this month"
Claude: [Delegates to habit-analyst agent]
        → [Generates comprehensive analysis report]

You: "Create learning roadmap for transformers"
Claude: [Delegates to research-assistant agent]
        → [Creates structured learning path]
```

### Hooks (Automatic)

```
# When you edit a file
You: "Edit IKER.md to update weight"
Claude: [Edits file]
Hook: auto-tag.sh runs → Adds "Last Updated: 2026-01-10"

# When session starts
Hook: session-start.sh → Logs to .claude/sessions/2026-01-10.log

# When session ends
Hook: session-end.sh → Appends summary to session log

# Before dangerous commands
You: "Run rm -rf /"
Hook: validate-command.sh → BLOCKS command, warns user
```

### MCP Servers (via Tools)

```
Claude uses MCP tools automatically:

search_brain("transformers") → Searches Brain
log_habit("exercise", "gym 60min") → Logs habit
fetch_paper("arxiv.org/abs/1234") → Fetches paper
```

## 🏗️ Directory Structure

```
brain-plugin/
├── .claude-plugin/
│   └── plugin.json           # Plugin manifest
├── skills/                   # Agent Skills (auto-invoked)
│   ├── knowledge-search/
│   │   ├── SKILL.md
│   │   └── reference.md
│   ├── habit-tracker/
│   │   └── SKILL.md
│   ├── ai-research/
│   │   └── SKILL.md
│   └── content-organizer/
│       └── SKILL.md
├── commands/                 # Slash commands
│   ├── search.md
│   ├── add-habit.md
│   ├── ai-summary.md
│   └── plan-day.md
├── agents/                   # Subagents
│   ├── knowledge-curator.md
│   ├── habit-analyst.md
│   ├── research-assistant.md
│   └── project-planner.md
├── hooks/                    # Lifecycle hooks
│   ├── hooks.json
│   └── scripts/
│       ├── auto-tag.sh
│       ├── session-start.sh
│       ├── session-end.sh
│       └── validate-command.sh
├── servers/                  # MCP servers
│   ├── knowledge-server.py
│   ├── habit-api.py
│   └── web-research.py
├── .mcp.json                # MCP configuration
├── README.md                # This file
├── CHANGELOG.md             # Version history
├── CONTRIBUTING.md          # Development guide
└── LICENSE                  # MIT License
```

## 🔧 Configuration

### Plugin Manifest (`.claude-plugin/plugin.json`)

```json
{
  "name": "brain",
  "version": "1.0.0",
  "description": "Comprehensive Brain knowledge management system plugin",
  "author": {
    "name": "Iker"
  },
  "keywords": ["knowledge-management", "habits", "ai-research"]
}
```

### Hooks Configuration (`hooks/hooks.json`)

```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Write|Edit",
      "hooks": [{"type": "command", "command": "..."}]
    }],
    "SessionStart": [...]
  }
}
```

### MCP Configuration (`.mcp.json`)

```json
{
  "mcpServers": {
    "brain-knowledge": {
      "command": "python3",
      "args": ["${CLAUDE_PLUGIN_ROOT}/servers/knowledge-server.py"]
    }
  }
}
```

## 🎨 Customization

### Adding New Skills

1. Create `skills/my-skill/SKILL.md`:
```yaml
---
name: my-skill
description: When to use this skill
allowed-tools: Read, Write
---

# My Skill
[Instructions for Claude]
```

2. Test: `claude --plugin-dir ./brain-plugin`

### Adding New Commands

1. Create `commands/my-command.md`:
```markdown
---
description: What this command does
---

# My Command
[Instructions using $ARGUMENTS]
```

2. Invoke: `/brain:my-command`

### Adding New Hooks

1. Create script in `hooks/scripts/my-hook.sh`
2. Add to `hooks/hooks.json`:
```json
{
  "PostToolUse": [{
    "matcher": "Tool",
    "hooks": [{"type": "command", "command": "..."}]
  }]
}
```

## 🧪 Testing

```bash
# Test plugin locally
claude --plugin-dir /home/user/Brain/brain-plugin

# Test specific skill
# Just use Claude and trigger the skill

# Test command
/brain:search test query

# Check hooks
# Edit a file and verify auto-tag runs

# Validate plugin structure
/plugin validate /home/user/Brain/brain-plugin
```

## 🐛 Troubleshooting

### Plugin Not Loading

```bash
# Check plugin.json is valid
cat plugins/.claude-plugin/plugin.json | jq

# Verify directory structure
ls -la plugins/

# Check Claude Code logs
tail -f ~/.claude/logs/claude.log
```

### Skills Not Triggering

- Check `description` field has trigger keywords
- Verify `SKILL.md` is in correct location
- Test with explicit keywords

### Commands Not Found

- Verify command file is in `commands/`
- Check markdown frontmatter is valid
- Invoke with correct syntax: `/brain:command-name`

### Hooks Not Running

- Verify scripts are executable: `chmod +x hooks/scripts/*.sh`
- Check `hooks.json` syntax
- Verify `${CLAUDE_PLUGIN_ROOT}` resolves correctly

### MCP Servers Not Starting

- Check Python is available: `python3 --version`
- Verify script permissions: `chmod +x servers/*.py`
- Test server manually: `python3 servers/knowledge-server.py`

## 📝 Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md) for development guidelines.

## 📜 License

MIT License - See [LICENSE](./LICENSE) for details.

## 🔗 Links

- **Repository:** https://github.com/iker592/Brain
- **Claude Code Docs:** https://code.claude.com/docs
- **MCP Protocol:** https://modelcontextprotocol.io

## ✨ Features Roadmap

### v1.1.0 (Planned)
- [ ] Enhanced habit analytics with correlations
- [ ] Multi-language content support
- [ ] Voice memo transcription skill
- [ ] Automated paper recommendations
- [ ] Smart cross-referencing

### v1.2.0 (Planned)
- [ ] Weekly/monthly habit summaries
- [ ] Learning path generator
- [ ] Content quality scoring
- [ ] Duplicate detection
- [ ] Advanced search with ML

### v2.0.0 (Future)
- [ ] Mobile app integration
- [ ] Cloud sync support
- [ ] Collaborative features
- [ ] Advanced AI features
- [ ] Plugin marketplace

## 📊 Statistics

- **Total Files:** 35+
- **Skills:** 4 (auto-invoked)
- **Commands:** 4 (user-invoked)
- **Agents:** 4 (specialized experts)
- **Hooks:** 4 (event-driven)
- **MCP Servers:** 3 (external tools)
- **Lines of Code:** 5000+
- **Documentation:** Comprehensive

## 🙏 Acknowledgments

Built with:
- Claude Code by Anthropic
- Model Context Protocol (MCP)
- Brain Knowledge Management System

---

**Version:** 1.0.0
**Last Updated:** January 10, 2026
**Maintained by:** Iker
