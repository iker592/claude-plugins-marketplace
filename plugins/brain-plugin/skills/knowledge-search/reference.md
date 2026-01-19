# Knowledge Search - Reference Documentation

## Advanced Search Algorithms

### Semantic Search Priority
1. Exact matches in titles/headings
2. Exact matches in content
3. Partial matches with context
4. Related terms and synonyms

### Directory Priority
Based on query type, search order:
- AI/ML queries: AI-ML-DL/ → Projects/ → Notes/
- Habit queries: habits-journal/ → IKER.md
- Project queries: Projects/ → Plans/ → Actions/
- General: All directories with equal weight

## File Path References

Always return results as: `file_path:line_number`

Example: `/home/user/Brain/AI-ML-DL/Papers/attention-is-all-you-need.md:42`

## Performance Optimization

- Use Glob for filename search (faster)
- Use Grep for content search with smart patterns
- Limit search scope when possible
- Cache recent searches (future enhancement)
