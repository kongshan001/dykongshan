"""Statistics and analysis for travel expenses."""

from .models import TripBudget, ExpenseCategory


def by_category(trip: TripBudget) -> dict[str, float]:
    """Sum expenses by category."""
    result: dict[str, float] = {}
    for e in trip.expenses:
        cat = e.category.value
        result[cat] = result.get(cat, 0.0) + e.converted_amount
    return result


def by_date(trip: TripBudget) -> dict[str, float]:
    """Sum expenses by date."""
    result: dict[str, float] = {}
    for e in trip.expenses:
        result[e.date] = result.get(e.date, 0.0) + e.converted_amount
    return result


def ascii_bar_chart(data: dict[str, float], max_width: int = 30) -> str:
    """Generate horizontal ASCII bar chart."""
    if not data:
        return "  (无数据)"
    max_val = max(data.values())
    lines = []
    for label, value in sorted(data.items(), key=lambda x: -x[1]):
        bar_len = int(value / max_val * max_width) if max_val > 0 else 0
        bar = "█" * bar_len
        lines.append(f"  {label:<12} {bar} ¥{value:,.0f}")
    return "\n".join(lines)


def budget_bar(used: float, total: float, width: int = 30) -> str:
    """Generate budget usage bar."""
    if total <= 0:
        return ""
    pct = min(used / total, 1.0)
    filled = int(pct * width)
    empty = width - filled
    return f"  [{'█' * filled}{'░' * empty}] {pct*100:.1f}%"
