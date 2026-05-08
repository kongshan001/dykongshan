"""Travel Safety — CLI entry point."""

from .models import SafetyReport
from .database import get_safety_data, available_cities
from .report import generate_report


def demo():
    for city in ["东京", "巴黎", "曼谷"]:
        data = get_safety_data(city)
        if not data:
            continue
        report = SafetyReport(
            city=city,
            country=data["country"],
            ratings=data["ratings"],
            emergencies=data["emergencies"],
            risks=data["risks"],
        )
        print(generate_report(report))
        print()


if __name__ == "__main__":
    demo()
