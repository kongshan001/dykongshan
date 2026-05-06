export type ExpenseCategory = 'accommodation' | 'food' | 'transport' | 'shopping' | 'activity' | 'other';

export interface Expense {
  id: string;
  amount: number;
  currency: string;
  category: ExpenseCategory;
  description: string;
  date: string;
}

export interface Budget {
  total: number;
  baseCurrency: string;
  spent: number;
  expenses: Expense[];
}

export function addExpense(budget: Budget, expense: Expense, rate: number): Budget {
  const converted = expense.amount * rate;
  return { ...budget, spent: budget.spent + converted, expenses: [...budget.expenses, expense] };
}

export function remainingBudget(budget: Budget): number {
  return budget.total - budget.spent;
}
