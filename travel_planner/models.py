"""Data models for travel planner."""

from dataclasses import dataclass, field


@dataclass
class Spot:
    name: str
    category: str  # 文化/自然/美食/购物
    duration_hours: float
    rating: float  # 1-5
    lat: float
    lng: float


@dataclass
class DayPlan:
    day: int
    spots: list[Spot] = field(default_factory=list)
    total_hours: float = 0.0


@dataclass
class TripPlan:
    city: str
    days: int
    preferences: dict[str, float] = field(default_factory=dict)  # category -> weight
    schedule: list[DayPlan] = field(default_factory=list)
