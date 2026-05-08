"""Data models for travel translator."""

from dataclasses import dataclass, field
from enum import Enum


class Language(str, Enum):
    ZH = "中文"
    EN = "English"
    JA = "日本語"
    FR = "Français"
    TH = "ไทย"
    KO = "한국어"


class Scene(str, Enum):
    GREETING = "🙋 问候"
    TRANSPORT = "🚌 交通"
    DINING = "🍜 餐饮"
    SHOPPING = "🛍️ 购物"
    EMERGENCY = "🚨 紧急"
    HOTEL = "🏨 住宿"


@dataclass
class Phrase:
    scene: Scene
    translations: dict[str, str]  # Language code -> text
    pronunciation: dict[str, str]  # Language code -> reading aid
    keywords: list[str] = field(default_factory=list)
