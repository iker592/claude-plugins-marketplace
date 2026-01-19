#!/usr/bin/env python3
"""MCP Server for Python project scaffolding and management"""
import json

class PyProjectTools:
    def scaffold_project(self, name: str, template: str = "fastapi") -> dict:
        return {"tool": "scaffold_project", "name": name, "template": template}

    def add_dependency(self, package: str, dev: bool = False) -> dict:
        return {"tool": "add_dependency", "package": package, "dev": dev}

def main():
    print(json.dumps({
        "server": "py-project-tools",
        "version": "1.0.0",
        "tools": [
            {"name": "scaffold_project", "description": "Create new Python project"},
            {"name": "add_dependency", "description": "Add uv dependency"}
        ]
    }))

if __name__ == "__main__":
    main()
