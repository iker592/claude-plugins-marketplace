---
name: habit-tracker
description: Track, analyze, and report on daily habits. Use when user wants to log habits, check habit streaks, analyze patterns, or review habit progress. Trigger keywords "log habit", "track habit", "habit streak", "habit analysis", "habit progress".
allowed-tools: Read, Edit, Write, Grep, Glob
model: sonnet
user-invocable: true
---

# Habit Tracker Skill

Track and analyze daily habits in the Brain knowledge management system.

## Quick Start

This skill helps with:
1. **Logging habits** - Add daily habit entries
2. **Checking streaks** - Calculate consecutive days
3. **Analyzing patterns** - Identify trends and insights
4. **Progress reporting** - Generate habit summaries

## Habit Categories

Based on IKER.md profile, track:

### Health & Fitness
- **Exercise** - Gym sessions, runs, workouts
- **Sleep** - Hours, quality, consistency
- **Nutrition** - Meals, water intake, diet adherence
- **Weight** - Current: 87kg, Target: 80-82kg

### Personal Development
- **Reading** - Books, papers, articles
- **Learning** - Courses, tutorials, practice
- **Meditation** - Minutes, consistency
- **Chinese study** - HSK preparation

### Productivity
- **Deep work** - Focused coding/research hours
- **Side projects** - Startup, personal projects
- **Networking** - Professional connections
- **Writing** - Documentation, articles

## File Structure

### Monthly Logs
Location: `/home/user/Brain/habits-journal/YYYY/month.md`

Example: `habits-journal/2026/january.md`

### Entry Format
```markdown
## Date: January 10, 2026

### Health & Fitness
- Exercise: Gym - Upper body, 60min
- Sleep: 7.5 hours
- Weight: 87kg
- Water: 3L

### Personal Development
- Reading: AI paper - Attention Is All You Need
- Chinese: 30min HSK practice
- Meditation: 15min

### Productivity
- Deep work: 4 hours on Brain marketplace
- Project: Claude plugin development
- Writing: Documentation updates
```

## Core Operations

### 1. Log New Habit
- Read current month file
- Determine today's date
- Check if entry exists
- Add or update habit entry
- Save file

### 2. Calculate Streak
- Read recent habit logs
- Count consecutive days
- Report streak length
- Show last logged date

### 3. Analyze Patterns
- Collect habit data from period
- Calculate statistics
- Identify trends
- Generate insights

### 4. Progress Report
- Read all relevant logs
- Calculate completion rates
- Compare to goals from IKER.md
- Generate summary

## Integration with Brain

- Cross-reference IKER.md for goals
- Link to Plans/ for daily plans
- Connect to Projects/ for work tracking
- Update profile on milestones

## Usage Examples

```
User: "Log exercise - gym 45min"
→ Updates today's entry in habits-journal/2026/january.md

User: "How's my reading streak?"
→ Analyzes recent entries
→ Output: "12-day reading streak! Keep it up!"

User: "Give me my January habit summary"
→ Analyzes all January entries
→ Output: Exercise: 22/31 days (71%)
```
