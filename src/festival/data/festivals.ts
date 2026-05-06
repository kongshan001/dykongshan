import { Festival } from '../models/festival';

export const FESTIVALS: Festival[] = [
  { id: 'f1', name: '樱花祭', nameLocal: '桜まつり', country: '日本', city: '京都', month: 4, dayStart: 1, durationDays: 14, description: '京都各地公园和寺庙的樱花观赏季', tips: ['提前查开花前线', '清水寺和哲学之道最热门'] },
  { id: 'f2', name: '泼水节', nameLocal: 'สงกรานต์', country: '泰国', city: '曼谷', month: 4, dayStart: 13, durationDays: 3, description: '泰国新年水战庆典', tips: ['防水袋保护电子设备', '考山路是主战场'] },
  { id: 'f3', name: '圣诞节市集', nameLocal: 'Weihnachtsmarkt', country: '德国', city: '慕尼黑', month: 12, dayStart: 25, durationDays: 21, description: '欧洲最传统的圣诞市集', tips: ['热红酒必尝', '手工艺品适合送礼'] },
  { id: 'f4', name: '排灯节', nameLocal: 'दिवाली', country: '印度', city: '新德里', month: 11, dayStart: 1, durationDays: 5, description: '印度最盛大的灯火节', tips: ['穿传统服饰参与', '注意烟花安全'] },
  { id: 'f5', name: '狂欢节', nameLocal: 'Carnaval', country: '巴西', city: '里约热内卢', month: 2, dayStart: 10, durationDays: 5, description: '全球最大型街头派对', tips: ['提前数月订酒店', '注意随身物品安全'] },
];

export function findFestivals(query: string, month?: number): Festival[] {
  const q = query.toLowerCase();
  return FESTIVALS.filter(f =>
    (f.country.toLowerCase().includes(q) || f.city.toLowerCase().includes(q)) &&
    (month === undefined || f.month === month)
  );
}
