"""Report generation for travel currency."""

from .rates import POPULAR, get_rates
from .convert import convert


def generate_report() -> str:
    """Generate full currency report."""
    lines = []
    lines.append("=" * 55)
    lines.append("       💱 旅行货币兑换助手")
    lines.append("=" * 55)

    # Quick reference table
    lines.append("")
    lines.append("📊 旅行常用币种速查 (基准: CNY)")
    lines.append("-" * 45)
    lines.append(f"  {'币种':<8} {'汇率':>10} {'1000元可得':>12}")
    lines.append("-" * 45)

    snapshot = get_rates("CNY")
    popular_codes = [c for c in POPULAR if c in snapshot.rates and c != "CNY"]
    for code in popular_codes[:10]:
        name, symbol = POPULAR[code]
        rate = snapshot.rates[code]
        lines.append(f"  {code:<8} {rate:>10.4f} {1000/rate:>10.2f} {symbol}")

    # Sample conversions with fee
    lines.append("")
    lines.append("💸 兑换示例 (手续费 1.5%)")
    lines.append("-" * 45)
    scenarios = [
        (1000, "CNY", "JPY"),
        (5000, "CNY", "THB"),
        (500, "USD", "CNY"),
        (1000, "EUR", "CNY"),
    ]
    for amount, fr, to in scenarios:
        r = convert(amount, fr, to)
        to_name = POPULAR.get(to, (to, ""))[0]
        lines.append(f"  {r.amount:,.0f} {fr} → {r.net_result:,.0f} {to} ({to_name})")
        lines.append(f"    汇率: {r.rate:.4f} | 手续费: {r.fee_amount:,.2f} {to}")

    lines.append("")
    lines.append("=" * 55)
    return "\n".join(lines)
