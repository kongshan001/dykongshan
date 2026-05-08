"""Travel Checklist — CLI entry point."""

from .models import TripType
from .rules import generate_checklist
from .report import generate_report


def demo():
    """Demo: generate checklist for Tokyo summer leisure trip."""
    for city, month, ttype in [
        ("东京", 7, TripType.LEISURE),
        ("巴黎", 12, TripType.BUSINESS),
        ("曼谷", 3, TripType.ISLAND),
    ]:
        cl = generate_checklist(city, month, ttype)
        print(generate_report(cl))
        print()


if __name__ == "__main__":
    demo()
