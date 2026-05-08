"""Safety checklist generator."""

from .models import SafetyChecklistItem


def generate_checklist(country: str) -> list[SafetyChecklistItem]:
    """Generate pre-trip safety checklist."""
    items = [
        SafetyChecklistItem("购买旅行保险（含医疗+意外）"),
        SafetyChecklistItem("复印护照/签证，电子版存手机+云端"),
        SafetyChecklistItem("记录大使馆/领事馆地址和电话"),
        SafetyChecklistItem("告知家人行程和联系方式"),
        SafetyChecklistItem("手机开通国际漫游或购买当地SIM卡"),
        SafetyChecklistItem("下载离线地图（Google Maps/高德）"),
        SafetyChecklistItem("准备少量当地现金备用"),
        SafetyChecklistItem("了解当地紧急电话号码"),
        SafetyChecklistItem("携带常用药品和处方"),
        SafetyChecklistItem("贵重物品分开放置，不全部放在一处"),
    ]
    return items
