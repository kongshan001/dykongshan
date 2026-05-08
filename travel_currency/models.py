"""Data models for travel currency."""

from dataclasses import dataclass, field


@dataclass
class ExchangeResult:
    from_currency: str
    to_currency: str
    amount: float
    rate: float
    result: float
    fee_percent: float = 0.0
    fee_amount: float = 0.0

    @property
    def net_result(self) -> float:
        return self.result - self.fee_amount


@dataclass
class CurrencyInfo:
    code: str
    name: str
    symbol: str
    popular: bool = False  # 旅行常用币种


@dataclass
class RateSnapshot:
    base: str
    rates: dict[str, float]
    timestamp: float
