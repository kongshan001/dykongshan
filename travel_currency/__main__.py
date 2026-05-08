"""Travel Currency — CLI entry point."""

from .report import generate_report
from .chart import generate_trend_chart


def demo():
    print(generate_report())
    print()
    print(generate_trend_chart("CNY", "JPY"))
    print()
    print(generate_trend_chart("CNY", "THB"))


if __name__ == "__main__":
    demo()
