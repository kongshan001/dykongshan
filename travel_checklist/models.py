"""Data models for travel checklist."""

from dataclasses import dataclass, field
from enum import Enum


class TripType(str, Enum):
    BUSINESS = "商务"
    LEISURE = "休闲"
    OUTDOOR = "户外"
    ISLAND = "海岛"


class Season(str, Enum):
    SPRING = "春季"
    SUMMER = "夏季"
    AUTUMN = "秋季"
    WINTER = "冬季"


class Category(str, Enum):
    DOCUMENTS = "📄 证件"
    CLOTHING = "👕 衣物"
    ELECTRONICS = "📱 电子产品"
    TOILETRIES = "🧴 洗漱用品"
    MEDICINE = "💊 药品"
    OTHER = "📦 其他"


@dataclass
class ChecklistItem:
    name: str
    category: Category
    essential: bool = True
    note: str = ""


@dataclass
class TripChecklist:
    city: str
    month: int
    trip_type: TripType
    items: list[ChecklistItem] = field(default_factory=list)

    @property
    def season(self) -> Season:
        if self.month in (3, 4, 5):
            return Season.SPRING
        elif self.month in (6, 7, 8):
            return Season.SUMMER
        elif self.month in (9, 10, 11):
            return Season.AUTUMN
        else:
            return Season.WINTER
