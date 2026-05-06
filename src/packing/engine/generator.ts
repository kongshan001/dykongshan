import { PackItem, Climate, Activity, Checklist } from '../models/checklist';
import { PACK_ITEMS } from '../data/items';

export function generateChecklist(
  destination: string,
  days: number,
  climate: Climate,
  activities: Activity[]
): Checklist {
  const items = PACK_ITEMS
    .filter(item => item.climates.includes(climate) || item.essential)
    .filter(item => item.activities.some(a => activities.includes(a)) || item.essential)
    .map(item => ({
      item,
      quantity: item.quantityPerDay > 0 ? Math.ceil(item.quantityPerDay * days) : 1,
      packed: false,
    }));

  return { destination, days, climate, activities, items };
}
