"""Data models for travel budget calculator."""

from dataclasses import dataclass, field
from enum import Enum


class ExpenseCategory(str, Enum):
    TRANSPORT = "交通"
    ACCOMMODATION = "住宿"
    FOOD = "餐饮"
    TICKET = "门票"
    OTHER = "其他"


class BudgetLevel(str, Enum):
    ECONOMY = "经济"
    STANDARD = "标准"
    LUXURY = "豪华"


@dataclass
class ExpenseItem:
    category: ExpenseCategory
    amount: float
    currency: str = "CNY"
    description: str = ""


@dataclass
class Destination:
    name: str
    days: int
    expenses: list[ExpenseItem] = field(default_factory=list)


@dataclass
class TripBudget:
    destinations: list[Destination] = field(default_factory=list)
    base_currency: str = "CNY"
