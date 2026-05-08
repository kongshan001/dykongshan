"""Data models for travel transit card guide."""

from dataclasses import dataclass, field


@dataclass
class TransitPass:
    name: str
    price: str
    duration: str
    coverage: str
    best_for: str


@dataclass
class TransitCard:
    city: str
    country: str
    card_name: str
    card_name_local: str
    price: str  # 卡片价格/押金
    topup_methods: list[str]
    where_to_buy: list[str]
    deposit_refund: str
    coverage: str  # 覆盖范围
    passes: list[TransitPass] = field(default_factory=list)
    tips: list[str] = field(default_factory=list)
