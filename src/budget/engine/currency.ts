const FALLBACK_RATES: Record<string, number> = {
  USD: 1, EUR: 0.92, GBP: 0.79, JPY: 151.5, CNY: 7.24,
  THB: 35.8, KRW: 1330, AUD: 1.53, CAD: 1.37, SGD: 1.34,
};

export async function getRate(from: string, to: string): Promise<number> {
  if (from === to) return 1;
  const f = FALLBACK_RATES[from] ?? 1;
  const t = FALLBACK_RATES[to] ?? 1;
  return t / f;
}
