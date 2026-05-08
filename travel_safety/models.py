"""Data models for travel safety."""

from dataclasses import dataclass, field
from enum import Enum


class RiskLevel(str, Enum):
    LOW = "🟢 低风险"
    MEDIUM = "🟡 中风险"
    HIGH = "🟠 高风险"
    VERY_HIGH = "🔴 极高风险"


class RiskCategory(str, Enum):
    CRIME = "治安"
    HEALTH = "卫生"
    NATURAL = "自然灾害"
    TRAFFIC = "交通"
    SCAM = "诈骗"


@dataclass
class SafetyRating:
    category: RiskCategory
    level: RiskLevel
    description: str


@dataclass
class EmergencyContact:
    name: str
    phone: str
    note: str = ""


@dataclass
class RiskTip:
    category: RiskCategory
    title: str
    description: str
    prevention: str


@dataclass
class SafetyChecklistItem:
    item: str
    done: bool = False


@dataclass
class SafetyReport:
    city: str
    country: str
    ratings: list[SafetyRating] = field(default_factory=list)
    emergencies: list[EmergencyContact] = field(default_factory=list)
    risks: list[RiskTip] = field(default_factory=list)
    checklist: list[SafetyChecklistItem] = field(default_factory=list)
