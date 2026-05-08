"""Report generation for travel expenses."""

from .models import TripBudget, ExpenseCategory
from .stats import by_category, by_date, ascii_bar_chart, budget_bar


def generate_report(trip: TripBudget) -> str:
    lines = []
    lines.append("=" * 55)
    lines.append("       💰 旅行花费记录")
    lines.append("=" * 55)
    lines.append(f"旅行: {trip.trip_name} | 基准币种: {trip.base_currency}")
    lines.append("")

    # Budget overview
    if trip.total_budget > 0:
        lines.append(f"📊 预算概览:")
        lines.append(f"  总预算: ¥{trip.total_budget:,.0f}")
        lines.append(f"  已花费: ¥{trip.total_spent:,.0f}")
        lines.append(f"  剩余:   ¥{trip.remaining:,.0f}")
        lines.append(budget_bar(trip.total_spent, trip.total_budget))
        lines.append("")

    # Category breakdown
    cat_data = by_category(trip)
    if cat_data:
        lines.append("📂 分类统计:")
        lines.append("-" * 45)
        lines.append(ascii_bar_chart(cat_data))
        lines.append("")

    # Daily breakdown
    date_data = by_date(trip)
    if date_data:
        lines.append("📅 每日花费:")
        lines.append("-" * 45)
        for date in sorted(date_data):
            lines.append(f"  {date}: ¥{date_data[date]:,.0f}")
        avg = sum(date_data.values()) / len(date_data)
        lines.append(f"  {'日均':>12}: ¥{avg:,.0f}")
        lines.append("")

    # Recent expenses
    if trip.expenses:
        lines.append("📝 最近记录:")
        lines.append("-" * 45)
        for e in trip.expenses[-5:]:
            curr = f" ({e.amount:.0f} {e.currency})" if e.currency != trip.base_currency else ""
            lines.append(f"  {e.date} | {e.category.value} | ¥{e.converted_amount:,.0f}{curr} | {e.note}")

    lines.append("")
    lines.append("=" * 55)
    return "\n".join(lines)
