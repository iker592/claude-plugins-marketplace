---
description: Summarize an AI/ML paper and add it to Brain
---

# AI Summary Command

Fetch, summarize, and organize AI/ML research papers in the Brain knowledge base.

## Usage

```
/brain:ai-summary <paper-url>
/brain:ai-summary https://arxiv.org/abs/1706.03762
/brain:ai-summary https://arxiv.org/abs/2103.14030
```

## Instructions

When the user runs this command:

1. Extract paper URL from `$ARGUMENTS`
2. Invoke the **ai-research** skill
3. Fetch and summarize the paper:
   - Title, authors, year
   - Abstract and TL;DR
   - Key contributions
   - Methodology and results
4. Save to AI-ML-DL/Papers/
5. Update relevant indexes
6. Return summary to user

## Supported Sources

- arXiv papers (arxiv.org)
- Direct PDF links
- Research paper URLs
- DOI links

## Examples

```
/brain:ai-summary https://arxiv.org/abs/1706.03762
→ Summarizes "Attention Is All You Need"
→ Saves to AI-ML-DL/Papers/attention-is-all-you-need.md
→ Returns formatted summary

/brain:ai-summary https://arxiv.org/abs/2010.11929
→ Summarizes "An Image is Worth 16x16 Words" (Vision Transformer)
→ Saves to AI-ML-DL/Papers/vision-transformer.md
```

## Features

- Automatic categorization by topic
- Smart tagging (NLP, CV, RL, etc.)
- Cross-references to related papers
- Integration with reading list
- Updates learning progress

The command streamlines research paper management and knowledge accumulation.
