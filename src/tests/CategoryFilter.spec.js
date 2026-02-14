import { describe, it, expect, beforeEach, vi } from 'vitest'
import { mount } from '@vue/test-utils'
import { createPinia, setActivePinia } from 'pinia'
import CategoryFilter from '@/components/CategoryFilter.vue'
import { useLinksStore } from '@/stores/links'

vi.mock('../data/links.json', () => ({
  default: {
    categories: [
      { id: 'dev', name: '开发工具', icon: '⚙️' },
      { id: 'docs', name: '文档中心', icon: '📚' }
    ],
    links: []
  }
}))

describe('CategoryFilter 组件', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
  })

  describe('基本渲染', () => {
    it('应该渲染全部按钮', () => {
      const wrapper = mount(CategoryFilter, {
        global: {
          plugins: [createPinia()]
        }
      })
      expect(wrapper.text()).toContain('全部')
    })

    it('应该是一个有效的Vue组件', () => {
      expect(CategoryFilter).toBeTruthy()
    })
  })

  describe('交互', () => {
    it('点击分类按钮应该触发分类选择', async () => {
      const wrapper = mount(CategoryFilter, {
        global: {
          plugins: [createPinia()]
        }
      })
      const store = useLinksStore()

      wrapper.vm.selectCategory('dev')

      expect(store.selectedCategory).toBe('dev')
    })

    it('点击全部应该清空选中分类', async () => {
      const wrapper = mount(CategoryFilter, {
        global: {
          plugins: [createPinia()]
        }
      })
      const store = useLinksStore()

      wrapper.vm.selectCategory('dev')
      wrapper.vm.selectCategory('')

      expect(store.selectedCategory).toBe('')
    })
  })
})
