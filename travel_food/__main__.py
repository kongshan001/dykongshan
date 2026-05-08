"""Travel Food — CLI entry point."""

from .models import TasteTag, PriceLevel
from .matcher import match_foods
from .report import generate_report


def demo():
    for city, prefs, budget in [
        ("东京", [TasteTag.SEAFOOD, TasteTag.MILD], PriceLevel.MID),
        ("曼谷", [TasteTag.SPICY, TasteTag.SWEET], PriceLevel.BUDGET),
        ("上海", [TasteTag.MEAT, TasteTag.SWEET], PriceLevel.HIGH),
    ]:
        foods = match_foods(city, prefs, budget)
        print(generate_report(city, foods))
        print()


if __name__ == "__main__":
    demo()
