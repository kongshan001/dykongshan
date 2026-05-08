"""Data models for travel timezone."""

from dataclasses import dataclass
from enum import Enum


class Direction(str, Enum):
    EAST = "向东 ✈️→"
    WEST = "向西 ←✈️"
    SAME = "无时差"


@dataclass
class CityTime:
    city: str
    timezone: str  # IANA timezone name
    utc_offset_hours: float
    current_time: str  # HH:MM
    current_date: str  # YYYY-MM-DD


@dataclass
class JetLagAdvice:
    direction: Direction
    hours_diff: float
    tips: list[str]


@dataclass
class ContactWindow:
    from_city: str
    to_city: str
    good_hours: list[str]  # "09:00-21:00" type ranges in local time
