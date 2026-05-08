"""Travel Expense — CLI entry point with demo data."""

from .models import TripBudget, Expense, ExpenseCategory


def demo():
    """Demo with simulated Tokyo trip expenses."""
    trip = TripBudget(
        trip_name="东京5日游",
        base_currency="CNY",
        total_budget=10000,
        start_date="2026-05-01",
        end_date="2026-05-05",
    )

    # Simulate expenses (converted to CNY)
    expenses = [
        (1, 2500, "CNY", ExpenseCategory.HOTEL, "酒店5晚", "2026-05-01", 2500),
        (2, 5000, "JPY", ExpenseCategory.FOOD, "筑地市场早餐", "2026-05-01", 218),
        (3, 1500, "JPY", ExpenseCategory.TRANSPORT, "SUICA充值", "2026-05-01", 65),
        (4, 3000, "JPY", ExpenseCategory.FOOD, "拉面午餐", "2026-05-01", 130),
        (5, 20000, "JPY", ExpenseCategory.TICKET, "迪士尼门票", "2026-05-02", 870),
        (6, 3000, "JPY", ExpenseCategory.FOOD, "迪士尼午餐", "2026-05-02", 130),
        (7, 8000, "JPY", ExpenseCategory.FOOD, "居酒屋晚餐", "2026-05-02", 348),
        (8, 30000, "JPY", ExpenseCategory.SHOPPING, "秋叶原购物", "2026-05-03", 1304),
        (9, 2000, "JPY", ExpenseCategory.FOOD, "便利店早餐", "2026-05-03", 87),
        (10, 5000, "JPY", ExpenseCategory.TICKET, "浅草寺+天空树", "2026-05-03", 217),
        (11, 1500, "JPY", ExpenseCategory.FOOD, "烤肉晚餐", "2026-05-04", 65),
        (12, 30000, "JPY", ExpenseCategory.SHOPPING, "银座购物", "2026-05-04", 1304),
        (13, 1000, "JPY", ExpenseCategory.TRANSPORT, "地铁", "2026-05-05", 43),
        (14, 2000, "JPY", ExpenseCategory.FOOD, "寿司午餐", "2026-05-05", 87),
    ]

    for eid, amt, curr, cat, note, date, converted in expenses:
        trip.expenses.append(Expense(eid, amt, curr, cat, note, date, converted))

    from .report import generate_report
    print(generate_report(trip))

    # Save
    from .storage import save
    save(trip)
    print("  (数据已保存到 /tmp/travel_expense_data.json)")


if __name__ == "__main__":
    demo()
