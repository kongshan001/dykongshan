"""Travel Transit Card Guide — CLI entry point."""

from .database import DATABASE
from .report import generate_report


def demo():
    for card in DATABASE:
        print(generate_report(card))
        print()


if __name__ == "__main__":
    demo()
