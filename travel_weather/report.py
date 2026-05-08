"""Report generation for travel weather."""

from .models import WeatherReport


def generate_report(report: WeatherReport) -> str:
    lines = []
    lines.append("=" * 55)
    lines.append("       🌤️  旅行天气预报")
    lines.append("=" * 55)
    lines.append(f"目的地: {report.city}")
    lines.append("")

    # Daily forecast
    lines.append("📅 7天预报:")
    lines.append("-" * 55)
    lines.append(f"{'日期':>12} {'最高':>6} {'最低':>6} {'降水':>8} {'风速':>8} {'UV':>4}")
    lines.append("-" * 55)
    for w in report.daily:
        lines.append(f"{w.date:>12} {w.temp_max:>5.0f}° {w.temp_min:>5.0f}° {w.precipitation:>6.1f}mm {w.wind_speed:>6.0f}km/h {w.uv_index:>3.0f}")

    # Alerts
    if report.alerts:
        lines.append("")
        lines.append("🔔 天气预警:")
        lines.append("-" * 40)
        for a in report.alerts:
            lines.append(f"  {a.level.value} {a.date}: {a.message}")
    else:
        lines.append("")
        lines.append("✅ 未来7天无恶劣天气预警")

    # Packing
    if report.packing:
        lines.append("")
        lines.append("🎒 建议携带:")
        lines.append("-" * 40)
        for p in report.packing:
            lines.append(f"  • {p.item} ({p.reason})")

    lines.append("")
    lines.append("=" * 55)
    return "\n".join(lines)
