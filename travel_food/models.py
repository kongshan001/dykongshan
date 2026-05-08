"""Data models for travel food."""

from dataclasses import dataclass, field
from enum import Enum


class MealTime(str, Enum):
    BREAKFAST = "🌅 早餐"
    LUNCH = "☀️ 午餐"
    DINNER = "🌙 晚餐"
    SNACK = "🍵 小吃/甜点"


class TasteTag(str, Enum):
    SPICY = "辣"
    MILD = "清淡"
    SWEET = "甜"
    SEAFOOD = "海鲜"
    VEGETARIAN = "素食"
    MEAT = "肉食"
    SOUP = "汤类"


class PriceLevel(str, Enum):
    BUDGET = "💰 平价"
    MID = "💰💰 中等"
    HIGH = "💰💰💰 高档"


@dataclass
class FoodItem:
    name: str
    city: str
    meal_time: MealTime
    price_level: PriceLevel
    price_cny: float
    rating: float  # 1-5
    taste_tags: list[TasteTag]
    description: str
    must_try: bool = False


@dataclass
class FoodRecommendation:
    city: str
    preferences: list[TasteTag]
    max_price_level: PriceLevel
    items: list[FoodItem] = field(default_factory=list)
