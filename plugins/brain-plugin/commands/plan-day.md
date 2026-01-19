---
description: Create or review daily plan with goals and tasks
---

# Plan Day Command

Create structured daily plans and track daily goals in the Brain system.

## Usage

```
/brain:plan-day
/brain:plan-day today
/brain:plan-day tomorrow
/brain:plan-day 2026-01-15
```

## Instructions

When the user runs this command:

1. **Determine target date**
   - No argument or "today": Today's date
   - "tomorrow": Tomorrow's date
   - Date string: Parse specified date

2. **Check for existing plan**
   - Location: `/home/user/Brain/Plans/daily/YYYY-MM-DD.md`
   - If exists: Display and offer to update
   - If not: Create new plan

3. **Create interactive planning session**
   - Ask: "What's your main goal for [date]?"
   - Ask: "What projects are you working on?"
   - Ask: "How many deep work hours can you commit?"
   - Ask: "Any specific habits to focus on?"

4. **Generate structured plan**
   ```markdown
   # Daily Plan - Day, Month DD, YYYY

   ## Morning Intentions
   - Main goal for the day
   - Key focus areas
   - Energy level: [1-10]

   ## Schedule

   ### Morning (6am - 12pm)
   - [ ] Morning routine (exercise, meditation)
   - [ ] Deep work block 1

   ### Afternoon (12pm - 6pm)
   - [ ] Deep work block 2
   - [ ] Meetings/calls

   ### Evening (6pm - 10pm)
   - [ ] Learning time
   - [ ] Evening routine

   ## Priority Tasks (Top 3)
   1. Most important task
   2. Second priority
   3. Third priority

   ## Deep Work Blocks
   - Block 1: 9am-11am - [Project/Task]
   - Block 2: 2pm-4pm - [Project/Task]

   ## Habits to Complete
   - [ ] Exercise (30+ min)
   - [ ] Reading (30+ min)
   - [ ] Meditation (15+ min)
   - [ ] Chinese study (30+ min)

   ## Project Progress
   - **Current Project:** [Project name]
   - **Today's Goal:** [Specific milestone]

   ## Evening Review
   *To be filled at end of day*

   ### Completed
   - [What got done]

   ### Learned
   - [Key insights]

   ### Tomorrow
   - [Carry-over tasks]
   ```

5. **Personalize based on context**
   - Reference IKER.md for goals (weight: 87kg → 80-82kg, etc.)
   - Check recent habits-journal entries
   - Consider day of week (weekday vs weekend)
   - Include active projects

6. **Save and confirm**
   - Save to Plans/daily/YYYY-MM-DD.md
   - Create directory if needed
   - Confirm plan created
   - Suggest evening review time

## Smart Features

### Context-Aware Suggestions

**From IKER.md:**
- Current weight goal tracking
- Professional development priorities
- Side project commitments

**From habits-journal:**
- Current habit streaks
- Missed habits to catch up
- Recent patterns

**Day of Week:**
- Monday: Weekly planning, fresh start
- Wednesday: Mid-week check-in
- Friday: Week wrap-up
- Weekend: Learning, side projects

### Time Blocking
- Deep work: Morning blocks (9-11am) when fresh
- Meetings: Afternoon batching
- Learning: Early evening
- Habits: Morning and evening routines

## Examples

```
/brain:plan-day
→ Creates plan for today with interactive questions

/brain:plan-day tomorrow
→ Plans tomorrow with suggestions based on today's progress

/brain:plan-day 2026-01-15
→ Creates plan for specific date
```

## Integration

Uses multiple components:
- **content-organizer** skill - File creation and structure
- **habit-tracker** skill - Habit integration
- **knowledge-search** skill - Find related goals and projects
- References IKER.md for personalization
- Updates Plans/ directory

The command streamlines daily planning with intelligent defaults and personalization.
