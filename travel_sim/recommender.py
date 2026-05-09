"""Recommendation engine for travel SIM."""

from .models import SimType, CountryPlans
from .database import get_by_country


def recommend(country: str, days: int = 7, need_calls: bool = False, group_size: int = 1) -> list[dict]:
    """Recommend best options based on criteria."""
    plans = get_by_country(country)
    if not plans:
        return []

    scored = []
    for opt in plans.options:
        score = 0
        reasons = []

        # Cost per day efficiency
        if opt.valid_days >= days:
            score += 3
            reasons.append(f"覆盖{days}天行程")
        else:
            packs = (days + opt.valid_days - 1) // opt.valid_days
            total_cost = opt.price_cny * packs
            if total_cost < 200:
                score += 2
                reasons.append(f"需{packs}张共¥{total_cost:.0f}")

        # Group discount
        if group_size > 1 and opt.sim_type == SimType.WIFI_EGG:
            score += 3
            reasons.append(f"多人共享(×{group_size})")

        # Calls
        if need_calls and "通话" in " ".join(opt.pros):
            score += 2
            reasons.append("支持通话")

        # eSIM convenience
        if opt.sim_type == SimType.ESIM:
            score += 1
            reasons.append("即买即用")

        # Daily cost
        if opt.daily_cost < 10:
            score += 2
            reasons.append(f"日均¥{opt.daily_cost:.0f}")
        elif opt.daily_cost < 20:
            score += 1

        scored.append({"option": opt, "score": score, "reasons": reasons})

    scored.sort(key=lambda x: x["score"], reverse=True)
    return scored
