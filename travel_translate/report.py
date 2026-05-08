"""Report generation for travel translator."""

from .models import Scene, Language
from .phrases import DATABASE


LANGS = [Language.ZH, Language.EN, Language.JA, Language.FR, Language.TH, Language.KO]
LANG_CODES = ["zh", "en", "ja", "fr", "th", "ko"]


def generate_report() -> str:
    lines = []
    lines.append("=" * 70)
    lines.append("       🗣️ 旅行翻译助手 — 常用短语")
    lines.append("=" * 70)

    current_scene = None
    for phrase in DATABASE:
        if phrase.scene != current_scene:
            current_scene = phrase.scene
            lines.append("")
            lines.append(f"{current_scene.value}")
            lines.append("-" * 55)

        # Chinese + English as primary
        zh = phrase.translations.get("zh", "")
        en = phrase.translations.get("en", "")
        lines.append(f"  🇨🇳 {zh}  /  🇺🇸 {en}")

        # Other languages with pronunciation
        others = [("ja", "🇯🇵"), ("fr", "🇫🇷"), ("th", "🇹🇭"), ("ko", "🇰🇷")]
        for code, flag in others:
            text = phrase.translations.get(code, "")
            pron = phrase.pronunciation.get(code, "")
            if pron:
                lines.append(f"  {flag} {text}  [{pron}]")
            else:
                lines.append(f"  {flag} {text}")
        lines.append("")

    lines.append("=" * 70)
    lines.append(f"  共 {len(DATABASE)} 条短语 | {len(set(p.scene for p in DATABASE))} 个场景 | 6 种语言")
    lines.append("=" * 70)
    return "\n".join(lines)
