import { PackItem } from '../models/checklist';

export const PACK_ITEMS: PackItem[] = [
  { id: 'passport', name: '护照', category: 'documents', climates: ['tropical','temperate','cold','arid'], activities: ['beach','hiking','business','cultural','skiing'], quantityPerDay: 0, essential: true },
  { id: 'underwear', name: '内衣', category: 'clothing', climates: ['tropical','temperate','cold','arid'], activities: ['beach','hiking','business','cultural','skiing'], quantityPerDay: 1, essential: true },
  { id: 'tshirt', name: 'T恤', category: 'clothing', climates: ['tropical','temperate','arid'], activities: ['beach','hiking','cultural'], quantityPerDay: 0.5, essential: true },
  { id: 'jacket', name: '外套', category: 'clothing', climates: ['cold','temperate'], activities: ['hiking','skiing','business'], quantityPerDay: 0, essential: true },
  { id: 'charger', name: '充电器', category: 'electronics', climates: ['tropical','temperate','cold','arid'], activities: ['beach','hiking','business','cultural','skiing'], quantityPerDay: 0, essential: true },
  { id: 'sunscreen', name: '防晒霜', category: 'toiletries', climates: ['tropical','arid'], activities: ['beach','hiking'], quantityPerDay: 0, essential: false },
  { id: 'medicine-basic', name: '常用药', category: 'medicine', climates: ['tropical','temperate','cold','arid'], activities: ['beach','hiking','business','cultural','skiing'], quantityPerDay: 0, essential: true },
  { id: 'swimsuit', name: '泳衣', category: 'clothing', climates: ['tropical','temperate'], activities: ['beach'], quantityPerDay: 0, essential: false },
  { id: 'adapter', name: '转换插头', category: 'electronics', climates: ['tropical','temperate','cold','arid'], activities: ['beach','hiking','business','cultural','skiing'], quantityPerDay: 0, essential: true },
];
