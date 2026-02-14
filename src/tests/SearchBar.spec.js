import { describe, it, expect, beforeEach, vi } from 'vitest'
import { mount } from '@vue/test-utils'
import { createPinia, setActivePinia } from 'pinia'
import SearchBar from '@/components/SearchBar.vue'
import { useLinksStore } from '@/stores/links'

describe('SearchBar 组件', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
  })

  const createWrapper = () => {
    return mount(SearchBar, {
      global: {
        plugins: [createPinia()]
      }
    })
  }

  describe('渲染', () => {
    it('应该正确渲染搜索输入框', () => {
      const wrapper = createWrapper()
      const input = wrapper.find('input[type="text"]')
      expect(input.exists()).toBe(true)
      expect(input.attributes('placeholder')).toBe('搜索子域名...')
    })

    it('应该显示搜索图标', () => {
      const wrapper = createWrapper()
      const icons = wrapper.findAll('svg')
      expect(icons.length).toBeGreaterThan(0)
    })

    it('搜索为空时不显示清除按钮', () => {
      const wrapper = createWrapper()
      const clearButton = wrapper.find('button')
      expect(clearButton.exists()).toBe(false)
    })

    it('搜索有内容时显示清除按钮', async () => {
      const wrapper = createWrapper()
      const store = useLinksStore()
      store.setSearchQuery('test')
      await wrapper.vm.$nextTick()

      const clearButton = wrapper.find('button')
      expect(clearButton.exists()).toBe(true)
    })
  })

  describe('交互', () => {
    it('输入应该更新搜索查询', async () => {
      const wrapper = createWrapper()
      const store = useLinksStore()
      const input = wrapper.find('input[type="text"]')

      await input.setValue('CI/CD Action')

      expect(store.searchQuery).toBe('CI/CD Action')
    })

    it('点击清除按钮应该清空搜索', async () => {
      const wrapper = createWrapper()
      const store = useLinksStore()
      store.setSearchQuery('test')
      await wrapper.vm.$nextTick()

      const clearButton = wrapper.find('button')
      await clearButton.trigger('click')

      expect(store.searchQuery).toBe('')
    })
  })

  describe('输入框事件', () => {
    it('应该响应输入事件', async () => {
      const wrapper = createWrapper()
      const input = wrapper.find('input[type="text"]')

      await input.setValue('测试搜索')

      expect(wrapper.emitted()).toBeTruthy()
    })

    it('应该正确处理空输入', async () => {
      const wrapper = createWrapper()
      const input = wrapper.find('input[type="text"]')

      await input.setValue('')
      await input.setValue('new search')

      const store = useLinksStore()
      expect(store.searchQuery).toBe('new search')
    })
  })
})
