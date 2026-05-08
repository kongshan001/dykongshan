"""Data models for travel weather."""

from dataclasses import dataclass, field
from enum import Enum


class AlertLevel(str, Enum):
    INFO = "ℹ️ 提示"
    WARNING = "⚠️ 警告"
    DANGER = "🚨 危险"


class AlertType(str, Enum):
    HIGH_TEMP = "高温"
    LOW_TEMP = "低温"
    HEAVY_RAIN = "暴雨"
    STRONG_WIND = "大风"
    SNOW = "降雪"
    UV_HIGH = "强紫外线"


@dataclass
class DailyWeather:
    date: str
    temp_max: float
    temp_min: float
    precipitation: float  # mm
    wind_speed: float  # km/h
    uv_index: float
    weather_code: int


@dataclass
class WeatherAlert:
    date: str
    level: AlertLevel
    alert_type: AlertType
    message: str


@dataclass
class PackingSuggestion:
    item: str
    reason: str


@dataclass
class WeatherReport:
    city: str
    daily: list[DailyWeather] = field(default_factory=list)
    alerts: list[WeatherAlert] = field(default_factory=list)
    packing: list[PackingSuggestion] = field(default_factory=list)
