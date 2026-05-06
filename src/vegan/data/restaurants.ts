export type VegType = 'vegan' | 'vegetarian' | 'veg-friendly';

export interface VegRestaurant {
  id: string; name: string; city: string; country: string; type: VegType;
  cuisine: string; rating: number; priceRange: string; mustTry: string;
}

export const VEG_RESTAURANTS: VegRestaurant[] = [
  { id: 'v1', name: 'T's Tantan', city: '东京', country: '日本', type: 'vegan', cuisine: '日式拉面', rating: 4.7, priceRange: '¥', mustTry: '味噌纯素拉面' },
  { id: 'v2', name: 'Le Potager du Marais', city: '巴黎', country: '法国', type: 'vegetarian', cuisine: '法式素食', rating: 4.5, priceRange: '¥¥', mustTry: '蘑菇千层面' },
  { id: 'v3', name: 'Tian', city: '维也纳', country: '奥地利', type: 'vegan', cuisine: '精致餐饮', rating: 4.8, priceRange: '¥¥¥', mustTry: '米其林级纯素套餐' },
  { id: 'v4', name: ' veggie grill', city: '洛杉矶', country: '美国', type: 'vegan', cuisine: '美式快餐', rating: 4.3, priceRange: '¥', mustTry: '纯素汉堡' },
  { id: 'v5', name: 'Saravana Bhavan', city: '新德里', country: '印度', type: 'vegetarian', cuisine: '南印度素食', rating: 4.6, priceRange: '¥', mustTry: 'Masala Dosa' },
];
