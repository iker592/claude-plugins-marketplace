#!/usr/bin/env python3
"""MCP Server for pytest execution and management"""
import json

class PyTestTools:
    def run_tests(self, path: str = "", coverage: bool = True) -> dict:
        return {"tool": "run_tests", "path": path, "coverage": coverage}

def main():
    print(json.dumps({
        "server": "py-test-runner",
        "version": "1.0.0",
        "tools": [
            {"name": "run_tests", "description": "Execute pytest tests"},
            {"name": "get_coverage", "description": "Generate coverage report"}
        ]
    }))

if __name__ == "__main__":
    main()
