"""Travel phrase database in 6 languages."""

from .models import Phrase, Scene, Language

# fmt: off
DATABASE: list[Phrase] = [
    # === 问候 ===
    Phrase(Scene.GREETING,
        {"zh": "你好", "en": "Hello", "ja": "こんにちは", "fr": "Bonjour", "th": "สวัสดีครับ/ค่ะ", "ko": "안녕하세요"},
        {"zh": "", "en": "heh-LOH", "ja": "kon-ni-chi-wa", "fr": "bohn-ZHOOR", "th": "sa-wat-dee krap/ka", "ko": "an-nyeong-ha-se-yo"},
        ["hello", "你好", "问候"]),
    Phrase(Scene.GREETING,
        {"zh": "谢谢", "en": "Thank you", "ja": "ありがとう", "fr": "Merci", "th": "ขอบคุณครับ/ค่ะ", "ko": "감사합니다"},
        {"zh": "", "en": "THANGK-yoo", "ja": "a-ri-ga-toh", "fr": "mer-SEE", "th": "kop-kun krap/ka", "ko": "gam-sa-ham-ni-da"},
        ["thank", "谢谢"]),
    Phrase(Scene.GREETING,
        {"zh": "对不起", "en": "Sorry / Excuse me", "ja": "すみません", "fr": "Excusez-moi", "th": "ขอโทษครับ/ค่ะ", "ko": "죄송합니다"},
        {"zh": "", "en": "skewz-MWAH", "ja": "su-mi-ma-sen", "fr": "ex-kew-zay MWAH", "th": "kor-tot krap/ka", "ko": "joe-song-ham-ni-da"},
        ["sorry", "对不起", "excuse"]),
    Phrase(Scene.GREETING,
        {"zh": "请", "en": "Please", "ja": "お願いします", "fr": "S'il vous plaît", "th": "กรุณา", "ko": "부탁합니다"},
        {"zh": "", "en": "pleez", "ja": "o-ne-gai shi-masu", "fr": "seel voo PLEH", "th": "ga-ru-na", "ko": "bu-tak-ham-ni-da"},
        ["please", "请"]),

    # === 交通 ===
    Phrase(Scene.TRANSPORT,
        {"zh": "这个多少钱？", "en": "How much is this?", "ja": "これはいくらですか？", "fr": "Combien ça coûte?", "th": "นี่เท่าไหร่ครับ/ค่ะ?", "ko": "이거 얼마예요?"},
        {"zh": "", "en": "how much iz this", "ja": "ko-re wa i-ku-ra des-ka", "fr": "kom-byen sa koot", "th": "nee tao-rai krap/ka", "ko": "ee-go ul-ma-ye-yo"},
        ["price", "多少钱", "how much"]),
    Phrase(Scene.TRANSPORT,
        {"zh": "去机场怎么走？", "en": "How to get to the airport?", "ja": "空港への行き方は？", "fr": "Comment aller à l'aéroport?", "th": "ไปสนามบินยังไงครับ/ค่ะ?", "ko": "공항 어떻게 가요?"},
        {"zh": "", "en": "how to get to the AIR-port", "ja": "kuu-kooh e no i-ki ka-ta wa", "fr": "ko-mahn ah-lay ah lai-ro-port", "th": "pai sa-nam-bin yang-ngai krap/ka", "ko": "gong-hang uh-tteo-ke ga-yo"},
        ["airport", "机场"]),
    Phrase(Scene.TRANSPORT,
        {"zh": "请带我去这个地址", "en": "Please take me to this address", "ja": "この住所までお願いします", "fr": "Emmenez-moi à cette adresse", "th": "พาไปที่อยู่นี้ได้ไหมครับ/ค่ะ", "ko": "이 주소로 가주세요"},
        {"zh": "", "en": "pleez take me to this address", "ja": "ko-no jyuu-sho ma-de o-ne-gai shi-masu", "fr": "ahm-nay MWAH ah set ah-DRES", "th": "pa pai thee-yoo nee dai mai krap/ka", "ko": "ee joo-so-ro ga-ju-se-yo"},
        ["taxi", "地址", "address"]),
    Phrase(Scene.TRANSPORT,
        {"zh": "火车/地铁站在哪？", "en": "Where is the station?", "ja": "駅はどこですか？", "fr": "Où est la gare?", "th": "สถานีอยู่ที่ไหนครับ/ค่ะ?", "ko": "역이 어디예요?"},
        {"zh": "", "en": "where iz the STAY-shun", "ja": "e-ki wa do-ko des-ka", "fr": "oo eh la gahr", "th": "sa-ta-nee yoo thee-nai krap/ka", "ko": "yeo-gi uh-di-ye-yo"},
        ["station", "车站", "train"]),

    # === 餐饮 ===
    Phrase(Scene.DINING,
        {"zh": "我想要一份菜单", "en": "May I have a menu?", "ja": "メニューをください", "fr": "Le menu, s'il vous plaît", "th": "ขอเมนูได้ไหมครับ/ค่ะ", "ko": "메뉴 주세요"},
        {"zh": "", "en": "may I have a MEN-yoo", "ja": "me-nyuu o ku-da-sai", "fr": "luh me-NOO seel voo PLEH", "th": "kor me-noo dai mai krap/ka", "ko": "me-nyu ju-se-yo"},
        ["menu", "菜单"]),
    Phrase(Scene.DINING,
        {"zh": "我不吃辣/我吃素", "en": "No spicy / I'm vegetarian", "ja": "辛くしないで/ベジタリアンです", "fr": "Pas épicé / Je suis végétarien", "th": "ไม่เผ็ด/กินมังสวิรัติ", "ko": "맵지 않게/채식이에요"},
        {"zh": "", "en": "no SPY-see / ahm vej-eh-TAIR-ee-un", "ja": "ka-ra-ku shi-nai-de / be-ji-ta-ri-an des", "fr": "pah ay-pee-SAY / zhuh swee vay-zhay-ta-ryeh", "th": "mai pet / gin mang-sa-wi-rat", "ko": "maep-ji an-ke / chae-sog-i-ye-yo"},
        ["spicy", "辣", "vegetarian", "素食"]),
    Phrase(Scene.DINING,
        {"zh": "买单", "en": "The bill, please", "ja": "お会計お願いします", "fr": "L'addition, s'il vous plaît", "th": "เช็คบิลครับ/ค่ะ", "ko": "계산서 주세요"},
        {"zh": "", "en": "the bill pleez", "ja": "o-kai-kei o-ne-gai shi-masu", "fr": "lah-dee-syohn seel voo PLEH", "th": "check bin krap/ka", "ko": "gye-san-seo ju-se-yo"},
        ["bill", "买单", "check"]),
    Phrase(Scene.DINING,
        {"zh": "好吃！", "en": "Delicious!", "ja": "おいしい！", "fr": "C'est délicieux!", "th": "อร่อย!", "ko": "맛있어요!"},
        {"zh": "", "en": "deh-LISH-us", "ja": "oi-shii", "fr": "seh day-lee-syuh", "th": "a-roy", "ko": "ma-sis-seo-yo"},
        ["delicious", "好吃"]),

    # === 购物 ===
    Phrase(Scene.SHOPPING,
        {"zh": "可以便宜点吗？", "en": "Can you give me a discount?", "ja": "もう少し安くなりますか？", "fr": "Pouvez-vous faire un prix?", "th": "ลดได้ไหมครับ/ค่ะ?", "ko": "깎아 주세요"},
        {"zh": "", "en": "can yoo give me a DIS-count", "ja": "moh su-ko-shi ya-su-ku na-ri-mas-ka", "fr": "poo-vay voo fehr uh pree", "th": "lot dai mai krap/ka", "ko": "kka-ka ju-se-yo"},
        ["discount", "便宜", "打折"]),
    Phrase(Scene.SHOPPING,
        {"zh": "我要这个", "en": "I'll take this one", "ja": "これをください", "fr": "Je prends celui-ci", "th": "เอาอันนี้ครับ/ค่ะ", "ko": "이거로 할게요"},
        {"zh": "", "en": "I'll take this wun", "ja": "ko-re o ku-da-sai", "fr": "zhuh prahn suh-lwee-see", "th": "ao an-nee krap/ka", "ko": "ee-go-ro hal-ge-yo"},
        ["buy", "买", "这个"]),

    # === 紧急 ===
    Phrase(Scene.EMERGENCY,
        {"zh": "帮帮我！", "en": "Help!", "ja": "助けて！", "fr": "Au secours!", "th": "ช่วยด้วย!", "ko": "도와주세요!"},
        {"zh": "", "en": "HELP", "ja": "ta-su-ke-te", "fr": "oh suh-KOOR", "th": "chuay duay", "ko": "do-wa-ju-se-yo"},
        ["help", "救命", "帮"]),
    Phrase(Scene.EMERGENCY,
        {"zh": "我需要看医生", "en": "I need a doctor", "ja": "医者を呼んでください", "fr": "J'ai besoin d'un médecin", "th": "ต้องการหมอครับ/ค่ะ", "ko": "의사가 필요해요"},
        {"zh": "", "en": "I need a DOK-ter", "ja": "i-sha o yon-de ku-da-sai", "fr": "zhay buh-zwahn duhn med-san", "th": "tong-gan mor krap/ka", "ko": "ui-sa-ga pil-yo-hae-yo"},
        ["doctor", "医生", "hospital"]),
    Phrase(Scene.EMERGENCY,
        {"zh": "我的护照丢了", "en": "I lost my passport", "ja": "パスポートをなくしました", "fr": "J'ai perdu mon passeport", "th": "หนังสือเดินทางหายครับ/ค่ะ", "ko": "여권을 잃어버렸어요"},
        {"zh": "", "en": "I lost my PAS-port", "ja": "pa-su-poh-to o na-ku-shi-ma-shi-ta", "fr": "zhay pehr-doo mohn pahs-por", "th": "nang-seuh deurn-thang hai krap/ka", "ko": "yeo-gwon-eul il-eo-beo-ryeoss-eo-yo"},
        ["passport", "护照", "lost"]),

    # === 住宿 ===
    Phrase(Scene.HOTEL,
        {"zh": "我有预订", "en": "I have a reservation", "ja": "予約があります", "fr": "J'ai une réservation", "th": "มีการจองไว้ครับ/ค่ะ", "ko": "예약이 있습니다"},
        {"zh": "", "en": "I have a reh-zer-VAY-shun", "ja": "yo-ya-ku ga a-ri-mas", "fr": "zhay oon ray-zehr-vah-syohn", "th": "mee kan-jong wai krap/ka", "ko": "ye-ya-gi it-seum-ni-da"},
        ["reservation", "预订", "booking"]),
    Phrase(Scene.HOTEL,
        {"zh": "有WiFi吗？", "en": "Is there WiFi?", "ja": "WiFiはありますか？", "fr": "Y a-t-il le WiFi?", "th": "มีWiFiไหมครับ/ค่ะ?", "ko": "와이파이 있어요?"},
        {"zh": "", "en": "iz there WYE-fye", "ja": "wye-fye wa a-ri-mas-ka", "fr": "ee ah teel luh wye-fee", "th": "mee wye-fye mai krap/ka", "ko": "wa-i-pa-i iss-eo-yo"},
        ["wifi", "网络"]),
    Phrase(Scene.HOTEL,
        {"zh": "退房时间是几点？", "en": "What time is checkout?", "ja": "チェックアウトは何時ですか？", "fr": "À quelle heure est le départ?", "th": "เช็คเอาท์กี่โมงครับ/ค่ะ?", "ko": "체크아웃 몇 시예요?"},
        {"zh": "", "en": "what time iz CHEK-out", "ja": "che-ku-au-to wa nan-ji des-ka", "fr": "ah kehl uhr eh luh day-pahr", "th": "check-out kee mong krap/ka", "ko": "che-keu-au-tot myeon si-ye-yo"},
        ["checkout", "退房"]),
]
# fmt: on


def get_by_scene(scene: Scene) -> list[Phrase]:
    return [p for p in DATABASE if p.scene == scene]


def search(keyword: str) -> list[Phrase]:
    kw = keyword.lower()
    return [p for p in DATABASE if any(kw in k.lower() for k in p.keywords) or any(kw in t.lower() for t in p.translations.values())]
