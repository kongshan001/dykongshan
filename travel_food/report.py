"""Report generation for travel food."""

from .models import MealTime, FoodItem


def generate_report(city: str, foods: list[FoodItem]) -> str:
    lines = []
    lines.append("=" * 55)
    lines.append("       🍜 旅行美食推荐")
    lines.append("=" * 55)
    lines.append(f"目的地: {city}")
    lines.append("")

    by_meal: dict[MealTime, list[FoodItem]] = {}
    for f in foods:
        by_meal.setdefault(f.meal_time, []).append(f)

    for meal in MealTime:
        items = by_meal.get(meal, [])
        if not items:
            continue
        lines.append(f"{meal.value}")
        lines.append("-" * 40)
        for f in items:
            must = " ⭐必吃" if f.must_try else ""
            tags = " ".join(t.value for t in f.taste_tags)
            lines.append(f"  🍽️ {f.name}{must}")
            lines.append(f"     {f.description}")
            lines.append(f"     {f.price_level.value} ~¥{f.price_cny:.0f} | ⭐{f.rating} | {tags}")
        lines.append("")

    total = sum(f.price_cny for f in foods)
    lines.append("=" * 55)
    lines.append(f"  共 {len(foods)} 道美食 | 人均参考: ¥{total / max(len(foods), 1):.0f}/道")
    lines.append("=" * 55)
    return "\n".join(lines)
