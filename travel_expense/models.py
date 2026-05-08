"""Data models for travel expense tracker."""

from dataclasses import dataclass, field
from enum import Enum


class ExpenseCategory(str, Enum):
    FOOD = "🍜 餐饮"
    TRANSPORT = "🚌 交通"
    HOTEL = "🏨 住宿"
    TICKET = "🎫 门票"
    SHOPPING = "🛍️ 购物"
    OTHER = "📦 其他"


@dataclass
class Expense:
    id: int
    amount: float
    currency: str
    category: ExpenseCategory
    note: str
    date: str  # YYYY-MM-DD
    converted_amount: float = 0.0  # in base currency


@dataclass
class TripBudget:
    trip_name: str
    base_currency: str = "CNY"
    total_budget: float = 0.0
    expenses: list[Expense] = field(default_factory=list)
    start_date: str = ""
    end_date: str = ""

    @property
    def total_spent(self) -> float:
        return sum(e.converted_amount for e in self.expenses)

    @property
    def remaining(self) -> float:
        return self.total_budget - self.total_spent

    @property
    def budget_usage_percent(self) -> float:
        return (self.total_spent / self.total_budget * 100) if self.total_budget else 0
