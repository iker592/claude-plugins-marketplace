---
name: ai-research
description: AI/ML research assistant for summarizing papers, explaining concepts, and organizing research. Use when user asks about AI/ML papers, concepts, architectures, or wants to add research to Brain. Trigger keywords "summarize paper", "explain", "AI concept", "ML architecture", "add research".
allowed-tools: Read, Write, Edit, Grep, Glob, WebFetch, Bash
model: sonnet
user-invocable: true
---

# AI Research Assistant Skill

Comprehensive AI/ML research assistant for the Brain knowledge management system.

## Quick Start

This skill helps with:
1. **Paper Summarization** - Fetch and summarize AI/ML papers
2. **Concept Explanation** - Explain AI/ML concepts clearly
3. **Architecture Comparison** - Compare different approaches
4. **Content Organization** - Add research to appropriate Brain directories

## Capabilities

### 1. Paper Summarization
**Input:** Paper URL (arXiv, PDF, etc.)
**Process:**
- Fetch paper content
- Extract key information:
  - Title, authors, year
  - Abstract
  - Key contributions
  - Methodology
  - Results
  - Limitations
- Create structured summary
- Save to AI-ML-DL/Papers/

**Output Format:**
```markdown
# [Paper Title]

**Authors:** First Author, Second Author
**Year:** 2024
**Source:** arXiv:2401.xxxxx

## TL;DR
[One-paragraph summary]

## Key Contributions
1. [Contribution 1]
2. [Contribution 2]

## Methodology
[Approach overview]

## Results
[Key findings]

## Relevance to Brain
[Why this matters for Iker's learning]

## Related Papers
- [Related work 1]
- [Related work 2]

---
**Added:** YYYY-MM-DD
**Tags:** #deep-learning #transformers #nlp
```

### 2. Concept Explanation
**Input:** AI/ML concept or term
**Process:**
- Search existing Brain notes
- If not found, create explanation
- Include:
  - Simple definition
  - Technical details
  - Use cases
  - Code examples (if applicable)
  - Related concepts
- Save to appropriate AI-ML-DL/ subdirectory

**Example:**
```
User: "Explain attention mechanism"
→ Check AI-ML-DL/Architectures/ for existing notes
→ If not found, create comprehensive explanation
→ Save to AI-ML-DL/Architectures/attention-mechanism.md
```

### 3. Architecture Comparison
**Input:** Multiple architectures/approaches
**Process:**
- Gather information on each
- Create comparison table
- Highlight pros/cons
- Suggest use cases
- Save to AI-ML-DL/Architectures/

**Example:**
```markdown
# LSTM vs GRU vs Transformer

## Comparison Table
| Feature | LSTM | GRU | Transformer |
|---------|------|-----|-------------|
| Parameters | High | Medium | Very High |
| Speed | Slow | Medium | Fast (parallel) |
| Long-term memory | Good | Good | Excellent |
```

### 4. Research Organization
**Categorize and organize research by:**
- **Topic:** NLP, Computer-Vision, Reinforcement-Learning, etc.
- **Type:** Papers, Frameworks, Tools, Projects
- **Status:** To-read, Reading, Completed
- **Priority:** High, Medium, Low

## Directory Structure Integration

### AI-ML-DL Structure:
```
AI-ML-DL/
├── Architectures/     → Architecture explanations
├── Papers/            → Paper summaries
├── Frameworks/        → Framework guides (PyTorch, TensorFlow)
├── NLP/              → NLP-specific content
├── Computer-Vision/   → CV-specific content
├── Reinforcement-Learning/ → RL content
├── MLOps/            → Deployment, monitoring
├── Math/             → Mathematical foundations
└── Projects/         → Implementation projects
```

## Workflow Examples

**Example 1: Summarize New Paper**
```
User: "Summarize this paper: arxiv.org/abs/1706.03762"
Skill:
1. Fetch paper (Attention Is All You Need)
2. Extract key information
3. Create summary
4. Save to AI-ML-DL/Papers/attention-is-all-you-need.md
5. Update AI-ML-DL/Papers/README.md with entry
6. Return summary to user
```

**Example 2: Explain Concept**
```
User: "What is batch normalization?"
Skill:
1. Search AI-ML-DL/ for existing explanation
2. If not found, create explanation:
   - Definition
   - Why it's used
   - How it works
   - Code example
   - When to use vs alternatives
3. Save to AI-ML-DL/Training/batch-normalization.md
4. Return explanation
```

**Example 3: Compare Architectures**
```
User: "Compare CNN vs Vision Transformer for image classification"
Skill:
1. Gather info on both architectures
2. Create comparison document
3. Include:
   - Architecture overview
   - Performance comparison
   - Use cases
   - Trade-offs
4. Save to AI-ML-DL/Computer-Vision/cnn-vs-vit.md
5. Return comparison
```

## Advanced Features

### Smart Tagging
Automatically tag papers/concepts with:
- Primary topic (NLP, CV, RL, etc.)
- Techniques used
- Related papers
- Difficulty level
- Implementation status

### Learning Path Generation
Based on IKER.md goals and current knowledge:
- Suggest next papers to read
- Identify knowledge gaps
- Create structured learning path
- Track progress

### Citation Management
- Track paper citations
- Build citation graph
- Identify seminal papers
- Suggest related reading

## Integration with Brain

### With IKER.md
- Align with 2026 learning goals
- Track papers read
- Monitor AI/ML skill development

### With Plans/
- Include research in daily/weekly plans
- Track time spent on papers
- Set reading goals

### With Projects/
- Link papers to active projects
- Reference implementations
- Track applied learnings

## Error Handling

### Paper Not Accessible
- Try alternative sources
- Search for author's page
- Check open access versions
- Provide manual summary option

### Concept Not Found
- Search broader terms
- Check related concepts
- Create from scratch if needed
- Ask user for clarification

## Usage Tips

### Best Practices
1. **Be specific** - Provide URLs or exact paper titles
2. **Add context** - Mention why you're researching this
3. **Link to projects** - Connect research to applications
4. **Review regularly** - Revisit notes and summaries

### Quick Commands
```
"Summarize [paper-url]"
"Explain [concept]"
"Compare [approach1] vs [approach2]"
"Add [paper] to reading list"
"What papers should I read next?"
```

---

**Version:** 1.0.0
**Last Updated:** January 10, 2026
