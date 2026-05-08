"""Transit card database for major cities."""

from .models import TransitCard, TransitPass

DATABASE: list[TransitCard] = [
    TransitCard("东京", "日本", "SUICA/PASMO", "スイカ/パスモ",
        "¥2000 (含押金¥500)", ["车站售票机", "便利店", "手机NFC"],
        ["机场车站", "JR售票处", "便利店"],
        "退卡时返还押金¥500，扣手续费¥220",
        "JR/地铁/公交/便利店购物/自动售货机",
        [
            TransitPass("东京地铁24h券", "¥600", "24小时", "东京Metro全线", "1天内多次乘坐地铁"),
            TransitPass("东京地铁48h券", "¥850", "48小时", "东京Metro全线", "2天地铁出行"),
            TransitPass("东京地铁72h券", "¥900", "72小时", "东京Metro全线", "3天以上最划算"),
            TransitPass("JR东京广域周游券", "¥10180", "3天", "JR东日本区域", "去周边城市"),
        ],
        ["SUICA和PASMO通用，买哪个都行", "手机Apple Pay可添加SUICA，无需实体卡", "单次乘车约¥170-¥320，3天以上建议买72h券", "便利店可用SUICA付款，非常方便"]),
    TransitCard("巴黎", "法国", "Navigo Easy", "Navigo Easy",
        "卡片€2 (不退)", ["车站售票机", "APP Bonjour RATP"],
        ["地铁站售票机", "机场", "RATP售票处"],
        "卡费不退，可留作纪念",
        "地铁/公交/电车/RER (Zone 1-5需注意)",
        [
            TransitPass("t+单次票", "€2.15", "单次", "Zone 1内", "偶尔坐车"),
            TransitPass("10次票 (carnet)", "€17.35", "10次", "Zone 1内", "短途多次"),
            TransitPass("Navigo Jour日票", "€8.45", "1天", "Zone 1-5", "一天密集出行"),
            TransitPass("Navigo Semaine周票", "€30", "1周", "全区域含机场", "一周以上最划算"),
        ],
        ["Navigo Easy卡不记名，丢失不补", "周票从周一开始计算，周三后买不划算", "去凡尔赛宫需Zone 1-5票，普通票不够", "机场CDG到市区用RER B线需要特殊票"]),
    TransitCard("曼谷", "泰国", "Rabbit Card", "Rabbit Card",
        "卡费不可退", ["BTS站售票机", "BTS站柜台"],
        ["BTS轻轨站", "部分便利店"],
        "卡费不退",
        "BTS轻轨 (不含MRT地铁/BRT公交)",
        [
            TransitPass("BTS One Day Pass", "฿150", "1天", "BTS全线", "一天多次坐BTS"),
            TransitPass("Rabbit 15次票", "฿455", "15次", "BTS全线", "频繁用BTS"),
        ],
        ["Rabbit Card只能用于BTS，MRT需另外买票", "建议直接买单次票，除非频繁坐BTS", "机场到市区用Airport Rail Link，不接受Rabbit Card", "曼谷堵车严重，BTS/MRT是最优出行方式"]),
    TransitCard("伦敦", "英国", "Oyster Card", "Oyster Card",
        "£7押金 (可退)", ["车站售票机", "Oyster APP", "便利店"],
        ["机场地铁站", "各主要地铁站", "Visitor Centre"],
        "退卡时返还押金£7+余额",
        "地铁/公交/电车/火车/轻轨 (London Zone 1-9)",
        [
            TransitPass("日封顶 (自动)", "约£8.50", "1天", "Zone 1-2", "Oyster自动封顶，不用特意买日票"),
            TransitPass("7日Travelcard", "£41.20", "7天", "Zone 1-2", "一周以上"),
        ],
        ["Oyster有每日消费上限，自动省钱", "非高峰期(off-peak)票价便宜很多", "公交车上车刷卡一次即可", "可以用Apple Pay/信用卡代替Oyster，同样有封顶"]),
    TransitCard("纽约", "美国", "OMNY / MetroCard", "OMNY / MetroCard",
        "MetroCard $1押金", ["OMNY: 直接刷手机/卡", "MetroCard: 售票机"],
        ["地铁站售票机", "OMNY无需购买，直接刷"],
        "MetroCard退卡不退押金",
        "地铁/公交 (MTA全线)",
        [
            TransitPass("7-Day Unlimited", "$34", "7天", "地铁+公交", "一周内多次出行最划算"),
            TransitPass("30-Day Unlimited", "$132", "30天", "地铁+公交", "长期停留"),
        ],
        ["OMNY是新版支付系统，直接刷手机或信用卡即可", "OMNY也有7天$34封顶", "旧版MetroCard逐步淘汰中", "地铁24小时运营，但深夜班次少"]),
    TransitCard("上海", "中国", "交通卡/手机NFC", "交通卡",
        "押金可退", ["手机NFC (上海交通卡APP)", "地铁站售票机"],
        ["地铁站", "便利店", "手机直接开卡"],
        "退卡退押金",
        "地铁/公交/轮渡/磁悬浮/出租车/部分停车场",
        [
            TransitPass("1日票", "¥18", "1天", "地铁", "一天密集坐地铁"),
            TransitPass("3日票", "¥45", "3天", "地铁", "3天地铁出行"),
        ],
        ["手机NFC开卡最方便，无需实体卡", "上海公交地铁换乘有1元优惠", "磁悬浮凭机票可买优惠票", "出租车也可刷交通卡"]),
]


def get_by_city(city: str) -> TransitCard | None:
    return next((c for c in DATABASE if c.city == city), None)


def available_cities() -> list[str]:
    return [c.city for c in DATABASE]
