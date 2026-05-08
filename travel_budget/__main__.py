"""Travel Budget Calculator — CLI entry point."""

from .models import TripBudget, BudgetLevel
from .templates import apply_template
from .report import generate_report, generate_json


def demo():
    """Run a demo with predefined destinations."""
    budget = TripBudget(base_currency="CNY")
    budget.destinations = [
        apply_template("东京", 5, BudgetLevel.STANDARD),
        apply_template("曼谷", 3, BudgetLevel.ECONOMY),
    ]
    print(generate_report(budget))
    print("\n--- JSON Output ---")
    print(generate_json(budget))


if __name__ == "__main__":
    demo()
