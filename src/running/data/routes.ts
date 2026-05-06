/**
 * 全球旅行城市经典跑步路线数据集
 */
import { RunningRoute } from '../models/route';

export const RUNNING_ROUTES: RunningRoute[] = [
  {
    id: 'paris-seine',
    name: '塞纳河畔晨跑',
    nameLocal: 'Course along the Seine',
    city: '巴黎',
    country: '法国',
    distanceKm: 8.5,
    estimatedMinutes: 45,
    difficulty: 'beginner',
    surface: 'paved',
    scenery: ['waterfront', 'historic'],
    elevationGainM: 15,
    description: '沿塞纳河两岸的经典跑步路线，途经埃菲尔铁塔、卢浮宫、巴黎圣母院',
    highlights: ['埃菲尔铁塔', '亚历山大三世桥', '卢浮宫', '巴黎圣母院'],
    bestTime: '清晨 6:00-8:00',
    safetyNotes: ['注意河边步道不平整处', '夜间不建议单独跑步'],
    gpxUrl: 'gpx/paris-seine.gpx',
    rating: 4.8,
  },
  {
    id: 'tokyo-imperial',
    name: '皇居环绕跑',
    nameLocal: '皇居ランニング',
    city: '东京',
    country: '日本',
    distanceKm: 5.0,
    estimatedMinutes: 28,
    difficulty: 'beginner',
    surface: 'paved',
    scenery: ['urban', 'historic'],
    elevationGainM: 5,
    description: '环绕东京皇居的 5 公里环路，是东京最热门的跑步路线之一',
    highlights: ['皇居外苑', '二重桥', '千鸟之渊', '楠木正成像'],
    bestTime: '清晨 5:30-7:30',
    safetyNotes: ['非常安全，有专用跑步道', '周末人多建议工作日前往'],
    gpxUrl: 'gpx/tokyo-imperial.gpx',
    rating: 4.9,
  },
  {
    id: 'nyc-central',
    name: '中央公园环路',
    nameLocal: 'Central Park Loop',
    city: '纽约',
    country: '美国',
    distanceKm: 10.0,
    estimatedMinutes: 55,
    difficulty: 'intermediate',
    surface: 'paved',
    scenery: ['park', 'urban'],
    elevationGainM: 75,
    description: '环绕中央公园的经典 10K 路线，有起伏地形和美丽景观',
    highlights: ['杰奎琳水库', '眺望台城堡', '贝塞斯达喷泉', '大草坪'],
    bestTime: '清晨 6:00-8:00（避开周末人群）',
    safetyNotes: ['公园内有多处饮水站', '冬季注意路面结冰'],
    gpxUrl: 'gpx/nyc-central.gpx',
    rating: 4.7,
  },
  {
    id: 'sydney-harbour',
    name: '悉尼港海滨跑',
    nameLocal: 'Sydney Harbour Run',
    city: '悉尼',
    country: '澳大利亚',
    distanceKm: 7.2,
    estimatedMinutes: 40,
    difficulty: 'intermediate',
    surface: 'mixed',
    scenery: ['waterfront', 'urban'],
    elevationGainM: 85,
    description: '从环形码头到邦迪海滩的标志性海滨路线',
    highlights: ['悉尼歌剧院', '海港大桥', '屈臣氏湾', '邦迪海滩'],
    bestTime: '清晨 6:00-8:00',
    safetyNotes: ['部分路段有台阶', '注意潮汐变化'],
    gpxUrl: 'gpx/sydney-harbour.gpx',
    rating: 4.6,
  },
  {
    id: 'bangkok-lumpini',
    name: '伦披尼公园跑',
    nameLocal: 'วิ่งสวนลุมพินี',
    city: '曼谷',
    country: '泰国',
    distanceKm: 4.8,
    estimatedMinutes: 30,
    difficulty: 'beginner',
    surface: 'paved',
    scenery: ['park'],
    elevationGainM: 2,
    description: '曼谷市中心绿洲，平坦的环形跑道，适合晨跑',
    highlights: ['伦披尼公园湖', '露天健身房', '水蜥蜴观赏'],
    bestTime: '清晨 5:30-7:00（避开高温）',
    safetyNotes: ['高温高湿，注意补水', '公园内偶有水蜥蜴，保持距离'],
    gpxUrl: 'gpx/bangkok-lumpini.gpx',
    rating: 4.3,
  },
];

export function findRoutesByCity(query: string): RunningRoute[] {
  const q = query.toLowerCase();
  return RUNNING_ROUTES.filter(
    (r) =>
      r.city.toLowerCase().includes(q) ||
      r.country.toLowerCase().includes(q) ||
      r.name.toLowerCase().includes(q)
  );
}
