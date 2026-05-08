"""Food database for popular travel destinations."""

from .models import FoodItem, MealTime, PriceLevel, TasteTag

DATABASE: list[FoodItem] = [
    # === 东京 ===
    FoodItem("江户前寿司", "东京", MealTime.LUNCH, PriceLevel.MID, 200, 4.8, [TasteTag.SEAFOOD, TasteTag.MILD], "新鲜鱼生+醋饭，东京是寿司发源地", True),
    FoodItem("拉面", "东京", MealTime.LUNCH, PriceLevel.BUDGET, 60, 4.5, [TasteTag.MEAT, TasteTag.SPICY], "浓厚豚骨/味噌/酱油拉面，种类丰富", True),
    FoodItem("天妇罗", "东京", MealTime.DINNER, PriceLevel.MID, 180, 4.6, [TasteTag.SEAFOOD, TasteTag.MILD], "酥脆薄衣裹炸，蘸天汁食用"),
    FoodItem("居酒屋料理", "东京", MealTime.DINNER, PriceLevel.MID, 250, 4.4, [TasteTag.MEAT, TasteTag.SEAFOOD], "烤鸡串+刺身+啤酒的日式夜生活"),
    FoodItem("章鱼烧", "东京", MealTime.SNACK, PriceLevel.BUDGET, 30, 4.3, [TasteTag.SEAFOOD, TasteTag.MILD], "外酥内软的章鱼小丸子"),
    FoodItem("日式早餐套餐", "东京", MealTime.BREAKFAST, PriceLevel.BUDGET, 50, 4.2, [TasteTag.MILD, TasteTag.SOUP], "米饭+味噌汤+烤鱼+纳豆"),

    # === 巴黎 ===
    FoodItem("法式牛角面包", "巴黎", MealTime.BREAKFAST, PriceLevel.BUDGET, 20, 4.7, [TasteTag.SWEET, TasteTag.MILD], "外酥内软，配咖啡的完美早餐", True),
    FoodItem("法式洋葱汤", "巴黎", MealTime.LUNCH, PriceLevel.MID, 100, 4.5, [TasteTag.SOUP, TasteTag.MILD], "焦糖洋葱+面包+芝士焗烤"),
    FoodItem("鹅肝", "巴黎", MealTime.DINNER, PriceLevel.HIGH, 400, 4.6, [TasteTag.MEAT, TasteTag.SWEET], "法式经典前菜，配无花果酱"),
    FoodItem("法式蜗牛", "巴黎", MealTime.DINNER, PriceLevel.MID, 150, 4.4, [TasteTag.MEAT, TasteTag.MILD], "蒜香黄油焗蜗牛，经典法餐"),
    FoodItem("马卡龙", "巴黎", MealTime.SNACK, PriceLevel.MID, 40, 4.5, [TasteTag.SWEET], "Ladurée/Pierre Hermé 最出名"),
    FoodItem("可丽饼", "巴黎", MealTime.SNACK, PriceLevel.BUDGET, 35, 4.3, [TasteTag.SWEET], "街头薄饼， Nutella+香蕉最经典"),

    # === 曼谷 ===
    FoodItem("冬阴功汤", "曼谷", MealTime.LUNCH, PriceLevel.BUDGET, 40, 4.8, [TasteTag.SPICY, TasteTag.SEAFOOD, TasteTag.SOUP], "酸辣虾汤，泰国国汤", True),
    FoodItem("泰式炒河粉(Pad Thai)", "曼谷", MealTime.LUNCH, PriceLevel.BUDGET, 30, 4.6, [TasteTag.SPICY, TasteTag.SEAFOOD], "酸甜微辣，配花生碎和柠檬", True),
    FoodItem("绿咖喱", "曼谷", MealTime.DINNER, PriceLevel.BUDGET, 50, 4.5, [TasteTag.SPICY, TasteTag.MEAT], "椰奶+绿咖喱酱，配米饭"),
    FoodItem("芒果糯米饭", "曼谷", MealTime.SNACK, PriceLevel.BUDGET, 25, 4.7, [TasteTag.SWEET], "椰浆糯米+新鲜芒果，甜而不腻", True),
    FoodItem("泰式奶茶", "曼谷", MealTime.SNACK, PriceLevel.BUDGET, 10, 4.4, [TasteTag.SWEET], "橘红色奶茶，冰块必加"),
    FoodItem("街头烤肉串", "曼谷", MealTime.SNACK, PriceLevel.BUDGET, 15, 4.3, [TasteTag.MEAT, TasteTag.SPICY], "夜市必吃，配泰式辣酱"),

    # === 北京 ===
    FoodItem("北京烤鸭", "北京", MealTime.DINNER, PriceLevel.MID, 150, 4.8, [TasteTag.MEAT, TasteTag.MILD], "皮脆肉嫩，配薄饼+葱丝+甜面酱", True),
    FoodItem("炸酱面", "北京", MealTime.LUNCH, PriceLevel.BUDGET, 25, 4.4, [TasteTag.MEAT, TasteTag.MILD], "黄酱肉丁拌面，老北京味道"),
    FoodItem("豆汁焦圈", "北京", MealTime.BREAKFAST, PriceLevel.BUDGET, 10, 3.8, [TasteTag.MILD], "独特发酵味，爱的人爱死"),
    FoodItem("卤煮火烧", "北京", MealTime.LUNCH, PriceLevel.BUDGET, 30, 4.2, [TasteTag.MEAT, TasteTag.SPICY], "猪肠+火烧+豆腐，重口味"),
    FoodItem("驴打滚/豌豆黄", "北京", MealTime.SNACK, PriceLevel.BUDGET, 15, 4.3, [TasteTag.SWEET], "传统京味小点心"),

    # === 上海 ===
    FoodItem("小笼包", "上海", MealTime.BREAKFAST, PriceLevel.BUDGET, 35, 4.8, [TasteTag.MEAT, TasteTag.MILD], "薄皮大馅汤汁鲜，蘸醋+姜丝", True),
    FoodItem("红烧肉", "上海", MealTime.DINNER, PriceLevel.MID, 80, 4.6, [TasteTag.MEAT, TasteTag.SWEET], "浓油赤酱，上海本帮菜代表"),
    FoodItem("生煎包", "上海", MealTime.BREAKFAST, PriceLevel.BUDGET, 25, 4.5, [TasteTag.MEAT, TasteTag.MILD], "底部焦脆，一口爆汁"),
    FoodItem("蟹粉豆腐", "上海", MealTime.DINNER, PriceLevel.HIGH, 200, 4.7, [TasteTag.SEAFOOD, TasteTag.MILD], "秋季蟹粉配嫩豆腐，鲜美至极"),
    FoodItem("排骨年糕", "上海", MealTime.LUNCH, PriceLevel.BUDGET, 30, 4.3, [TasteTag.MEAT, TasteTag.SWEET], "大排+年糕+甜辣酱"),
]


def get_by_city(city: str) -> list[FoodItem]:
    return [f for f in DATABASE if f.city == city]


def available_cities() -> list[str]:
    return sorted(set(f.city for f in DATABASE))
