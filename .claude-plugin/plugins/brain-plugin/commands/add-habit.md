---
description: Log a daily habit entry to the habits journal
---

# Add Habit Command

Quickly log a habit entry to today's habits journal.

## Usage

```
/brain:add-habit <habit>:<details>
/brain:add-habit exercise:gym 60min upper body
/brain:add-habit reading:finished AI paper
/brain:add-habit meditation:15min morning session
```

## Instructions

When the user runs this command:

1. Parse habit data from `$ARGUMENTS`
2. Format: `<category>:<details>` or just `<description>`
3. Invoke the **habit-tracker** skill
4. Log the habit to today's entry in habits-journal/
5. Report current streak if applicable

## Arguments

- `$ARGUMENTS` - Habit entry in format `category:details` or free-form text

## Examples

```
/brain:add-habit exercise:gym 60min upper body
→ Logs to today's habits-journal entry under Health & Fitness

/brain:add-habit reading:finished Attention Is All You Need paper
→ Logs reading activity under Personal Development

/brain:add-habit meditation 15min
→ Logs meditation session
```

The command provides quick access to habit logging without needing to manually edit files.
