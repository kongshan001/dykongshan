"""Exchange rate fetching with 24h cache."""

import json
import time
from pathlib import Path
from .models import RateSnapshot

CACHE_FILE = Path("/tmp/travel_currency_rates.json")
CACHE_TTL = 86400

# Popular travel currencies
POPULAR = {
    "CNY": ("人民币", "¥"),
    "USD": ("美元", "$"),
    "EUR": ("欧元", "€"),
    "JPY": ("日元", "¥"),
    "GBP": ("英镑", "£"),
    "THB": ("泰铢", "฿"),
    "KRW": ("韩元", "₩"),
    "AUD": ("澳元", "A$"),
    "SGD": ("新加坡元", "S$"),
    "HKD": ("港币", "HK$"),
    "TWD": ("新台币", "NT$"),
    "MYR": ("马来西亚林吉特", "RM"),
    "VND": ("越南盾", "₫"),
    "IDR": ("印尼盾", "Rp"),
    "CAD": ("加元", "C$"),
}


def _fetch(base: str) -> dict[str, float]:
    import urllib.request
    url = f"https://open.er-api.com/v6/latest/{base}"
    with urllib.request.urlopen(url, timeout=10) as resp:
        data = json.loads(resp.read())
    return data.get("rates", {})


def get_rates(base: str = "CNY") -> RateSnapshot:
    """Get rates with cache."""
    if CACHE_FILE.exists():
        cached = json.loads(CACHE_FILE.read_text())
        if cached.get("base") == base and time.time() - cached.get("ts", 0) < CACHE_TTL:
            return RateSnapshot(base=base, rates=cached["rates"], timestamp=cached["ts"])

    rates = _fetch(base)
    ts = time.time()
    CACHE_FILE.write_text(json.dumps({"base": base, "ts": ts, "rates": rates}))
    return RateSnapshot(base=base, rates=rates, timestamp=ts)
