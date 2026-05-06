import { CoffeeShop } from '../models/shop';

export const COFFEE_SHOPS: CoffeeShop[] = [
  { id: 'c1', name: 'Blue Bottle 品川店', city: '东京', country: '日本', style: 'specialty', description: '日本精品咖啡先驱', recommendedDrink: '新品肯尼亚手冲', priceRange: '¥¥', rating: 4.6, address: '东京都港区' },
  { id: 'c2', name: 'Caffè Sant\'Eustachio', city: '罗马', country: '意大利', style: 'traditional', description: '始于 1938 年的罗马传奇咖啡馆', recommendedDrink: 'Gran Caffè', priceRange: '¥', rating: 4.7, address: 'Piazza Sant\'Eustachio, Roma' },
  { id: 'c3', name: 'The Coffee Academïcs', city: '香港', country: '中国', style: 'roaster', description: '香港精品咖啡烘焙品牌', recommendedDrink: 'House Blend', priceRange: '¥¥', rating: 4.4, address: '中环威灵顿街' },
  { id: 'c4', name: 'Cafe de Nadie', city: '墨西哥城', country: '墨西哥', style: 'specialty', description: '墨西哥精品咖啡运动先锋', recommendedDrink: 'Oaxaca 滤泡', priceRange: '¥', rating: 4.8, address: 'Roma Norte, CDMX' },
  { id: 'c5', name: 'Tim Wendelboe', city: '奥斯陆', country: '挪威', style: 'roaster', description: '北欧浅烘咖啡标杆', recommendedDrink: '哥伦比亚手冲', priceRange: '¥¥¥', rating: 4.9, address: 'Grünerløkka, Oslo' },
];

export function findShopsByCity(city: string): CoffeeShop[] {
  const q = city.toLowerCase();
  return COFFEE_SHOPS.filter(s => s.city.toLowerCase().includes(q) || s.country.toLowerCase().includes(q));
}
