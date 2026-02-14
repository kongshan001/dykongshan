import { describe, it, expect, beforeEach, vi } from 'vitest'
import { setActivePinia, createPinia } from 'pinia'
import { useLinksStore } from '@/stores/links'

vi.mock('../data/links.json', () => ({
  default: {
    siteInfo: {
      title: 'Test Site',
      description: 'Test Description',
      logo: '/test.svg'
    },
    categories: [
      { id: 'dev', name: '开发工具', icon: '⚙️' },
      { id: 'docs', name: '文档中心', icon: '📚' }
    ],
    links: [
      {
        id: 'cicd',
        title: 'CI/CD Action',
        url: 'https://cicdaction.dykongshan.com',
        description: '持续集成与部署工具',
        categoryId: 'dev',
        icon: '🚀',
        clickCount: 0,
        createdAt: '2024-01-01'
      },
      {
        id: 'docs',
        title: 'API Docs',
        url: 'https://docs.dykongshan.com',
        description: 'API文档中心',
        categoryId: 'docs',
        icon: '📖',
        clickCount: 0,
        createdAt: '2024-01-02'
      },
      {
        id: 'tools',
        title: 'Dev Tools',
        url: 'https://tools.dykongshan.com',
        description: '开发工具集',
        categoryId: 'dev',
        icon: '🛠️',
        clickCount: 5,
        createdAt: '2024-01-03'
      }
    ]
  }
}))

describe('Links Store', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
    vi.clearAllMocks()
  })

  describe('初始状态', () => {
    it('应该正确加载links数据', () => {
      const store = useLinksStore()
      expect(store.links).toHaveLength(3)
      expect(store.links[0].id).toBe('cicd')
    })

    it('应该初始化搜索查询为空', () => {
      const store = useLinksStore()
      expect(store.searchQuery).toBe('')
    })

    it('应该初始化选中分类为空', () => {
      const store = useLinksStore()
      expect(store.selectedCategory).toBe('')
    })
  })

  describe('搜索功能', () => {
    it('应该根据标题搜索', () => {
      const store = useLinksStore()
      store.setSearchQuery('CI/CD')
      const filtered = store.filteredLinks()
      expect(filtered).toHaveLength(1)
      expect(filtered[0].id).toBe('cicd')
    })

    it('应该根据描述搜索', () => {
      const store = useLinksStore()
      store.setSearchQuery('文档')
      const filtered = store.filteredLinks()
      expect(filtered).toHaveLength(1)
      expect(filtered[0].id).toBe('docs')
    })

    it('搜索应该不区分大小写', () => {
      const store = useLinksStore()
      store.setSearchQuery('api docs')
      const filtered = store.filteredLinks()
      expect(filtered).toHaveLength(1)
    })

    it('空搜索应该返回所有链接', () => {
      const store = useLinksStore()
      store.setSearchQuery('')
      const filtered = store.filteredLinks()
      expect(filtered).toHaveLength(3)
    })
  })

  describe('分类筛选功能', () => {
    it('应该按分类筛选链接', () => {
      const store = useLinksStore()
      store.setSelectedCategory('dev')
      const filtered = store.filteredLinks()
      expect(filtered).toHaveLength(2)
      expect(filtered.every(l => l.categoryId === 'dev')).toBe(true)
    })

    it('空分类应该返回所有链接', () => {
      const store = useLinksStore()
      store.setSelectedCategory('')
      const filtered = store.filteredLinks()
      expect(filtered).toHaveLength(3)
    })

    it('不存在的分类应该返回空数组', () => {
      const store = useLinksStore()
      store.setSelectedCategory('nonexistent')
      const filtered = store.filteredLinks()
      expect(filtered).toHaveLength(0)
    })
  })

  describe('搜索和分类组合', () => {
    it('应该同时应用搜索和分类筛选', () => {
      const store = useLinksStore()
      store.setSearchQuery('Dev')
      store.setSelectedCategory('dev')
      const filtered = store.filteredLinks()
      expect(filtered).toHaveLength(1)
      expect(filtered[0].id).toBe('tools')
    })
  })

  describe('点击统计功能', () => {
    beforeEach(() => {
      vi.spyOn(Storage.prototype, 'getItem')
      vi.spyOn(Storage.prototype, 'setItem')
    })

    it('应该增加点击次数', () => {
      const store = useLinksStore()
      const initialCount = store.links[0].clickCount
      store.incrementClickCount('cicd')
      expect(store.links[0].clickCount).toBe(initialCount + 1)
    })

    it('应该保存到localStorage', () => {
      const store = useLinksStore()
      store.incrementClickCount('cicd')
      expect(localStorage.setItem).toHaveBeenCalledWith(
        'clickStats',
        expect.any(String)
      )
    })

    it('应该从localStorage加载统计', () => {
      vi.mocked(localStorage.getItem).mockReturnValue(
        JSON.stringify({
          cicd: { count: 10, lastClickAt: '2024-01-15T10:00:00Z' }
        })
      )
      const store = useLinksStore()
      store.loadClickStats()
      expect(store.links[0].clickCount).toBe(10)
    })
  })
})
