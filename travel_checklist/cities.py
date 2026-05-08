"""City climate data for seasonal recommendations."""

# City -> hemisphere -> avg temp range by month
# Simplified: (avg_low, avg_high) per season
_SEASON_MAP = {"春季": "spring", "夏季": "summer", "秋季": "autumn", "冬季": "winter"}

CITY_CLIMATE = {
    "东京":   {"hemisphere": "N", "spring": (10, 20), "summer": (22, 33), "autumn": (10, 22), "winter": (-1, 10)},
    "巴黎":   {"hemisphere": "N", "winter": (1, 7),   "spring": (6, 18),  "summer": (14, 26), "autumn": (6, 16)},
    "曼谷":   {"hemisphere": "N", "winter": (21, 32), "spring": (24, 35), "summer": (24, 34), "autumn": (23, 33)},
    "北京":   {"hemisphere": "N", "winter": (-8, 3),  "spring": (6, 22),  "summer": (21, 32), "autumn": (5, 20)},
    "上海":   {"hemisphere": "N", "winter": (1, 8),   "spring": (9, 20),  "summer": (23, 34), "autumn": (12, 23)},
    "纽约":   {"hemisphere": "N", "winter": (-3, 4),  "spring": (5, 18),  "summer": (19, 30), "autumn": (6, 18)},
    "伦敦":   {"hemisphere": "N", "winter": (2, 8),   "spring": (5, 15),  "summer": (13, 24), "autumn": (6, 15)},
    "悉尼":   {"hemisphere": "S", "winter": (8, 17),  "spring": (13, 22), "summer": (19, 27), "autumn": (13, 22)},
}

TROPICAL_CITIES = {"曼谷", "巴厘岛", "马尔代夫", "新加坡"}


def get_temp_range(city: str, season: str) -> tuple[float, float]:
    """Get average temperature range for a city in a season. season is Chinese e.g. '夏季'."""
    data = CITY_CLIMATE.get(city)
    if data:
        key = _SEASON_MAP.get(season, season)
        return data.get(key, (10, 25))
    return (5, 25)  # default


def is_tropical(city: str) -> bool:
    return city in TROPICAL_CITIES
