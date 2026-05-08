"""JSON file storage for expense records."""

import json
from pathlib import Path
from .models import TripBudget, Expense, ExpenseCategory

_STORAGE = Path("/tmp/travel_expense_data.json")


def save(trip: TripBudget, path: Path | None = None) -> None:
    """Save trip data to JSON."""
    p = path or _STORAGE
    data = {
        "trip_name": trip.trip_name,
        "base_currency": trip.base_currency,
        "total_budget": trip.total_budget,
        "start_date": trip.start_date,
        "end_date": trip.end_date,
        "expenses": [
            {
                "id": e.id, "amount": e.amount, "currency": e.currency,
                "category": e.category.value, "note": e.note, "date": e.date,
                "converted_amount": e.converted_amount,
            }
            for e in trip.expenses
        ]
    }
    p.write_text(json.dumps(data, ensure_ascii=False, indent=2))


def load(path: Path | None = None) -> TripBudget | None:
    """Load trip data from JSON."""
    p = path or _STORAGE
    if not p.exists():
        return None
    data = json.loads(p.read_text())
    trip = TripBudget(
        trip_name=data["trip_name"],
        base_currency=data["base_currency"],
        total_budget=data["total_budget"],
        start_date=data.get("start_date", ""),
        end_date=data.get("end_date", ""),
    )
    for e in data.get("expenses", []):
        cat_str = e["category"]
        cat = next((c for c in ExpenseCategory if c.value == cat_str), ExpenseCategory.OTHER)
        trip.expenses.append(Expense(
            id=e["id"], amount=e["amount"], currency=e["currency"],
            category=cat, note=e["note"], date=e["date"],
            converted_amount=e["converted_amount"],
        ))
    return trip
