export interface Weather { tempC: number; humidity: number; windKmh: number; rain: boolean; uv: number }
export interface OutfitAdvice { layers: string[]; accessories: string[]; warning: string | null }

export function recommendOutfit(w: Weather): OutfitAdvice {
  const layers: string[] = [];
  const accessories: string[] = [];
  let warning: string | null = null;

  if (w.tempC >= 30) { layers.push('轻薄透气上衣', '短裤/裙子'); accessories.push('遮阳帽', '墨镜'); }
  else if (w.tempC >= 20) { layers.push('短袖/薄长袖', '长裤'); }
  else if (w.tempC >= 10) { layers.push('长袖内搭', '薄外套/卫衣', '长裤'); }
  else if (w.tempC >= 0) { layers.push('保暖内衣', '毛衣/抓绒', '羽绒服/厚外套', '保暖裤'); accessories.push('围巾', '手套'); }
  else { layers.push('保暖内衣', '毛衣', '厚羽绒服', '防风裤'); accessories.push('围巾', '手套', '毛线帽'); warning = '极寒天气，注意保暖'; }

  if (w.rain) { accessories.push('雨伞', '防水鞋'); warning = warning ?? '雨天路滑注意安全'; }
  if (w.uv >= 8) { accessories.push('防晒霜 SPF50+'); warning = warning ?? '紫外线极强，注意防晒'; }
  if (w.windKmh >= 40) { warning = warning ?? '大风天气，避免户外活动'; }

  return { layers, accessories, warning };
}
