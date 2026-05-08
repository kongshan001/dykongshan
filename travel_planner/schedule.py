"""Schedule generator."""

from .models import DayPlan, Spot
from .optimizer import select_spots


def generate_schedule(spots: list[Spot], days: int, hours_per_day: float = 8.0, preferences: dict[str, float] | None = None) -> list[DayPlan]:
    """Generate multi-day schedule from spots."""
    prefs = preferences or {}
    selected = select_spots(spots, days * hours_per_day, prefs)

    schedule = []
    remaining = list(selected)
    for d in range(1, days + 1):
        day_plan = DayPlan(day=d)
        while remaining:
            s = remaining[0]
            if day_plan.total_hours + s.duration_hours <= hours_per_day:
                day_plan.spots.append(remaining.pop(0))
                day_plan.total_hours += s.duration_hours
            else:
                break
        schedule.append(day_plan)
    return schedule
