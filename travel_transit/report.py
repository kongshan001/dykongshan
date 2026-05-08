"""Report generation for travel transit card guide."""

from .models import TransitCard


def generate_report(card: TransitCard) -> str:
    lines = []
    lines.append("=" * 55)
    lines.append("       🚇 交通卡指南")
    lines.append("=" * 55)
    lines.append(f"城市: {card.city} ({card.country})")
    lines.append(f"交通卡: {card.card_name} / {card.card_name_local}")
    lines.append("")

    # Basic info
    lines.append("💳 基本信息:")
    lines.append("-" * 40)
    lines.append(f"  卡片费用: {card.price}")
    lines.append(f"  覆盖范围: {card.coverage}")
    lines.append(f"  押金退还: {card.deposit_refund}")
    lines.append("")

    # Where to buy
    lines.append("🛒 购买地点:")
    lines.append("-" * 40)
    for b in card.where_to_buy:
        lines.append(f"  • {b}")
    lines.append("")

    # Top-up
    lines.append("🔄 充值方式:")
    lines.append("-" * 40)
    for t in card.topup_methods:
        lines.append(f"  • {t}")
    lines.append("")

    # Passes
    if card.passes:
        lines.append("🎫 票种对比:")
        lines.append("-" * 55)
        lines.append(f"  {'票种':<22} {'价格':>8} {'时长':>6}  适合")
        lines.append("-" * 55)
        for p in card.passes:
            lines.append(f"  {p.name:<20} {p.price:>8} {p.duration:>6}  {p.best_for}")
        lines.append("")

    # Tips
    if card.tips:
        lines.append("💡 使用技巧:")
        lines.append("-" * 40)
        for i, tip in enumerate(card.tips, 1):
            lines.append(f"  {i}. {tip}")

    lines.append("")
    lines.append("=" * 55)
    return "\n".join(lines)
