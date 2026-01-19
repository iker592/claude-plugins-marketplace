#!/usr/bin/env python3
"""
Brain Habit API - MCP Server for habit tracking
Provides tools for logging, analyzing, and tracking habits
"""

import os
import json
import sys
from pathlib import Path
from datetime import datetime, timedelta

class BrainHabitServer:
    """MCP Server for habit tracking"""

    def __init__(self):
        self.brain_root = Path(os.environ.get('BRAIN_ROOT', '/home/user/Brain'))
        self.habits_dir = Path(os.environ.get('HABITS_DIR', self.brain_root / 'habits-journal'))

    def log_habit(self, category: str, details: str, date: str = None) -> dict:
        """Log a habit entry"""
        # Placeholder implementation
        target_date = datetime.strptime(date, "%Y-%m-%d") if date else datetime.now()
        return {
            "tool": "log_habit",
            "category": category,
            "details": details,
            "date": target_date.strftime("%Y-%m-%d"),
            "status": "logged"
        }

    def get_streak(self, habit_type: str) -> dict:
        """Calculate habit streak"""
        # Placeholder implementation
        return {
            "tool": "get_streak",
            "habit": habit_type,
            "current_streak": 7,
            "best_streak": 12,
            "last_logged": datetime.now().strftime("%Y-%m-%d")
        }

    def analyze_habits(self, period: str = "month") -> dict:
        """Analyze habit patterns"""
        # Placeholder implementation
        return {
            "tool": "analyze_habits",
            "period": period,
            "summary": {
                "exercise": {"completion": "71%", "streak": 7},
                "reading": {"completion": "90%", "streak": 12},
                "meditation": {"completion": "48%", "streak": 2}
            }
        }

    def get_monthly_report(self, year: int, month: int) -> dict:
        """Generate monthly habit report"""
        # Placeholder implementation
        return {
            "tool": "get_monthly_report",
            "year": year,
            "month": month,
            "total_days": 31,
            "habits_logged": 22,
            "completion_rate": "71%"
        }

def main():
    """MCP Server main entry point"""
    server = BrainHabitServer()

    print(json.dumps({
        "server": "brain-habits",
        "version": "1.0.0",
        "tools": [
            {
                "name": "log_habit",
                "description": "Log a habit entry for a specific date",
                "parameters": {
                    "category": "string",
                    "details": "string",
                    "date": "string (optional, format: YYYY-MM-DD)"
                }
            },
            {
                "name": "get_streak",
                "description": "Calculate current and best streak for a habit",
                "parameters": {
                    "habit_type": "string (e.g., 'exercise', 'reading')"
                }
            },
            {
                "name": "analyze_habits",
                "description": "Analyze habit patterns for a time period",
                "parameters": {
                    "period": "string (week, month, year)"
                }
            },
            {
                "name": "get_monthly_report",
                "description": "Generate comprehensive monthly habit report",
                "parameters": {
                    "year": "integer",
                    "month": "integer"
                }
            }
        ]
    }))

if __name__ == "__main__":
    main()
