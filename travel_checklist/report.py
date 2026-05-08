"""Report generation for travel checklist."""

from .models import TripChecklist, Category


def generate_report(cl: TripChecklist) -> str:
    lines = []
    lines.append("=" * 50)
    lines.append("       🎒 旅行打包清单")
    lines.append("=" * 50)
    lines.append(f"目的地: {cl.city} | {cl.season.value}出行 | {cl.trip_type.value}旅行")
    lines.append("")

    # Group by category
    by_cat: dict[Category, list] = {}
    for item in cl.items:
        by_cat.setdefault(item.category, []).append(item)

    total = len(cl.items)
    essential = sum(1 for i in cl.items if i.essential)

    for cat in Category:
        items = by_cat.get(cat, [])
        if not items:
            continue
        lines.append(f"{cat.value}")
        lines.append("-" * 35)
        for item in items:
            mark = "✅" if item.essential else "⬜"
            note = f" ({item.note})" if item.note else ""
            lines.append(f"  {mark} {item.name}{note}")
        lines.append("")

    lines.append("=" * 50)
    lines.append(f"  共 {total} 项 (必带 {essential} 项, 可选 {total - essential} 项)")
    lines.append("=" * 50)
    return "\n".join(lines)
