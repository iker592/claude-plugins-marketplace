---
description: Search Brain knowledge base for notes, papers, and content
---

# Search Command

Search the entire Brain repository for specific content, files, or topics.

## Usage

```
/brain:search <query>
/brain:search transformer architecture
/brain:search "habit streak"
```

## Instructions

When the user runs this command:

1. Parse the search query from `$ARGUMENTS`
2. Invoke the **knowledge-search** skill
3. Return results with file paths and line numbers
4. Suggest related content if available

## Examples

```
/brain:search quantum computing
→ Searches for quantum computing across all Brain directories

/brain:search exercise habit
→ Searches habits-journal for exercise entries

/brain:search startup pitch
→ Searches Projects/Startup/ for pitch-related content
```

Provide clear, actionable results with file:line references for easy navigation.
