export type BookCategory = 'history' | 'literature' | 'travel' | 'culture' | 'guide';

export interface Book {
  id: string;
  title: string;
  author: string;
  category: BookCategory;
  description: string;
  relevanceReason: string;
  pages: number;
  priority: 1 | 2 | 3; // 1=必读 2=推荐 3=选读
}

export interface DestinationBooklist {
  destination: string;
  books: Book[];
}

export function getPriorityLabel(p: number): string {
  return p === 1 ? '📕 必读' : p === 2 ? '📗 推荐' : '📘 选读';
}
