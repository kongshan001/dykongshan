"""Weather API client using Open-Meteo (free, no key required)."""

import json
import urllib.request
from .models import DailyWeather

# City coordinates
CITIES = {
    "东京": (35.6762, 139.6503),
    "巴黎": (48.8566, 2.3522),
    "曼谷": (13.7563, 100.5018),
    "北京": (39.9042, 116.4074),
    "上海": (31.2304, 121.4737),
    "纽约": (40.7128, -74.0060),
    "伦敦": (51.5074, -0.1278),
    "悉尼": (-33.8688, 151.2093),
}


def get_coordinates(city: str) -> tuple[float, float]:
    return CITIES.get(city, (35.6762, 139.6503))


def fetch_forecast(city: str) -> list[DailyWeather]:
    """Fetch 7-day forecast from Open-Meteo API."""
    lat, lng = get_coordinates(city)
    url = (
        f"https://api.open-meteo.com/v1/forecast?"
        f"latitude={lat}&longitude={lng}"
        f"&daily=temperature_2m_max,temperature_2m_min,precipitation_sum,"
        f"wind_speed_10m_max,uv_index_max,weather_code"
        f"&timezone=auto&forecast_days=7"
    )
    with urllib.request.urlopen(url, timeout=15) as resp:
        data = json.loads(resp.read())

    daily = data.get("daily", {})
    dates = daily.get("time", [])
    result = []
    for i in range(len(dates)):
        result.append(DailyWeather(
            date=dates[i],
            temp_max=daily["temperature_2m_max"][i],
            temp_min=daily["temperature_2m_min"][i],
            precipitation=daily["precipitation_sum"][i],
            wind_speed=daily["wind_speed_10m_max"][i],
            uv_index=daily["uv_index_max"][i],
            weather_code=daily["weather_code"][i],
        ))
    return result
