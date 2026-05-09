"""SIM/WiFi plan database for popular destinations."""

from .models import SimType, SimOption, CountryPlans

DATABASE: list[CountryPlans] = [
    CountryPlans("日本", [
        SimOption("Airalo eSIM", SimType.ESIM, 38, 1, 7, "4G", "日本全境",
            ["无需换卡，即买即用", "支持热点分享", "价格便宜"],
            ["需要eSIM兼容手机", "无法收国内短信"]),
        SimOption("漫游超人 eSIM", SimType.ESIM, 68, 3, 7, "4G/5G", "日本全境",
            ["流量充足", "5G网络", "中文客服"],
            ["价格中等"]),
        SimOption("Sakura Mobile", SimType.PHYSICAL, 85, 5, 8, "4G", "日本全境",
            ["流量大", "可日本国内通话"],
            ["需等邮寄", "需要换卡"]),
        SimOption("环球漫游 WiFi蛋", SimType.WIFI_EGG, 40, 999, 1, "4G", "日本全境",
            ["不限流量", "可多人连接", "无需换卡"],
            ["需取还设备", "每天计费", "需充电"]),
        SimOption("移动/联通漫游", SimType.ROAMING, 30, 0, 1, "4G", "日本全境",
            ["无需操作，开通即用", "保留原号码"],
            ["流量极贵(~¥30/天)", "速度可能受限"]),
    ], ["eSIM是最方便的选择，iPhone XS以上均支持", "Airalo是性价比最高的eSIM方案", "多人出行建议租WiFi蛋共享", "建议在国内提前购买，落地即用"]),

    CountryPlans("泰国", [
        SimOption("Airalo eSIM", SimType.ESIM, 28, 1, 7, "4G", "泰国全境",
            ["便宜", "即买即用"],
            ["流量较少"]),
        SimOption("AIS/Dtac/TrueMove", SimType.PHYSICAL, 35, 8, 8, "4G/5G", "泰国全境",
            ["流量超大", "本地通话", "机场即买"],
            ["需换卡", "激活需护照"]),
        SimOption("环球漫游 WiFi蛋", SimType.WIFI_EGG, 30, 999, 1, "4G", "主要城市",
            ["不限流量", "多人共享"],
            ["仅覆盖主要城市"]),
        SimOption("移动/联通漫游", SimType.ROAMING, 25, 0, 1, "4G", "泰国全境",
            ["方便"],
            ["流量贵"]),
    ], ["泰国机场7-11便利店可买当地SIM卡，非常方便", "AIS信号覆盖最好，TrueMove 5G速度快", "短途旅行推荐eSIM，长途推荐当地实体卡"]),

    CountryPlans("法国", [
        SimOption("Airalo eSIM", SimType.ESIM, 45, 3, 30, "4G", "欧洲多国",
            ["覆盖欧洲多国", "有效期长"],
            ["需要eSIM手机"]),
        SimOption("Orange Holiday", SimType.PHYSICAL, 120, 20, 14, "4G", "欧洲30国",
            ["超大流量", "欧洲通用", "含通话短信"],
            ["价格较高", "需等邮寄"]),
        SimOption("WiFi蛋", SimType.WIFI_EGG, 45, 999, 1, "4G", "欧洲多国",
            ["不限流量", "欧洲通用"],
            ["每天计费", "需取还"]),
        SimOption("运营商漫游", SimType.ROAMING, 30, 0, 1, "4G", "法国",
            ["方便"],
            ["仅法国，其他国家另算"]),
    ], ["多国旅行推荐Orange Holiday，一卡走遍欧洲", "eSIM方案覆盖多国但流量有限", "法国地铁WiFi覆盖较好，可减少流量需求"]),

    CountryPlans("美国", [
        SimOption("Airalo eSIM", SimType.ESIM, 55, 5, 30, "5G", "美国全境",
            ["流量充足", "5G网络"],
            ["需要eSIM手机"]),
        SimOption("T-Mobile预付卡", SimType.PHYSICAL, 50, 999, 30, "5G", "美国全境",
            ["不限流量(前5GB高速)", "美国本地通话"],
            ["需换卡", "激活较麻烦"]),
        SimOption("WiFi蛋", SimType.WIFI_EGG, 50, 999, 1, "4G", "美国主要城市",
            ["不限流量"],
            ["每天计费"]),
        SimOption("运营商漫游", SimType.ROAMING, 30, 0, 1, "4G/5G", "美国",
            ["方便", "保留号码"],
            ["流量贵", "美国面积大，覆盖不均"]),
    ], ["美国推荐T-Mobile，信号覆盖好", "短途eSIM，长期实体卡", "美国很多公共场所WiFi覆盖好"]),

    CountryPlans("韩国", [
        SimOption("Airalo eSIM", SimType.ESIM, 32, 3, 30, "5G", "韩国全境",
            ["5G网络", "覆盖好"],
            ["需要eSIM手机"]),
        SimOption("KT/SKT预付卡", SimType.PHYSICAL, 40, 10, 5, "5G", "韩国全境",
            ["流量大", "5G速度", "机场取卡"],
            ["需换卡"]),
        SimOption("WiFi蛋", SimType.WIFI_EGG, 35, 999, 1, "5G", "韩国全境",
            ["不限流量", "韩国WiFi覆盖极好"],
            ["每天计费"]),
        SimOption("运营商漫游", SimType.ROAMING, 25, 0, 1, "4G", "韩国",
            ["方便"],
            ["流量贵"]),
    ], ["韩国5G覆盖全球最好，推荐用5G方案", "韩国公共WiFi覆盖率极高，流量需求可能不大"]),
]


def get_by_country(country: str) -> CountryPlans | None:
    return next((p for p in DATABASE if p.country == country), None)

def available_countries() -> list[str]:
    return [p.country for p in DATABASE]
