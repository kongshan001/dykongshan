"""Safety database for popular travel destinations."""

from .models import SafetyRating, EmergencyContact, RiskTip, RiskLevel, RiskCategory

# Safety data per destination
DATABASE = {
    "东京": {
        "country": "日本",
        "ratings": [
            SafetyRating(RiskCategory.CRIME, RiskLevel.LOW, "全球最安全城市之一，暴力犯罪极少"),
            SafetyRating(RiskCategory.HEALTH, RiskLevel.LOW, "医疗水平高，自来水可直饮"),
            SafetyRating(RiskCategory.NATURAL, RiskLevel.MEDIUM, "地震多发区，需了解避难常识"),
            SafetyRating(RiskCategory.TRAFFIC, RiskLevel.LOW, "交通秩序良好，靠左行驶"),
            SafetyRating(RiskCategory.SCAM, RiskLevel.LOW, "诈骗较少，商家诚信度高"),
        ],
        "emergencies": [
            EmergencyContact("警察", "110"),
            EmergencyContact("消防/急救", "119"),
            EmergencyContact("中国大使馆", "+81-3-3403-3388"),
            EmergencyContact("旅游热线", "+81-50-3816-2787"),
        ],
        "risks": [
            RiskTip(RiskCategory.NATURAL, "地震", "日本地震频发", "熟悉酒店避难路线，准备应急包"),
            RiskTip(RiskCategory.HEALTH, "花粉症", "春季杉树花粉严重", "携带口罩和抗过敏药"),
            RiskTip(RiskCategory.TRAFFIC, "靠左行驶", "车辆靠左，过马路注意方向", "先看右再看左"),
        ],
    },
    "巴黎": {
        "country": "法国",
        "ratings": [
            SafetyRating(RiskCategory.CRIME, RiskLevel.MEDIUM, "扒窃高发，尤其地铁和景区"),
            SafetyRating(RiskCategory.HEALTH, RiskLevel.LOW, "医疗体系完善"),
            SafetyRating(RiskCategory.NATURAL, RiskLevel.LOW, "自然灾害风险低"),
            SafetyRating(RiskCategory.TRAFFIC, RiskLevel.MEDIUM, "交通较混乱，罢工频繁"),
            SafetyRating(RiskCategory.SCAM, RiskLevel.MEDIUM, "常见签名骗局和假 petition"),
        ],
        "emergencies": [
            EmergencyContact("全欧洲紧急", "112"),
            EmergencyContact("警察", "17"),
            EmergencyContact("急救", "15"),
            EmergencyContact("中国大使馆", "+33-1-4952-1950"),
        ],
        "risks": [
            RiskTip(RiskCategory.CRIME, "扒窃", "地铁/景区/餐厅扒窃高发", "贴身携带护照，背包前背"),
            RiskTip(RiskCategory.SCAM, "签名骗局", "街头有人请签名后索钱", "直接拒绝，快速离开"),
            RiskTip(RiskCategory.CRIME, "假警察", "假冒警察查验护照", "要求去附近警察局处理"),
            RiskTip(RiskCategory.TRAFFIC, "罢工", "公共交通罢工频繁", "关注新闻，备选出行方案"),
        ],
    },
    "曼谷": {
        "country": "泰国",
        "ratings": [
            SafetyRating(RiskCategory.CRIME, RiskLevel.MEDIUM, "总体安全，需防范飞车抢夺"),
            SafetyRating(RiskCategory.HEALTH, RiskLevel.MEDIUM, "注意饮食卫生和登革热"),
            SafetyRating(RiskCategory.NATURAL, RiskLevel.MEDIUM, "雨季洪涝，注意天气预报"),
            SafetyRating(RiskCategory.TRAFFIC, RiskLevel.HIGH, "交通事故率高，摩托车危险"),
            SafetyRating(RiskCategory.SCAM, RiskLevel.MEDIUM, "宝石骗局、嘟嘟车套路"),
        ],
        "emergencies": [
            EmergencyContact("旅游警察", "1155", "有中文服务"),
            EmergencyContact("警察", "191"),
            EmergencyContact("急救", "1669"),
            EmergencyContact("中国大使馆", "+66-2-245-7044"),
        ],
        "risks": [
            RiskTip(RiskCategory.SCAM, "宝石骗局", "被带到珠宝店高价购买假货", "只在正规商店购买，拒绝陌生人推荐"),
            RiskTip(RiskCategory.TRAFFIC, "摩托车", "交通事故率高", "戴头盔，避免夜间骑行"),
            RiskTip(RiskCategory.HEALTH, "登革热", "蚊虫传播的热带疾病", "使用驱蚊液，穿长袖"),
            RiskTip(RiskCategory.CRIME, "飞车抢夺", "路边抢包事件时有发生", "背包远离路侧，不用手机导航时收好"),
        ],
    },
    "纽约": {
        "country": "美国",
        "ratings": [
            SafetyRating(RiskCategory.CRIME, RiskLevel.MEDIUM, "主要景区安全，部分区域需避开"),
            SafetyRating(RiskCategory.HEALTH, RiskLevel.LOW, "医疗费用高，建议买旅行保险"),
            SafetyRating(RiskCategory.NATURAL, RiskLevel.LOW, "自然灾害风险低"),
            SafetyRating(RiskCategory.TRAFFIC, RiskLevel.MEDIUM, "行人路权优先，但需警惕"),
            SafetyRating(RiskCategory.SCAM, RiskLevel.LOW, "较少针对游客的诈骗"),
        ],
        "emergencies": [
            EmergencyContact("紧急电话", "911"),
            EmergencyContact("中国总领馆", "+1-212-244-9392"),
        ],
        "risks": [
            RiskTip(RiskCategory.CRIME, "部分区域", "深夜避免布朗克斯/布鲁克林部分区域", "使用主流街道，避免偏僻小巷"),
            RiskTip(RiskCategory.HEALTH, "医疗费用", "美国医疗费用极高", "购买足额旅行保险"),
            RiskTip(RiskCategory.CRIME, "地铁安全", "深夜地铁安全性下降", "避免深夜单独乘地铁"),
        ],
    },
}


def get_safety_data(city: str) -> dict | None:
    return DATABASE.get(city)


def available_cities() -> list[str]:
    return list(DATABASE.keys())
