"""Report generation for travel planner."""

from .models import TripPlan


def generate_report(plan: TripPlan) -> str:
    """Generate formatted schedule report."""
    lines = []
    lines.append("=" * 50)
    lines.append("       🗺️  旅行行程规划")
    lines.append("=" * 50)
    lines.append(f"目的地: {plan.city} | 天数: {plan.days}天")
    if plan.preferences:
        pref_str = ", ".join(f"{k}×{v:.1f}" for k, v in plan.preferences.items())
        lines.append(f"偏好: {pref_str}")
    lines.append("")

    total_spots = 0
    total_hours = 0.0
    for day in plan.schedule:
        lines.append(f"📅 第 {day.day} 天 ({day.total_hours:.1f}小时)")
        lines.append("-" * 35)
        for i, spot in enumerate(day.spots, 1):
            lines.append(f"  {i}. {spot.name} [{spot.category}] ⭐{spot.rating} ({spot.duration_hours}h)")
            total_spots += 1
        total_hours += day.total_hours
        lines.append("")

    lines.append("=" * 50)
    lines.append(f"  📊 共 {total_spots} 个景点, {total_hours:.1f} 小时")
    lines.append("=" * 50)
    return "\n".join(lines)
