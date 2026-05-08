"""Travel Weather — CLI entry point."""

from .models import WeatherReport
from .api import fetch_forecast
from .alerts import generate_alerts, generate_packing
from .report import generate_report


def demo():
    """Demo: fetch and display weather for Tokyo."""
    city = "东京"
    daily = fetch_forecast(city)
    alerts = generate_alerts(daily)
    packing = generate_packing(daily)
    report = WeatherReport(city=city, daily=daily, alerts=alerts, packing=packing)
    print(generate_report(report))


if __name__ == "__main__":
    demo()
