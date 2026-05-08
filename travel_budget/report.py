"""Report generation."""

from .budget import calc_trip
from .models import TripBudget


def generate_report(budget: TripBudget) -> str:
    """Generate a formatted budget report."""
    results = calc_trip(budget)
    lines = []
    lines.append("=" * 50)
    lines.append("       ✈️  旅行预算报告")
    lines.append("=" * 50)
    lines.append(f"目标币种: {budget.base_currency}")
    lines.append("")

    grand_total = 0.0
    for r in results:
        lines.append(f"📍 {r['destination']} ({r['days']}天)")
        lines.append("-" * 30)
        for cat, amount in r["by_category"].items():
            lines.append(f"  {cat}: ¥{amount:,.0f}")
        lines.append(f"  {'小计':>4}: ¥{r['total']:,.0f}")
        lines.append("")
        grand_total += r["total"]

    lines.append("=" * 50)
    lines.append(f"  💰 总预算: ¥{grand_total:,.0f} {budget.base_currency}")
    lines.append("=" * 50)
    return "\n".join(lines)


def generate_json(budget: TripBudget) -> str:
    """Generate JSON report."""
    import json
    results = calc_trip(budget)
    grand_total = sum(r["total"] for r in results)
    return json.dumps({"destinations": results, "grand_total": grand_total, "currency": budget.base_currency}, ensure_ascii=False, indent=2)
