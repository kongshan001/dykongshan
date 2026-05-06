export type Climate = 'tropical' | 'temperate' | 'cold' | 'arid';
export type Activity = 'beach' | 'hiking' | 'business' | 'cultural' | 'skiing';
export type Category = 'clothing' | 'electronics' | 'toiletries' | 'documents' | 'medicine' | 'misc';

export interface PackItem {
  id: string;
  name: string;
  category: Category;
  climates: Climate[];
  activities: Activity[];
  quantityPerDay: number;
  essential: boolean;
}

export interface Checklist {
  destination: string;
  days: number;
  climate: Climate;
  activities: Activity[];
  items: { item: PackItem; quantity: number; packed: boolean }[];
}
