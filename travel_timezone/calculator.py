"""Timezone difference calculator and jet lag advisor."""

from .models import Direction, JetLagAdvice, ContactWindow
from .cities import get_current_time, CITIES


def calc_time_diff(from_city: str, to_city: str) -> float:
    """Calculate time difference in hours (to - from)."""
    _, _, off_from = get_current_time(from_city)
    _, _, off_to = get_current_time(to_city)
    return off_to - off_from


def get_jet_lag_advice(from_city: str, to_city: str) -> JetLagAdvice:
    """Generate jet lag advice based on flight direction."""
    diff = calc_time_diff(from_city, to_city)

    if diff > 0:
        direction = Direction.EAST
        tips = [
            f"目的地比出发地快 {diff:.0f} 小时",
            "🛌 出发前几天提早1-2小时入睡",
            "☀️ 到达后上午多晒太阳，帮助调整生物钟",
            "💤 避免午后长时间午睡（限30分钟）",
            "🍵 到达首日避免咖啡因和酒精",
        ]
    elif diff < 0:
        direction = Direction.WEST
        abs_diff = abs(diff)
        tips = [
            f"目的地比出发地慢 {abs_diff:.0f} 小时",
            "🛌 出发前几天延后1-2小时入睡",
            "🌙 到达后晚间保持明亮光线",
            "🏃 下午进行适度运动帮助保持清醒",
            "💤 若困倦可短午睡（限30分钟）",
        ]
    else:
        direction = Direction.SAME
        tips = ["无时差，无需调整"]

    return JetLagAdvice(direction, diff, tips)


def find_contact_window(from_city: str, to_city: str, start_hour: int = 8, end_hour: int = 22) -> ContactWindow:
    """Find overlapping waking hours between two cities."""
    _, _, off_from = get_current_time(from_city)
    _, _, off_to = get_current_time(to_city)
    diff = off_to - off_from

    good = []
    for h in range(start_hour, end_hour + 1):
        to_h = h + diff
        if start_hour <= to_h <= end_hour:
            good.append(f"{h:02d}:00 (对方 {int(to_h):02d}:00)")

    return ContactWindow(from_city, to_city, good)
