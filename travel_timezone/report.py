"""Report generation for travel timezone."""

from .cities import get_current_time, CITIES
from .calculator import get_jet_lag_advice, find_contact_window


def generate_report() -> str:
    lines = []
    lines.append("=" * 55)
    lines.append("       🕐 旅行时差计算器")
    lines.append("=" * 55)

    # World clock
    lines.append("")
    lines.append("🌍 世界时钟 (当前时间):")
    lines.append("-" * 45)
    lines.append(f"  {'城市':<8} {'时间':>6} {'日期':>12} {'UTC偏移':>8}")
    lines.append("-" * 45)
    for city in ["北京", "东京", "曼谷", "巴黎", "伦敦", "纽约", "洛杉矶", "悉尼"]:
        time_str, date_str, offset = get_current_time(city)
        sign = "+" if offset >= 0 else ""
        lines.append(f"  {city:<8} {time_str:>6} {date_str:>12} {sign}{offset:.1f}h")

    # Jet lag advice: Beijing -> Paris
    lines.append("")
    lines.append("✈️ 时差建议 (北京 → 巴黎):")
    lines.append("-" * 45)
    advice = get_jet_lag_advice("北京", "巴黎")
    lines.append(f"  方向: {advice.direction.value}")
    for tip in advice.tips:
        lines.append(f"  {tip}")

    # Jet lag advice: Beijing -> New York
    lines.append("")
    lines.append("✈️ 时差建议 (北京 → 纽约):")
    lines.append("-" * 45)
    advice2 = get_jet_lag_advice("北京", "纽约")
    lines.append(f"  方向: {advice2.direction.value}")
    for tip in advice2.tips:
        lines.append(f"  {tip}")

    # Contact window
    lines.append("")
    lines.append("📞 最佳联络时间 (北京 ↔ 巴黎, 08:00-22:00):")
    lines.append("-" * 45)
    window = find_contact_window("北京", "巴黎")
    if window.good_hours:
        for w in window.good_hours:
            lines.append(f"  🕐 北京 {w}")
    else:
        lines.append("  无重叠窗口，建议灵活安排")

    lines.append("")
    lines.append("=" * 55)
    return "\n".join(lines)
