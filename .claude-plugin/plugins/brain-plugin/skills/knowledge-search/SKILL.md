---
name: knowledge-search
description: Search and retrieve information from Brain repository. Use when searching for notes, papers, documentation, or any content. Trigger keywords "find", "search", "where is", "locate".
allowed-tools: Read, Grep, Glob, Bash
model: sonnet
user-invocable: true
---

# Knowledge Search Skill

Search and retrieve information across the entire Brain knowledge management system.

## Quick Start

This skill helps you find:
- **Notes and documentation** across all directories
- **AI/ML papers and resources** in AI-ML-DL/
- **Project information** in Projects/
- **Habit logs** in habits-journal/
- **Plans and goals** in Plans/
- **Links and resources** in Links/

## Search Capabilities

### 1. Content Search
Search file contents using keywords:
- Code snippets
- Concepts and definitions
- Paper titles and authors
- Project notes
- Daily logs

### 2. File Search
Find files by name or pattern:
- Specific filenames
- File types (.md, .py, .ts)
- Directories
- Recent modifications

### 3. Structured Search
Search by Brain structure:
- By project (AI-ML-DL, Startup, etc.)
- By category (Papers, Frameworks, Tools)
- By date (habit journals, plans)
- By topic (NLP, Computer-Vision, etc.)

## Usage Examples

**Find AI concepts:**
```
User: "Where are my notes on transformers?"
→ Search AI-ML-DL/ for transformer-related content
→ Return: AI-ML-DL/Architectures/transformers.md:15
```

**Find habits:**
```
User: "What did I log for exercise last week?"
→ Search habits-journal/2026/january.md
→ Extract exercise entries from past 7 days
```

**Find projects:**
```
User: "Find my startup pitch deck notes"
→ Search Projects/Startup/ for pitch-related files
→ Return relevant notes with line numbers
```

## Search Strategy

1. **Understand query** - Parse user's search intent
2. **Identify scope** - Determine relevant directories
3. **Execute search** - Use Grep for content, Glob for files
4. **Rank results** - Most relevant first
5. **Format output** - Include file paths with line numbers

## Integration

- References IKER.md for context about user interests
- Understands Brain directory structure
- Provides file:line references for easy navigation
- Can invoke other skills for follow-up actions

## See Also

- [Reference Documentation](./reference.md) - Detailed search algorithms
