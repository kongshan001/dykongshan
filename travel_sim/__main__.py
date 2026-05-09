"""Travel SIM/WiFi Comparison — CLI entry point."""

from .report import generate_report


def demo():
    print(generate_report())


if __name__ == "__main__":
    demo()
