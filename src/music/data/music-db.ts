/**
 * 全球旅行目的地音乐数据库
 */

export interface MusicStyle {
  id: string;
  name: string;
  nameLocal: string;
  origin: string;
  description: string;
  keyArtists: string[];
  sampleTrack: string;
  color: string;
}

export interface DestinationMusic {
  destination: string;
  country: string;
  styles: MusicStyle[];
}

export const DESTINATION_MUSIC_DB: DestinationMusic[] = [
  {
    destination: '东京',
    country: '日本',
    styles: [
      { id: 'jpop', name: 'J-Pop', nameLocal: 'ジェイポップ', origin: '日本', description: '日本流行音乐，融合西方流行与日本传统元素', keyArtists: ['YOASOBI', '米津玄師', 'Ado'], sampleTrack: 'sample_jpop.mp3', color: '#FF6B9D' },
      { id: 'shamisen', name: '三味線', nameLocal: ' shamisen', origin: '日本', description: '日本传统弦乐器，音色独特富有穿透力', keyArtists: ['吉田兄弟', '上妻宏光'], sampleTrack: 'sample_shamisen.mp3', color: '#C0392B' },
    ],
  },
  {
    destination: '里约热内卢',
    country: '巴西',
    styles: [
      { id: 'bossa-nova', name: 'Bossa Nova', nameLocal: 'Bossa Nova', origin: '巴西', description: '融合桑巴节奏与爵士和声的巴西音乐风格', keyArtists: ['João Gilberto', 'Antonio Carlos Jobim', 'Elis Regina'], sampleTrack: 'sample_bossa.mp3', color: '#F39C12' },
      { id: 'samba', name: 'Samba', nameLocal: 'Samba', origin: '巴西', description: '巴西最具代表性的音乐和舞蹈形式', keyArtists: ['Cartola', 'Beth Carvalho'], sampleTrack: 'sample_samba.mp3', color: '#E74C3C' },
    ],
  },
  {
    destination: '伊斯坦布尔',
    country: '土耳其',
    styles: [
      { id: 'turkish-jazz', name: 'Turkish Jazz', nameLocal: 'Türk Cazı', origin: '土耳其', description: '融合土耳其传统音乐与爵士即兴', keyArtists: ['Mercan Dede', 'Ahmet Ertegün'], sampleTrack: 'sample_turkish_jazz.mp3', color: '#1ABC9C' },
    ],
  },
  {
    destination: '新奥尔良',
    country: '美国',
    styles: [
      { id: 'jazz', name: 'Jazz', nameLocal: 'Jazz', origin: '美国', description: '发源于新奥尔良的即兴音乐形式', keyArtists: ['Louis Armstrong', 'Wynton Marsalis', 'Terence Blanchard'], sampleTrack: 'sample_jazz.mp3', color: '#9B59B6' },
      { id: 'zydeco', name: 'Zydeco', nameLocal: 'Zydeco', origin: '美国路易斯安那', description: '路易斯安那法语区的手风琴驱动舞曲', keyArtists: ['Clifton Chenier', 'Buckwheat Zydeco'], sampleTrack: 'sample_zydeco.mp3', color: '#E67E22' },
    ],
  },
  {
    destination: '哈瓦那',
    country: '古巴',
    styles: [
      { id: 'son', name: 'Son Cubano', nameLocal: 'Son Cubano', origin: '古巴', description: '古巴传统音乐，是萨尔萨音乐的前身', keyArtists: ['Compay Segundo', 'Ibrahim Ferrer', 'Beny Moré'], sampleTrack: 'sample_son.mp3', color: '#2ECC71' },
    ],
  },
];

export function findMusicByDestination(query: string): DestinationMusic[] {
  const q = query.toLowerCase();
  return DESTINATION_MUSIC_DB.filter(
    (d) =>
      d.destination.toLowerCase().includes(q) ||
      d.country.toLowerCase().includes(q)
  );
}
