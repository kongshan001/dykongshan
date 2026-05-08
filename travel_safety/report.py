"""Report generation for travel safety."""

from .models import SafetyReport, RiskCategory
from .checklist import generate_checklist


def generate_report(report: SafetyReport) -> str:
    lines = []
    lines.append("=" * 55)
    lines.append("       🛡️ 旅行安全指南")
    lines.append("=" * 55)
    lines.append(f"目的地: {report.city} ({report.country})")
    lines.append("")

    # Safety ratings
    lines.append("📋 安全评级:")
    lines.append("-" * 40)
    for r in report.ratings:
        lines.append(f"  {r.category.value:>4}: {r.level.value} — {r.description}")
    lines.append("")

    # Emergency contacts
    if report.emergencies:
        lines.append("📞 紧急联系方式:")
        lines.append("-" * 40)
        for e in report.emergencies:
            note = f" ({e.note})" if e.note else ""
            lines.append(f"  {e.name}: {e.phone}{note}")
        lines.append("")

    # Risk tips
    if report.risks:
        lines.append("⚠️ 风险提示:")
        lines.append("-" * 40)
        for r in report.risks:
            lines.append(f"  【{r.title}】{r.description}")
            lines.append(f"    → 防范: {r.prevention}")
        lines.append("")

    # Safety checklist
    items = generate_checklist(report.country)
    lines.append("✅ 出行前安全准备:")
    lines.append("-" * 40)
    for i, item in enumerate(items, 1):
        lines.append(f"  {i:>2}. ☐ {item.item}")

    lines.append("")
    lines.append("=" * 55)
    return "\n".join(lines)
