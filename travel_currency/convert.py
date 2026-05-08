"""Currency conversion logic."""

from .models import ExchangeResult
from .rates import get_rates


def convert(amount: float, from_curr: str, to_curr: str, fee_percent: float = 1.5) -> ExchangeResult:
    """Convert amount with fee simulation."""
    if from_curr == to_curr:
        return ExchangeResult(from_curr, to_curr, amount, 1.0, amount, 0.0, 0.0)

    snapshot = get_rates(from_curr)
    rate = snapshot.rates.get(to_curr)
    if rate is None:
        # Try cross-rate via USD
        return _cross_convert(amount, from_curr, to_curr, fee_percent)

    result = amount * rate
    fee = result * fee_percent / 100
    return ExchangeResult(from_curr, to_curr, amount, rate, result, fee_percent, fee)


def _cross_convert(amount: float, from_curr: str, to_curr: str, fee: float) -> ExchangeResult:
    """Cross-rate via base currency."""
    snap_from = get_rates(from_curr)
    snap_to = get_rates(to_curr)
    # from_curr -> USD -> to_curr (approximate)
    usd_from = snap_from.rates.get("USD", 1.0) if from_curr != "USD" else 1.0
    if from_curr != "USD":
        usd_amount = amount * usd_from
    else:
        usd_amount = amount
    # USD -> to_curr
    snap_base = get_rates("USD")
    rate_to = snap_base.rates.get(to_curr, 1.0)
    result = usd_amount * rate_to
    effective_rate = result / amount if amount else 0
    fee_amount = result * fee / 100
    return ExchangeResult(from_curr, to_curr, amount, effective_rate, result, fee, fee_amount)
