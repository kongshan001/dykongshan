"""Budget templates for different travel levels."""

from .models import BudgetLevel, Destination, ExpenseItem, ExpenseCategory

# Daily rates per destination (CNY)
_TEMPLATES: dict[str, dict[BudgetLevel, dict[ExpenseCategory, float]]] = {
    "东京": {
        BudgetLevel.ECONOMY: {ExpenseCategory.ACCOMMODATION: 200, ExpenseCategory.FOOD: 150, ExpenseCategory.TRANSPORT: 80, ExpenseCategory.TICKET: 50},
        BudgetLevel.STANDARD: {ExpenseCategory.ACCOMMODATION: 500, ExpenseCategory.FOOD: 300, ExpenseCategory.TRANSPORT: 150, ExpenseCategory.TICKET: 100},
        BudgetLevel.LUXURY: {ExpenseCategory.ACCOMMODATION: 1500, ExpenseCategory.FOOD: 800, ExpenseCategory.TRANSPORT: 300, ExpenseCategory.TICKET: 200},
    },
    "巴黎": {
        BudgetLevel.ECONOMY: {ExpenseCategory.ACCOMMODATION: 300, ExpenseCategory.FOOD: 200, ExpenseCategory.TRANSPORT: 100, ExpenseCategory.TICKET: 80},
        BudgetLevel.STANDARD: {ExpenseCategory.ACCOMMODATION: 800, ExpenseCategory.FOOD: 500, ExpenseCategory.TRANSPORT: 200, ExpenseCategory.TICKET: 150},
        BudgetLevel.LUXURY: {ExpenseCategory.ACCOMMODATION: 2000, ExpenseCategory.FOOD: 1200, ExpenseCategory.TRANSPORT: 500, ExpenseCategory.TICKET: 300},
    },
    "曼谷": {
        BudgetLevel.ECONOMY: {ExpenseCategory.ACCOMMODATION: 80, ExpenseCategory.FOOD: 60, ExpenseCategory.TRANSPORT: 30, ExpenseCategory.TICKET: 20},
        BudgetLevel.STANDARD: {ExpenseCategory.ACCOMMODATION: 250, ExpenseCategory.FOOD: 150, ExpenseCategory.TRANSPORT: 80, ExpenseCategory.TICKET: 60},
        BudgetLevel.LUXURY: {ExpenseCategory.ACCOMMODATION: 800, ExpenseCategory.FOOD: 400, ExpenseCategory.TRANSPORT: 200, ExpenseCategory.TICKET: 150},
    },
}

# Default template for unknown destinations
_DEFAULT: dict[BudgetLevel, dict[ExpenseCategory, float]] = {
    BudgetLevel.ECONOMY: {ExpenseCategory.ACCOMMODATION: 150, ExpenseCategory.FOOD: 100, ExpenseCategory.TRANSPORT: 60, ExpenseCategory.TICKET: 40},
    BudgetLevel.STANDARD: {ExpenseCategory.ACCOMMODATION: 400, ExpenseCategory.FOOD: 250, ExpenseCategory.TRANSPORT: 120, ExpenseCategory.TICKET: 80},
    BudgetLevel.LUXURY: {ExpenseCategory.ACCOMMODATION: 1200, ExpenseCategory.FOOD: 600, ExpenseCategory.TRANSPORT: 300, ExpenseCategory.TICKET: 200},
}


def apply_template(dest_name: str, days: int, level: BudgetLevel) -> Destination:
    """Generate a destination with template expenses."""
    rates = _TEMPLATES.get(dest_name, _DEFAULT)[level]
    expenses = [
        ExpenseItem(cat, rate * days, "CNY", f"{days}天{level.value}{cat.value}")
        for cat, rate in rates.items()
    ]
    return Destination(name=dest_name, days=days, expenses=expenses)
