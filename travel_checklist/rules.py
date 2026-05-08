"""Checklist rule engine."""

from .models import TripChecklist, ChecklistItem, Category, TripType, Season
from .cities import get_temp_range, is_tropical


def generate_checklist(city: str, month: int, trip_type: TripType) -> TripChecklist:
    """Generate a full packing checklist."""
    cl = TripChecklist(city=city, month=month, trip_type=trip_type)
    season_key = cl.season.value  # "春季" etc
    low, high = get_temp_range(city, season_key)

    # === 证件 (always) ===
    _add(cl, "身份证/护照", Category.DOCUMENTS, True, "检查有效期>6个月")
    _add(cl, "签证", Category.DOCUMENTS, True, "确认目的地签证要求")
    _add(cl, "机票/车票", Category.DOCUMENTS, True, "电子版备份")
    _add(cl, "酒店预订单", Category.DOCUMENTS, True, "打印或截图")
    _add(cl, "旅行保险单", Category.DOCUMENTS, False)
    _add(cl, "驾照(如需)", Category.DOCUMENTS, False, "国际驾照")

    # === 衣物 (season-based) ===
    if high >= 30:
        _add(cl, "短袖T恤 ×3", Category.CLOTHING, True)
        _add(cl, "短裤/裙子 ×2", Category.CLOTHING, True)
        _add(cl, "凉鞋", Category.CLOTHING, True)
        _add(cl, "遮阳帽", Category.CLOTHING, True)
        _add(cl, "泳衣", Category.CLOTHING, is_tropical(city) or trip_type == TripType.ISLAND)
    elif high >= 20:
        _add(cl, "薄外套 ×1", Category.CLOTHING, True)
        _add(cl, "长裤 ×2", Category.CLOTHING, True)
        _add(cl, "短袖 ×2", Category.CLOTHING, True)
        _add(cl, "薄卫衣 ×1", Category.CLOTHING, False)
    elif high >= 10:
        _add(cl, "厚外套 ×1", Category.CLOTHING, True)
        _add(cl, "毛衣 ×2", Category.CLOTHING, True)
        _add(cl, "长裤 ×2", Category.CLOTHING, True)
        _add(cl, "保暖内衣 ×1", Category.CLOTHING, False)
    else:
        _add(cl, "羽绒服 ×1", Category.CLOTHING, True)
        _add(cl, "保暖内衣 ×2", Category.CLOTHING, True)
        _add(cl, "围巾手套", Category.CLOTHING, True)
        _add(cl, "厚毛衣 ×2", Category.CLOTHING, True)
        _add(cl, "暖宝宝", Category.CLOTHING, False)

    _add(cl, "内衣袜子 ×(天数+1)", Category.CLOTHING, True)
    _add(cl, "运动鞋/舒适鞋", Category.CLOTHING, True)

    # === 电子产品 ===
    _add(cl, "手机+充电器", Category.ELECTRONICS, True)
    _add(cl, "充电宝", Category.ELECTRONICS, True)
    _add(cl, "转换插头", Category.ELECTRONICS, False, "确认目的地插座类型")
    _add(cl, "耳机", Category.ELECTRONICS, False)
    if trip_type == TripType.BUSINESS:
        _add(cl, "笔记本电脑+充电器", Category.ELECTRONICS, True)
        _add(cl, "U盘/移动硬盘", Category.ELECTRONICS, False)
    if trip_type in (TripType.OUTDOOR, TripType.ISLAND):
        _add(cl, "防水手机袋", Category.ELECTRONICS, True)
        _add(cl, "运动相机", Category.ELECTRONICS, False)

    # === 洗漱用品 ===
    _add(cl, "牙刷牙膏", Category.TOILETRIES, True)
    _add(cl, "洗面奶", Category.TOILETRIES, False)
    _add(cl, "防晒霜", Category.TOILETRIES, high >= 15 or is_tropical(city), f"SPF50+")
    _add(cl, "毛巾", Category.TOILETRIES, False, "速干毛巾推荐")
    if trip_type in (TripType.OUTDOOR, TripType.ISLAND):
        _add(cl, "驱蚊液", Category.TOILETRIES, True)
        _add(cl, "晒后修复", Category.TOILETRIES, False)

    # === 药品 ===
    _add(cl, "常备药(感冒/肠胃/创可贴)", Category.MEDICINE, True)
    _add(cl, "个人处方药", Category.MEDICINE, True, "带足用量+处方")
    if is_tropical(city):
        _add(cl, "防蚊虫叮咬药膏", Category.MEDICINE, True)
    if trip_type == TripType.OUTDOOR:
        _add(cl, "跌打损伤药", Category.MEDICINE, False)
        _add(cl, "高原反应药", Category.MEDICINE, False, "如去高原地区")

    # === 其他 ===
    _add(cl, "水杯", Category.OTHER, True)
    _add(cl, "零食", Category.OTHER, False)
    if trip_type == TripType.ISLAND:
        _add(cl, "浮潜面镜", Category.OTHER, False)
        _add(cl, "沙滩巾", Category.OTHER, True)
    if trip_type == TripType.BUSINESS:
        _add(cl, "名片", Category.OTHER, True)
        _add(cl, "正装", Category.OTHER, True, "根据场合")
    _add(cl, "雨伞", Category.OTHER, True, "折叠伞")

    return cl


def _add(cl: TripChecklist, name: str, cat: Category, essential: bool, note: str = ""):
    cl.items.append(ChecklistItem(name=name, category=cat, essential=essential, note=note))
