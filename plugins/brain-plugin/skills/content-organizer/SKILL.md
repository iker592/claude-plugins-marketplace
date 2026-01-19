---
name: content-organizer
description: Organize and structure content in Brain repository. Use when user wants to categorize files, create directories, reorganize content, or maintain documentation structure. Trigger keywords "organize", "categorize", "structure", "clean up", "reorganize".
allowed-tools: Read, Write, Edit, Grep, Glob, Bash
model: sonnet
user-invocable: true
---

# Content Organizer Skill

Intelligent content organization and structure maintenance for the Brain repository.

## Quick Start

This skill helps with:
1. **Categorization** - Place content in appropriate directories
2. **Structure Creation** - Create new organized directories
3. **Reorganization** - Improve existing structure
4. **Maintenance** - Keep documentation and indexes updated

## Core Functions

### 1. Content Categorization
**Automatically categorize new content:**

**AI/ML Content → AI-ML-DL/**
- Papers → Papers/
- Concepts → Architectures/ or specific topic/
- Code → Projects/ or Frameworks/
- Tools → Tools/

**Personal Content**
- Habits → habits-journal/
- Plans → Plans/
- Notes → Notes/
- Relationships → Relationships/

**Project Content → Projects/**
- By project name
- With proper subdirectories

### 2. Directory Structure Creation
**When creating new directories:**
1. Use kebab-case naming
2. Create instructions.md explaining purpose
3. Create README.md for navigation
4. Update parent README.md
5. Follow Brain conventions

**Template for new directory:**
```
new-topic/
├── instructions.md    # Purpose and guidelines
├── README.md          # Topic overview
└── [content files]
```

### 3. File Organization Rules

**Naming Conventions:**
- Use kebab-case: `file-name.md`
- Be descriptive: `transformer-architecture.md` not `trans.md`
- Include dates for logs: `2026-01-10.md`
- Version files: `v1-proposal.md`, `v2-proposal.md`

**File Placement:**
- One topic = one directory
- Related files together
- Avoid deeply nested structures (max 3-4 levels)
- Use cross-references for relationships

### 4. Documentation Maintenance

**README files:**
- Update when structure changes
- Include directory listing
- Explain purpose and organization
- Link to related content

**instructions.md files:**
- Explain what goes in directory
- Provide content guidelines
- Show example structures
- Reference Brain conventions

**Index files:**
- Maintain topic indexes
- Update on new content
- Include search keywords
- Cross-reference related topics

## Organization Strategies

### By Topic (AI-ML-DL/)
```
AI-ML-DL/
├── Architectures/
│   ├── transformers/
│   ├── cnns/
│   └── rnns/
├── Papers/
│   └── [paper-summaries].md
└── [other topics]/
```

### By Project (Projects/)
```
Projects/
├── Startup/
│   ├── pitch/
│   ├── product/
│   └── market-research/
└── [other projects]/
```

### By Time (habits-journal/, Plans/)
```
habits-journal/
└── YYYY/
    ├── january.md
    ├── february.md
    └── [months].md
```

## Workflow Examples

**Example 1: Organize New Paper**
```
User: "I just read a paper on GANs, add it to Brain"
Skill:
1. Determine paper belongs in AI-ML-DL/Papers/
2. Check if GANs subdirectory exists
3. Create paper summary file
4. Update AI-ML-DL/Papers/README.md
5. Add tags and cross-references
```

**Example 2: Reorganize Directory**
```
User: "Clean up my startup project directory"
Skill:
1. Read Projects/Startup/
2. Analyze current structure
3. Group related files
4. Create logical subdirectories
5. Move files to appropriate locations
6. Update README.md
7. Preserve git history
```

**Example 3: Create New Category**
```
User: "Create a section for quantum computing research"
Skill:
1. Create AI-ML-DL/Quantum-Computing/
2. Create instructions.md
3. Create README.md with overview
4. Update AI-ML-DL/README.md
5. Add to main Brain README.md
6. Suggest relevant papers to add
```

## Smart Features

### Duplicate Detection
- Identify similar/duplicate content
- Suggest merging or organizing
- Preserve both if intentionally separate

### Broken Link Detection
- Find broken internal links
- Update cross-references
- Suggest correct paths

### Content Suggestions
Based on existing structure:
- Suggest where new content should go
- Identify gaps in organization
- Recommend consolidation opportunities

### Auto-Tagging
Automatically tag content with:
- Primary category
- Related topics
- Creation date
- Last modified date
- Keywords

## Integration with Brain

### Respect Existing Structure
Follow patterns in:
- `.claude/CLAUDE.md` - Project instructions
- `IKER.md` - User profile and goals
- Directory `instructions.md` files
- Existing README.md structures

### Maintain Conventions
- Markdown for all content
- Kebab-case for directories
- Clear, descriptive naming
- Progressive disclosure in docs

### Cross-Reference
Link related content:
- Papers ↔ Projects (implementations)
- Habits ↔ Goals (IKER.md)
- Plans ↔ Projects (execution)
- Notes ↔ Everything (references)

## Maintenance Tasks

### Regular Cleanup
- Review unorganized files
- Update outdated READMEs
- Fix broken links
- Consolidate duplicates
- Archive completed projects

### Structure Review
- Assess directory depth
- Identify overly broad categories
- Split large directories
- Merge sparse directories

### Documentation Updates
- Keep READMEs current
- Update instructions.md files
- Refresh main Brain README
- Update CLAUDE.md if structure changes

## Error Handling

### Ambiguous Placement
- Ask user for clarification
- Suggest multiple options
- Explain reasoning for each

### Conflicts
- Check before moving/deleting
- Preserve user's organization choices
- Warn about potential issues

### Permission Issues
- Respect git-tracked files
- Warn before major reorganizations
- Suggest backup if needed

## Best Practices

### DO:
- ✓ Follow existing patterns
- ✓ Ask before major changes
- ✓ Update all references
- ✓ Preserve git history
- ✓ Document organization decisions

### DON'T:
- ✗ Create overly deep nesting
- ✗ Use unclear abbreviations
- ✗ Break existing links without updating
- ✗ Reorganize without user approval
- ✗ Delete content without checking

## Usage Examples

```
"Organize my new AI paper notes"
"Create a directory for reinforcement learning"
"Clean up my Projects/ directory"
"Where should I put this startup pitch deck?"
"Update all README files"
"Find and fix broken links"
```

---

**Version:** 1.0.0
**Last Updated:** January 10, 2026
