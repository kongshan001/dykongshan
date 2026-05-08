"""Travel Planner — CLI entry point."""

from .models import TripPlan
from .spots import get_spots
from .schedule import generate_schedule
from .report import generate_report


def demo():
    """Run demo with Tokyo 3-day trip."""
    city = "东京"
    days = 3
    prefs = {"文化": 1.5, "美食": 1.3, "自然": 1.0, "购物": 0.8}

    spots = get_spots(city)
    if not spots:
        print(f"No spots found for {city}")
        return

    schedule = generate_schedule(spots, days, hours_per_day=7.0, preferences=prefs)
    plan = TripPlan(city=city, days=days, preferences=prefs, schedule=schedule)
    print(generate_report(plan))


if __name__ == "__main__":
    demo()
