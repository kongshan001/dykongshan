import { DestinationBooklist } from '../models/book';

export const DESTINATION_BOOKLISTS: DestinationBooklist[] = [
  {
    destination: '京都',
    books: [
      { id: 'b1', title: '古都', author: '川端康成', category: 'literature', description: '以京都为背景的诺贝尔文学奖作品', relevanceReason: '感受京都的四季之美', pages: 280, priority: 1 },
      { id: 'b2', title: '阴翳礼赞', author: '谷崎润一郎', category: 'culture', description: '日本美学经典论著', relevanceReason: '理解日式审美的核心', pages: 192, priority: 1 },
      { id: 'b3', title: '京都一年', author: '林文月', category: 'travel', description: '台湾作家在京都的生活记录', relevanceReason: '实用生活视角', pages: 320, priority: 2 },
    ],
  },
  {
    destination: '罗马',
    books: [
      { id: 'b4', title: '罗马人的故事', author: '盐野七生', category: 'history', description: '全面讲述罗马帝国兴衰', relevanceReason: '理解罗马历史背景', pages: 4500, priority: 1 },
      { id: 'b5', title: '罗马', author: '费德里科·费里尼', category: 'culture', description: '大师镜头下的罗马', relevanceReason: '电影视角感受罗马', pages: 200, priority: 2 },
    ],
  },
];
