export interface PhotoSpot {
  id: string; name: string; city: string; country: string;
  lat: number; lng: number;
  bestTime: string; subject: string; tips: string; gear: string;
}

export const PHOTO_SPOTS: PhotoSpot[] = [
  { id: 'p1', name: '清水寺观景台', city: '京都', country: '日本', lat: 34.9949, lng: 135.785, bestTime: '日出/日落', subject: '京都城市全景', tips: '秋季红叶季最佳', gear: '广角镜头' },
  { id: 'p2', name: '蒙马特高地', city: '巴黎', country: '法国', lat: 48.8867, lng: 2.3431, bestTime: '黄金时段', subject: '巴黎城市天际线', tips: '圣心大教堂台阶', gear: '35mm定焦' },
  { id: 'p3', name: '布鲁克林大桥', city: '纽约', country: '美国', lat: 40.7061, lng: -73.9969, bestTime: '黎明', subject: '曼哈顿天际线', tips: '凌晨人少光线好', gear: '三脚架+长曝光' },
  { id: 'p4', name: '悉尼歌剧院观景台', city: '悉尼', country: '澳大利亚', lat: -33.8568, lng: 151.2153, bestTime: '蓝色时段', subject: '歌剧院+海港大桥', tips: 'Mrs Macquaries Chair 机位', gear: '16-35mm广角' },
  { id: 'p5', name: '哈瓦那老城', city: '哈瓦那', country: '古巴', lat: 23.1136, lng: -82.3666, bestTime: '全天', subject: '复古建筑+老爷车', tips: '街头摄影天堂', gear: '50mm定焦' },
];
