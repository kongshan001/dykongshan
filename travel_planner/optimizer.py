"""Route optimizer using greedy nearest-neighbor algorithm."""

import math
from .models import Spot


def _haversine_km(s1: Spot, s2: Spot) -> float:
    """Approximate distance between two spots in km."""
    R = 6371.0
    dlat = math.radians(s2.lat - s1.lat)
    dlng = math.radians(s2.lng - s1.lng)
    a = math.sin(dlat / 2) ** 2 + math.cos(math.radians(s1.lat)) * math.cos(math.radians(s2.lat)) * math.sin(dlng / 2) ** 2
    return R * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))


def optimize_route(spots: list[Spot]) -> list[Spot]:
    """Sort spots by nearest-neighbor greedy algorithm."""
    if len(spots) <= 1:
        return spots
    remaining = list(spots)
    ordered = [remaining.pop(0)]
    while remaining:
        last = ordered[-1]
        nearest = min(remaining, key=lambda s: _haversine_km(last, s))
        remaining.remove(nearest)
        ordered.append(nearest)
    return ordered


def score_spot(spot: Spot, preferences: dict[str, float]) -> float:
    """Score a spot based on preferences and rating."""
    pref_weight = preferences.get(spot.category, 1.0)
    return spot.rating * pref_weight


def select_spots(spots: list[Spot], max_hours: float, preferences: dict[str, float]) -> list[Spot]:
    """Select top spots within time budget, scored by preference + rating."""
    scored = sorted(spots, key=lambda s: score_spot(s, preferences), reverse=True)
    selected = []
    hours_used = 0.0
    for s in scored:
        if hours_used + s.duration_hours <= max_hours:
            selected.append(s)
            hours_used += s.duration_hours
    return optimize_route(selected)
