"""Data models for travel SIM/WiFi comparison."""

from dataclasses import dataclass, field
from enum import Enum


class SimType(str, Enum):
    ESIM = "📱 eSIM"
    PHYSICAL = "💳 实体SIM卡"
    WIFI_EGG = "📡 WiFi蛋"
    ROAMING = "🌐 国际漫游"


@dataclass
class SimOption:
    provider: str
    sim_type: SimType
    price_cny: float
    data_gb: float
    valid_days: int
    speed: str  # 4G/5G
    coverage: str
    pros: list[str] = field(default_factory=list)
    cons: list[str] = field(default_factory=list)

    @property
    def daily_cost(self) -> float:
        return self.price_cny / self.valid_days if self.valid_days else 0

    @property
    def cost_per_gb(self) -> float:
        return self.price_cny / self.data_gb if self.data_gb else 0


@dataclass
class CountryPlans:
    country: str
    options: list[SimOption] = field(default_factory=list)
    tips: list[str] = field(default_factory=list)
