"""City timezone data."""

from zoneinfo import ZoneInfo
from datetime import datetime, timezone

# City -> IANA timezone
CITIES = {
    "北京": "Asia/Shanghai",
    "上海": "Asia/Shanghai",
    "东京": "Asia/Tokyo",
    "首尔": "Asia/Seoul",
    "曼谷": "Asia/Bangkok",
    "新加坡": "Asia/Singapore",
    "巴黎": "Europe/Paris",
    "伦敦": "Europe/London",
    "纽约": "America/New_York",
    "洛杉矶": "America/Los_Angeles",
    "悉尼": "Australia/Sydney",
    "迪拜": "Asia/Dubai",
    "莫斯科": "Europe/Moscow",
    "柏林": "Europe/Berlin",
    "罗马": "Europe/Rome",
    "台北": "Asia/Taipei",
    "香港": "Asia/Hong_Kong",
    "大阪": "Asia/Osaka",
}


def get_current_time(city: str) -> tuple[str, str, float]:
    """Returns (HH:MM, YYYY-MM-DD, utc_offset_hours) for a city."""
    tz_name = CITIES.get(city, "UTC")
    tz = ZoneInfo(tz_name)
    now = datetime.now(tz)
    # Get UTC offset properly
    utcoffset = now.utcoffset()
    offset_hours = utcoffset.total_seconds() / 3600 if utcoffset else 0.0
    return now.strftime("%H:%M"), now.strftime("%Y-%m-%d"), offset_hours
