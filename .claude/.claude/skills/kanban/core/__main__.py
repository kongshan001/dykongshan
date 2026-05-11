"""Allow running kanban as: python -m core <cmd>

Supports two invocation modes:
  1. From framework root:  cd .claude/skills/kanban && python -m core status
  2. From project root:    PYTHONPATH=.claude/skills/kanban python -m core status
"""
import sys
import os

# Add framework root to sys.path so core module can be imported from any cwd
# __file__ = .../core/__main__.py -> parent = .../kanban/ (contains core/)
_framework_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _framework_root not in sys.path:
    sys.path.insert(0, _framework_root)

from core.cli.main import main

main()
