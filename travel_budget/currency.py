"""Currency conversion with caching."""

import json
import time
from pathlib import Path

CACHE_FILE = Path("/tmp/travel_budget_rates.json")
CACHE_TTL = 86400  # 24 hours


def _fetch_rates(base: str = "CNY") -> dict[str, float]:
    """Fetch exchange rates from free API."""
    import urllib.request
    url = f"https://open.er-api.com/v6/latest/{base}"
    with urllib.request.urlopen(url, timeout=10) as resp:
        data = json.loads(resp.read())
    return data.get("rates", {})


def get_rates(base: str = "CNY") -> dict[str, float]:
    """Get exchange rates with 24h cache."""
    cache_key = f"{base}_{CACHE_FILE}"
    if CACHE_FILE.exists():
        cached = json.loads(CACHE_FILE.read_text())
        if cached.get("base") == base and time.time() - cached.get("ts", 0) < CACHE_TTL:
            return cached["rates"]

    rates = _fetch_rates(base)
    CACHE_FILE.write_text(json.dumps({"base": base, "ts": time.time(), "rates": rates}))
    return rates


def convert(amount: float, from_curr: str, to_curr: str = "CNY") -> float:
    """Convert amount between currencies."""
    if from_curr == to_curr:
        return amount
    rates = get_rates(from_curr)
    rate = rates.get(to_curr)
    if rate is None:
        raise ValueError(f"No rate for {from_curr}->{to_curr}")
    return amount * rate
