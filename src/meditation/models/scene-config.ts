/**
 * 旅行冥想场景配置数据模型
 */
export interface MeditationScene {
  id: string;
  name: string;
  nameEn: string;
  description: string;
  icon: string;
  backgroundSound: string;       // 背景音效文件路径
  guidedVoice: string;           // 引导语音文件路径
  defaultDuration: number;       // 默认时长（秒）
  color: string;                 // 主题色
}

export interface DurationOption {
  label: string;
  seconds: number;
}

export const DURATION_OPTIONS: DurationOption[] = [
  { label: '5 分钟', seconds: 300 },
  { label: '10 分钟', seconds: 600 },
  { label: '15 分钟', seconds: 900 },
  { label: '20 分钟', seconds: 1200 },
];

export const TRAVEL_SCENES: MeditationScene[] = [
  {
    id: 'airplane',
    name: '机上放松',
    nameEn: 'In-Flight Relaxation',
    description: '在飞行中缓解身体紧张，通过呼吸和身体扫描放松全身',
    icon: '✈️',
    backgroundSound: 'airplane_cabin.mp3',
    guidedVoice: 'airplane_guide.mp3',
    defaultDuration: 600,
    color: '#4A90D9',
  },
  {
    id: 'hotel',
    name: '酒店安眠',
    nameEn: 'Hotel Sleep Aid',
    description: '在陌生酒店环境中快速入睡，配合白噪音营造舒适氛围',
    icon: '🏨',
    backgroundSound: 'rain_window.mp3',
    guidedVoice: 'hotel_guide.mp3',
    defaultDuration: 900,
    color: '#7B68EE',
  },
  {
    id: 'transit',
    name: '旅途冥想',
    nameEn: 'Transit Meditation',
    description: '在火车或大巴上进行的短时间正念冥想，缓解旅途焦虑',
    icon: '🚄',
    backgroundSound: 'train_ambient.mp3',
    guidedVoice: 'transit_guide.mp3',
    defaultDuration: 300,
    color: '#2ECC71',
  },
  {
    id: 'nature',
    name: '自然连接',
    nameEn: 'Nature Connection',
    description: '在自然景点进行的深度冥想，感受周围环境的能量',
    icon: '🌿',
    backgroundSound: 'forest_birds.mp3',
    guidedVoice: 'nature_guide.mp3',
    defaultDuration: 900,
    color: '#27AE60',
  },
  {
    id: 'jetlag',
    name: '时差调整',
    nameEn: 'Jet Lag Reset',
    description: '通过特定呼吸节奏帮助身体快速适应新时区',
    icon: '🌍',
    backgroundSound: 'ocean_waves.mp3',
    guidedVoice: 'jetlag_guide.mp3',
    defaultDuration: 1200,
    color: '#E67E22',
  },
];
