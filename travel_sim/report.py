"""Report generation for travel SIM/WiFi comparison."""

from .models import SimType
from .database import DATABASE
from .recommender import recommend


def generate_report() -> str:
    lines = []
    lines.append("=" * 60)
    lines.append("       📶 旅行网络方案对比")
    lines.append("=" * 60)

    for plans in DATABASE:
        lines.append("")
        lines.append(f"📍 {plans.country}")
        lines.append("-" * 50)

        # Comparison table
        lines.append(f"  {'方案':<20} {'类型':<10} {'价格':>6} {'流量':>6} {'天数':>4} {'日均':>6}")
        lines.append("-" * 55)
        for opt in plans.options:
            data_str = f"{opt.data_gb}GB" if opt.data_gb < 900 else "不限"
            lines.append(f"  {opt.provider:<18} {opt.sim_type.value:<8} ¥{opt.price_cny:>5.0f} {data_str:>6} {opt.valid_days:>4} ¥{opt.daily_cost:>5.1f}")

        # Pros/cons for top pick
        lines.append("")
        recs = recommend(plans.country, 7)
        if recs:
            best = recs[0]
            opt = best["option"]
            lines.append(f"  🏆 推荐: {opt.provider} ({opt.sim_type.value})")
            lines.append(f"     理由: {', '.join(best['reasons'])}")
            if opt.pros:
                lines.append(f"     优点: {'; '.join(opt.pros[:3])}")
            if opt.cons:
                lines.append(f"     缺点: {'; '.join(opt.cons[:2])}")

        # Tips
        if plans.tips:
            lines.append("")
            for tip in plans.tips:
                lines.append(f"  💡 {tip}")

    lines.append("")
    lines.append("=" * 60)
    return "\n".join(lines)
