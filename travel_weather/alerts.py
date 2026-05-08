"""Weather alert logic and packing suggestions."""

from .models import DailyWeather, WeatherAlert, AlertLevel, AlertType, PackingSuggestion


def generate_alerts(weather: list[DailyWeather]) -> list[WeatherAlert]:
    """Generate weather alerts based on forecast data."""
    alerts = []
    for w in weather:
        if w.temp_max >= 38:
            alerts.append(WeatherAlert(w.date, AlertLevel.DANGER, AlertType.HIGH_TEMP,
                f"极端高温 {w.temp_max:.0f}°C，避免户外活动"))
        elif w.temp_max >= 35:
            alerts.append(WeatherAlert(w.date, AlertLevel.WARNING, AlertType.HIGH_TEMP,
                f"高温 {w.temp_max:.0f}°C，注意防晒补水"))

        if w.temp_min <= 0:
            alerts.append(WeatherAlert(w.date, AlertLevel.DANGER, AlertType.LOW_TEMP,
                f"严寒 {w.temp_min:.0f}°C，注意保暖"))
        elif w.temp_min <= 5:
            alerts.append(WeatherAlert(w.date, AlertLevel.WARNING, AlertType.LOW_TEMP,
                f"低温 {w.temp_min:.0f}°C，携带保暖衣物"))

        if w.precipitation >= 20:
            alerts.append(WeatherAlert(w.date, AlertLevel.DANGER, AlertType.HEAVY_RAIN,
                f"大暴雨 {w.precipitation:.0f}mm，不建议外出"))
        elif w.precipitation >= 10:
            alerts.append(WeatherAlert(w.date, AlertLevel.WARNING, AlertType.HEAVY_RAIN,
                f"中雨 {w.precipitation:.0f}mm，携带雨具"))
        elif w.precipitation > 0:
            alerts.append(WeatherAlert(w.date, AlertLevel.INFO, AlertType.HEAVY_RAIN,
                f"小雨 {w.precipitation:.1f}mm，建议带伞"))

        if w.wind_speed >= 60:
            alerts.append(WeatherAlert(w.date, AlertLevel.DANGER, AlertType.STRONG_WIND,
                f"大风 {w.wind_speed:.0f}km/h，避免户外活动"))
        elif w.wind_speed >= 40:
            alerts.append(WeatherAlert(w.date, AlertLevel.WARNING, AlertType.STRONG_WIND,
                f"风力较大 {w.wind_speed:.0f}km/h"))

        if w.uv_index >= 8:
            alerts.append(WeatherAlert(w.date, AlertLevel.WARNING, AlertType.UV_HIGH,
                f"紫外线指数 {w.uv_index:.0f}，需要防晒"))
    return alerts


def generate_packing(weather: list[DailyWeather]) -> list[PackingSuggestion]:
    """Generate packing suggestions based on weather."""
    max_temp = max(w.temp_max for w in weather)
    min_temp = min(w.temp_min for w in weather)
    max_rain = max(w.precipitation for w in weather)
    max_uv = max(w.uv_index for w in weather)

    items = []
    if max_temp >= 30:
        items.append(PackingSuggestion("防晒霜 + 遮阳帽", f"最高温{max_temp:.0f}°C"))
    if max_temp >= 35:
        items.append(PackingSuggestion("清凉衣物", "高温天气"))
    if min_temp <= 10:
        items.append(PackingSuggestion("外套/毛衣", f"最低温{min_temp:.0f}°C"))
    if min_temp <= 0:
        items.append(PackingSuggestion("羽绒服 + 手套", "严寒天气"))
    if max_rain > 0:
        items.append(PackingSuggestion("雨伞/雨衣", "有降水可能"))
    if max_uv >= 6:
        items.append(PackingSuggestion("墨镜", f"紫外线指数可达{max_uv:.0f}"))
    items.append(PackingSuggestion("舒适步行鞋", "旅行必备"))
    return items
