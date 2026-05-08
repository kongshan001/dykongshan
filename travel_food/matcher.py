"""Food preference matching engine."""

from .models import FoodItem, TasteTag, PriceLevel

_PRICE_ORDER = {PriceLevel.BUDGET: 0, PriceLevel.MID: 1, PriceLevel.HIGH: 2}


def match_foods(
    city: str,
    preferences: list[TasteTag],
    max_price: PriceLevel = PriceLevel.HIGH,
    limit: int = 20,
) -> list[FoodItem]:
    """Match foods by city, taste preferences, and budget."""
    from .database import get_by_city
    foods = get_by_city(city)
    max_idx = _PRICE_ORDER[max_price]

    # Filter by price
    foods = [f for f in foods if _PRICE_ORDER[f.price_level] <= max_idx]

    # Score by preference match
    if preferences:
        pref_set = set(preferences)
        def score(f: FoodItem) -> float:
            overlap = len(set(f.taste_tags) & pref_set)
            return overlap * 2 + f.rating + (1.0 if f.must_try else 0)
        foods.sort(key=score, reverse=True)
    else:
        foods.sort(key=lambda f: f.rating + (1.0 if f.must_try else 0), reverse=True)

    return foods[:limit]
