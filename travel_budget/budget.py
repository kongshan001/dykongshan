"""Budget calculation core."""

from .models import Destination, ExpenseCategory, TripBudget
from .currency import convert


def calc_destination_total(dest: Destination, target_currency: str = "CNY") -> dict:
    """Calculate total for one destination."""
    by_category: dict[str, float] = {}
    total = 0.0
    for exp in dest.expenses:
        converted = convert(exp.amount, exp.currency, target_currency)
        cat = exp.category.value
        by_category[cat] = by_category.get(cat, 0.0) + converted
        total += converted
    return {"destination": dest.name, "days": dest.days, "by_category": by_category, "total": total}


def calc_trip(budget: TripBudget) -> list[dict]:
    """Calculate totals for entire trip."""
    return [calc_destination_total(d, budget.base_currency) for d in budget.destinations]
