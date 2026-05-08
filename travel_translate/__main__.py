"""Travel Translate — CLI entry point."""

from .report import generate_report
from .phrases import search


def demo():
    print(generate_report())
    print()
    print("🔍 搜索 'discount':")
    print("-" * 40)
    results = search("discount")
    for p in results:
        print(f"  {p.translations['zh']} / {p.translations['en']}")
        print(f"  🇯🇵 {p.translations['ja']}")
        print(f"  🇫🇷 {p.translations['fr']}")
        print(f"  🇹🇭 {p.translations['th']}")
        print(f"  🇰🇷 {p.translations['ko']}")
        print()


if __name__ == "__main__":
    demo()
