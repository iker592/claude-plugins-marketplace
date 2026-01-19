# Contributing to Brain Plugin

Thank you for your interest in contributing to the Brain plugin for Claude Code! This guide will help you add new features and maintain the plugin.

## 📋 Table of Contents

- [Development Setup](#development-setup)
- [Plugin Architecture](#plugin-architecture)
- [Adding Components](#adding-components)
- [Testing](#testing)
- [Code Standards](#code-standards)
- [Contribution Workflow](#contribution-workflow)

## 🛠️ Development Setup

### Prerequisites

- Claude Code CLI installed
- Python 3.8+ (for MCP servers)
- Bash shell (for hooks)
- Git for version control

### Local Development

```bash
# Clone the repository
git clone https://github.com/iker592/Brain.git
cd Brain/brain-plugin

# Test plugin locally
claude --plugin-dir .

# Or symlink to Claude config
ln -s $(pwd) ~/.claude/brain-plugin/brain
```

## 🏗️ Plugin Architecture

### Directory Structure

```
brain-plugin/
├── .claude-plugin/
│   └── plugin.json       # ONLY plugin.json goes here
├── skills/               # Auto-invoked agent skills
├── commands/             # User-invocable slash commands
├── agents/               # Specialized subagent personas
├── hooks/                # Lifecycle event handlers
├── servers/              # MCP server implementations
├── .mcp.json            # MCP configuration
├── README.md            # User documentation
├── CHANGELOG.md         # Version history
├── CONTRIBUTING.md      # This file
└── LICENSE              # MIT License
```

### Key Principles

1. **Single Plugin** - All components in ONE plugin directory
2. **Component Isolation** - Each type in its own subdirectory
3. **Progressive Disclosure** - Documentation from simple to advanced
4. **Brain Integration** - Aware of repository structure and IKER.md
5. **Security First** - Validate inputs, restrict tools appropriately

## ➕ Adding Components

### Adding a New Skill

Skills are automatically invoked by Claude when trigger keywords are detected.

**Steps:**

1. Create skill directory:
```bash
mkdir -p skills/my-skill
```

2. Create `skills/my-skill/SKILL.md`:
```yaml
---
name: my-skill
description: Clear description with TRIGGER KEYWORDS that tell Claude when to use this. Keywords like "keyword1", "keyword2", "keyword3".
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, WebFetch
model: sonnet
user-invocable: true
---

# My Skill Name

Brief overview of what this skill does.

## Quick Start

Core functionality explained in 3-5 bullet points.

## Detailed Instructions

Comprehensive instructions for Claude on how to use this skill.

## Usage Examples

```
User: "trigger keyword example"
Skill: [What the skill does]
Output: [Expected result]
```

## Integration

How this skill integrates with Brain repository.
```

3. (Optional) Add detailed reference:
```bash
# skills/my-skill/reference.md
Advanced documentation, algorithms, API details
```

4. **Important:** Add trigger keywords in description that Claude will match

5. Test skill:
```bash
claude --plugin-dir .
# Then trigger your skill with keywords
```

**Best Practices:**
- Use clear, specific trigger keywords in description
- Set `allowed-tools` to minimum needed
- Provide progressive disclosure (SKILL.md + reference.md for complex skills)
- Include practical examples
- Consider security (avoid unrestricted Bash/Write)

### Adding a New Command

Commands are slash commands that users invoke explicitly.

**Steps:**

1. Create `commands/my-command.md`:
```markdown
---
description: Brief description of what this command does
---

# My Command

Detailed instructions for Claude explaining what to do when the user
runs this command.

## Usage

```
/brain:my-command <argument>
/brain:my-command arg1 arg2
```

## Instructions

When the user runs this command:

1. Parse arguments from `$ARGUMENTS`
2. Validate inputs
3. Perform action (maybe invoke a skill)
4. Return result

## Examples

```
/brain:my-command example
→ Does X, Y, Z
→ Returns: [result]
```

Provide clear, actionable output with proper formatting.
```

2. Test command:
```bash
claude --plugin-dir .
# Then run: /brain:my-command test
```

**Best Practices:**
- Use kebab-case for command names
- Parse `$ARGUMENTS` carefully
- Provide usage examples
- Handle errors gracefully
- Keep commands focused (single purpose)

### Adding a New Agent

Agents are specialized personas Claude delegates complex tasks to.

**Steps:**

1. Create `agents/my-agent.md`:
```yaml
---
name: my-agent
description: Expertise area. Claude delegates when [specific scenarios]. Clear delegation criteria.
tools: Read, Write, Edit, Grep, Glob, Bash
model: sonnet
permissionMode: default
---

# My Agent Name

You are a [specialist] helping Iker with [specific tasks].

## Your Expertise

- Expert skill 1
- Expert skill 2
- Expert skill 3

## When Invoked

You are delegated tasks involving:
1. Task type 1
2. Task type 2
3. Task type 3

## Context: Iker's Situation

[Relevant context from IKER.md]
- Background info
- Current goals
- Constraints

## Your Approach

### 1. Discovery Phase
Understand the task and requirements

### 2. Analysis Phase
Assess complexity and resources needed

### 3. Execution Phase
Execute the task methodically

### 4. Reporting Phase
Report results clearly

## Task Examples

### Task: [Example Task]

**Execution:**
1. Step 1
2. Step 2
3. Step 3

Result: [Clear outcome]

## Success Criteria

Your work is successful when:
1. Criterion 1
2. Criterion 2
3. Iker is satisfied with the outcome

Remember: [Key principle for this agent's work]

---
**Specialization:** [Area]
**Model:** Sonnet
**Permission Mode:** [default/acceptEdits/plan/etc.]
```

2. Choose appropriate permission mode:
   - `default` - Ask for confirmation on edits
   - `acceptEdits` - Auto-accept file changes
   - `plan` - Read-only, no edits
   - `dontAsk` - Auto-deny prompts
   - `bypassPermissions` - Skip all checks (use sparingly!)

3. Test agent delegation:
```bash
claude --plugin-dir .
# Describe a task that should trigger delegation
```

**Best Practices:**
- Define clear delegation criteria in description
- Set appropriate tools (minimum needed)
- Choose right permission mode for safety
- Provide detailed context and examples
- Include success criteria

### Adding a New Hook

Hooks are scripts that run automatically on lifecycle events.

**Steps:**

1. Create hook script:
```bash
# hooks/scripts/my-hook.sh

#!/bin/bash
# Description of what this hook does

# Hook receives context as arguments
ARGUMENT="$1"

# Your hook logic here
echo "Hook executed"

# Exit 0 for success, 1 to block/fail
exit 0
```

2. Make executable:
```bash
chmod +x hooks/scripts/my-hook.sh
```

3. Add to `hooks/hooks.json`:
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Tool|Pattern",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/hooks/scripts/my-hook.sh",
            "description": "What this hook does",
            "once": false
          }
        ]
      }
    ]
  }
}
```

4. Test hook:
```bash
claude --plugin-dir .
# Trigger the event that should run your hook
```

**Available Events:**
- `PreToolUse` - Before tool execution (can block)
- `PostToolUse` - After tool execution
- `PostToolUseFailure` - After tool fails
- `PermissionRequest` - When permission dialog shown
- `UserPromptSubmit` - When user submits prompt
- `SessionStart` - Session beginning
- `SessionEnd` - Session ending
- `SubagentStart` / `SubagentStop` - Subagent lifecycle
- `PreCompact` - Before context compaction

**Matcher Patterns:**
- `""` - Match all
- `"Tool"` - Match specific tool
- `"Tool1|Tool2"` - Match multiple tools
- Regular expressions supported

**Best Practices:**
- Keep hooks fast (avoid heavy computation)
- Use `${CLAUDE_PLUGIN_ROOT}` for paths
- Handle errors gracefully
- Log to appropriate locations
- Use `once: true` for one-time hooks

### Adding a New MCP Server

MCP servers provide external tools to Claude via the Model Context Protocol.

**Steps:**

1. Create server script:
```python
#!/usr/bin/env python3
"""
My MCP Server - Brief description
"""

import json
import sys
from pathlib import Path

class MyMCPServer:
    """MCP Server implementation"""

    def __init__(self):
        # Initialize with environment variables
        pass

    def tool_one(self, param: str) -> dict:
        """First tool implementation"""
        return {
            "tool": "tool_one",
            "result": "..."
        }

    def tool_two(self, param: str) -> dict:
        """Second tool implementation"""
        return {
            "tool": "tool_two",
            "result": "..."
        }

def main():
    """MCP Server entry point"""
    server = MyMCPServer()

    # Print tool definitions
    print(json.dumps({
        "server": "my-server",
        "version": "1.0.0",
        "tools": [
            {
                "name": "tool_one",
                "description": "What this tool does",
                "parameters": {
                    "param": "string"
                }
            },
            {
                "name": "tool_two",
                "description": "What this tool does",
                "parameters": {
                    "param": "string"
                }
            }
        ]
    }))

if __name__ == "__main__":
    main()
```

2. Make executable:
```bash
chmod +x servers/my-server.py
```

3. Add to `.mcp.json`:
```json
{
  "mcpServers": {
    "my-server": {
      "command": "python3",
      "args": ["${CLAUDE_PLUGIN_ROOT}/servers/my-server.py"],
      "env": {
        "MY_VAR": "${CLAUDE_PROJECT_DIR}"
      }
    }
  }
}
```

4. Test server:
```bash
python3 servers/my-server.py
# Should output JSON with tool definitions
```

**Best Practices:**
- Use Python 3.8+ (widely available)
- Handle errors and edge cases
- Validate inputs
- Return structured JSON
- Document tool parameters clearly
- Use environment variables for paths

## 🧪 Testing

### Local Testing

```bash
# Test entire plugin
claude --plugin-dir /home/user/Brain/brain-plugin

# Test with multiple plugins
claude --plugin-dir ./brain-plugin --plugin-dir ./other-plugin

# Validate plugin structure
/plugin validate /home/user/Brain/brain-plugin
```

### Component Testing

**Test Skills:**
```bash
# Invoke Claude and use trigger keywords
claude --plugin-dir .
User: "search for transformers"  # Should trigger knowledge-search skill
```

**Test Commands:**
```bash
claude --plugin-dir .
/brain:search test query
/brain:add-habit exercise:test
```

**Test Agents:**
```bash
# Describe complex task that should delegate
claude --plugin-dir .
User: "Reorganize my entire AI-ML-DL directory"
# Should delegate to knowledge-curator agent
```

**Test Hooks:**
```bash
# Trigger the event
claude --plugin-dir .
# Edit a file → PostToolUse hook should run
# Check logs or side effects
```

**Test MCP Servers:**
```bash
# Test server standalone
python3 servers/knowledge-server.py

# Test within Claude
claude --plugin-dir .
# Claude should have access to MCP tools
```

### Validation Checklist

Before submitting:

- [ ] Plugin.json is valid JSON
- [ ] All skills have clear trigger keywords
- [ ] Commands have usage examples
- [ ] Agents have delegation criteria
- [ ] Hooks are executable (`chmod +x`)
- [ ] MCP servers are executable
- [ ] No hardcoded paths (use `${CLAUDE_PLUGIN_ROOT}`)
- [ ] Documentation is clear and complete
- [ ] CHANGELOG.md updated
- [ ] Version bumped in plugin.json (if needed)

## 📏 Code Standards

### Markdown Files

- Use ATX headings (`#`, `##`, `###`)
- Include YAML frontmatter for skills, commands, agents
- Provide examples for all features
- Use code fences with language hints
- Keep lines under 100 characters when possible

### Shell Scripts

```bash
#!/bin/bash
# Always include shebang and description

# Use descriptive variable names
FILE_PATH="$1"

# Check prerequisites
if [[ ! -f "$FILE_PATH" ]]; then
    echo "Error: File not found"
    exit 1
fi

# Use ${CLAUDE_PLUGIN_ROOT} for paths
SCRIPT_DIR="${CLAUDE_PLUGIN_ROOT}/hooks/scripts"

# Exit with appropriate code
exit 0
```

### Python Scripts

```python
#!/usr/bin/env python3
"""
Module docstring explaining purpose
"""

import json
import sys
from pathlib import Path

class MyServer:
    """Class docstring"""

    def __init__(self):
        """Initialize with environment variables"""
        pass

    def my_method(self, param: str) -> dict:
        """Method docstring with type hints"""
        return {"result": "..."}

def main():
    """Entry point docstring"""
    pass

if __name__ == "__main__":
    main()
```

### JSON Files

- Use 2-space indentation
- Validate with `jq` before committing
- Include comments where helpful (via `description` fields)
- Use environment variables for dynamic paths

## 🔄 Contribution Workflow

### Making Changes

1. **Fork and clone:**
```bash
git clone https://github.com/YOUR_USERNAME/Brain.git
cd Brain/brain-plugin
```

2. **Create feature branch:**
```bash
git checkout -b feature/my-new-feature
```

3. **Make changes:**
   - Add new component
   - Update documentation
   - Test thoroughly

4. **Update version:**
```json
// .claude-plugin/plugin.json
{
  "version": "1.1.0"  // Bump appropriately
}
```

5. **Update CHANGELOG:**
```markdown
## [1.1.0] - YYYY-MM-DD

### Added
- New feature description
```

6. **Commit:**
```bash
git add .
git commit -m "Add new feature: brief description"
```

7. **Push and create PR:**
```bash
git push origin feature/my-new-feature
# Create pull request on GitHub
```

### Pull Request Guidelines

**Title Format:**
```
Add new skill: knowledge-graph
Fix hook: auto-tag script error
Update docs: clarify MCP server setup
```

**Description Should Include:**
- What changed
- Why the change was needed
- How to test it
- Any breaking changes
- Related issues

**Example:**
```markdown
## Changes
Added new knowledge-graph skill for visualizing relationships between Brain content.

## Motivation
Users requested ability to see connections between notes, papers, and projects.

## Testing
```bash
claude --plugin-dir .
User: "show knowledge graph for AI-ML-DL"
```

## Breaking Changes
None

## Related Issues
Closes #42
```

### Review Process

1. Automated checks run (if configured)
2. Maintainer reviews code
3. Feedback addressed
4. Approved and merged
5. Version released (if applicable)

## 📚 Resources

- **Claude Code Docs:** https://code.claude.com/docs/en/brain-plugin.md
- **MCP Protocol:** https://modelcontextprotocol.io
- **Brain Repository:** https://github.com/iker592/Brain
- **Issue Tracker:** https://github.com/iker592/Brain/issues

## ❓ Questions?

- Open an issue: https://github.com/iker592/Brain/issues
- Discussion: https://github.com/iker592/Brain/discussions

## 🙏 Thank You!

Your contributions help make the Brain plugin better for everyone. Thank you for taking the time to contribute!

---

**Maintained by:** Iker
**License:** MIT
**Last Updated:** January 10, 2026
