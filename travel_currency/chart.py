"""ASCII chart for exchange rate trends (simulated)."""

import random
import math


def generate_trend_chart(base: str, target: str, days: int = 30) -> str:
    """Generate a simulated ASCII sparkline chart for rate trend."""
    # Simulate historical rates around current rate
    from .rates import get_rates
    snapshot = get_rates(base)
    current = snapshot.rates.get(target, 1.0)

    random.seed(hash(base + target))
    rates = []
    rate = current * random.uniform(0.95, 1.05)
    for _ in range(days):
        change = random.gauss(0, current * 0.003)
        rate += change
        rates.append(rate)
    rates[-1] = current  # last point is actual

    # Build ASCII chart
    min_r = min(rates)
    max_r = max(rates)
    height = 10
    width = min(days, 50)

    # Resample to width
    step = len(rates) / width
    sampled = [rates[int(i * step)] for i in range(width)]

    lines = []
    lines.append(f"  {base}/{target} 近{days}天趋势 (模拟)")
    lines.append(f"  当前: {current:.4f}")
    lines.append("")

    for row in range(height, -1, -1):
        threshold = min_r + (max_r - min_r) * row / height
        label = f"{threshold:>8.4f} │"
        bar = ""
        for r in sampled:
            normalized = (r - min_r) / (max_r - min_r) * height if max_r > min_r else height / 2
            if abs(normalized - row) < 0.6:
                bar += "●"
            elif normalized > row:
                bar += "│"
            else:
                bar += " "
        lines.append(f"{label}{bar}")

    lines.append(f"{'':>9} └{'─' * width}")
    lines.append(f"{'':>9}  {'←' + str(days) + '天':^{width}}")
    return "\n".join(lines)
