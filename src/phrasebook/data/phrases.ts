export type PhraseCategory = 'greeting' | 'dining' | 'transport' | 'emergency' | 'shopping';

export interface Phrase {
  chinese: string; local: string; pronunciation: string; category: PhraseCategory;
}

export interface LanguagePhrasebook {
  language: string; code: string; phrases: Phrase[];
}

export const PHRASEBOOKS: LanguagePhrasebook[] = [
  { language: '日语', code: 'ja', phrases: [
    { chinese: '你好', local: 'こんにちは', pronunciation: 'Konnichiwa', category: 'greeting' },
    { chinese: '谢谢', local: 'ありがとう', pronunciation: 'Arigatou', category: 'greeting' },
    { chinese: '多少钱？', local: 'いくらですか？', pronunciation: 'Ikura desu ka?', category: 'shopping' },
    { chinese: '请给我菜单', local: 'メニューをください', pronunciation: 'Menyuu wo kudasai', category: 'dining' },
    { chinese: '去车站怎么走？', local: '駅はどこですか？', pronunciation: 'Eki wa doko desu ka?', category: 'transport' },
    { chinese: '请叫救护车', local: '救急車を呼んでください', pronunciation: 'Kyuukyuusha wo yonde kudasai', category: 'emergency' },
  ]},
  { language: '法语', code: 'fr', phrases: [
    { chinese: '你好', local: 'Bonjour', pronunciation: 'Boh-zhoor', category: 'greeting' },
    { chinese: '谢谢', local: 'Merci', pronunciation: 'Mair-see', category: 'greeting' },
    { chinese: '多少钱？', local: 'Combien?', pronunciation: 'Kohm-byen', category: 'shopping' },
    { chinese: '请给我菜单', local: 'Le menu, s\'il vous plaît', pronunciation: 'Leuh meh-new, seel voo pleh', category: 'dining' },
    { chinese: '火车站在哪？', local: 'Où est la gare?', pronunciation: 'Oo eh la gahr', category: 'transport' },
    { chinese: '帮帮我！', local: 'Au secours!', pronunciation: 'Oh se-coor', category: 'emergency' },
  ]},
];
