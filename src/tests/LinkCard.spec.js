import { describe, it, expect, beforeEach, vi } from 'vitest'
import { mount } from '@vue/test-utils'
import LinkCard from '@/components/LinkCard.vue'

describe('LinkCard 组件', () => {
  const mockLink = {
    id: 'test-link',
    title: 'Test Link',
    url: 'https://example.com',
    description: 'Test description',
    icon: '🔗',
    clickCount: 5,
    categoryId: 'dev',
    createdAt: '2024-01-01'
  }

  const createWrapper = (props = {}) => {
    return mount(LinkCard, {
      props: {
        link: mockLink,
        ...props
      }
    })
  }

  describe('渲染', () => {
    it('应该正确渲染链接信息', () => {
      const wrapper = createWrapper()
      expect(wrapper.text()).toContain('Test Link')
      expect(wrapper.text()).toContain('Test description')
      expect(wrapper.text()).toContain('🔗')
    })

    it('应该显示点击次数', () => {
      const wrapper = createWrapper()
      expect(wrapper.text()).toContain('5 次点击')
    })

    it('应该有正确的href属性', () => {
      const wrapper = createWrapper()
      const link = wrapper.find('a')
      expect(link.attributes('href')).toBe('https://example.com')
    })

    it('应该有target="_blank"属性', () => {
      const wrapper = createWrapper()
      const link = wrapper.find('a')
      expect(link.attributes('target')).toBe('_blank')
    })

    it('应该有rel="noopener noreferrer"属性', () => {
      const wrapper = createWrapper()
      const link = wrapper.find('a')
      expect(link.attributes('rel')).toBe('noopener noreferrer')
    })
  })

  describe('交互', () => {
    it('点击卡片应该触发click事件', async () => {
      const wrapper = createWrapper()
      const link = wrapper.find('a')

      await link.trigger('click')

      expect(wrapper.emitted('click')).toBeTruthy()
      expect(wrapper.emitted('click')[0]).toEqual([mockLink])
    })

    it('应该阻止默认链接行为', async () => {
      const wrapper = createWrapper()
      const link = wrapper.find('a')

      const event = {
        preventDefault: vi.fn()
      }

      await link.trigger('click', event)

      expect(event.preventDefault).toHaveBeenCalled()
    })
  })

  describe('props验证', () => {
    it('应该正确接收link prop', () => {
      const wrapper = createWrapper()
      expect(wrapper.props().link).toEqual(mockLink)
    })

    it('应该处理不同的点击次数', () => {
      const wrapper = createWrapper({
        link: { ...mockLink, clickCount: 100 }
      })
      expect(wrapper.text()).toContain('100 次点击')
    })

    it('应该处理零点击次数', () => {
      const wrapper = createWrapper({
        link: { ...mockLink, clickCount: 0 }
      })
      expect(wrapper.text()).toContain('0 次点击')
    })
  })
})
