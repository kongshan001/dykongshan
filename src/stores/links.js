import { defineStore } from 'pinia'
import { ref, reactive } from 'vue'
import linksData from '../data/links.json'

const getStorage = (key) => {
  return new Promise((resolve) => {
    if (typeof uni !== 'undefined') {
      uni.getStorage({
        key,
        success: (res) => resolve(res.data),
        fail: () => resolve(null)
      })
    } else if (typeof localStorage !== 'undefined') {
      const data = localStorage.getItem(key)
      resolve(data ? JSON.parse(data) : null)
    } else {
      resolve(null)
    }
  })
}

const setStorage = (key, data) => {
  if (typeof uni !== 'undefined') {
    uni.setStorage({ key, data })
  } else if (typeof localStorage !== 'undefined') {
    localStorage.setItem(key, JSON.stringify(data))
  }
}

export const useLinksStore = defineStore('links', () => {
  const links = ref([])
  const searchQuery = ref('')
  const selectedCategory = ref('')
  const clickStats = reactive({})

  const loadLinks = () => {
    links.value = linksData.links || []
  }

  const loadClickStats = async () => {
    const saved = await getStorage('clickStats')
    if (saved) {
      Object.keys(saved).forEach(linkId => {
        const link = links.value.find(l => l.id === linkId)
        if (link) {
          link.clickCount = saved[linkId].count
        }
      })
    }
  }

  const incrementClickCount = (linkId) => {
    if (!clickStats[linkId]) {
      clickStats[linkId] = { count: 0, lastClickAt: null }
    }
    clickStats[linkId].count++
    clickStats[linkId].lastClickAt = new Date().toISOString()
    setStorage('clickStats', clickStats)

    const link = links.value.find(l => l.id === linkId)
    if (link) {
      link.clickCount = clickStats[linkId].count
    }
  }

  const setSearchQuery = (query) => {
    searchQuery.value = query
  }

  const setSelectedCategory = (categoryId) => {
    selectedCategory.value = categoryId
  }

  const filteredLinks = () => {
    let result = links.value

    if (selectedCategory.value) {
      result = result.filter(link => link.categoryId === selectedCategory.value)
    }

    if (searchQuery.value) {
      const query = searchQuery.value.toLowerCase()
      result = result.filter(link =>
        link.title.toLowerCase().includes(query) ||
        link.description.toLowerCase().includes(query)
      )
    }

    return result
  }

  loadLinks()

  return {
    links,
    searchQuery,
    selectedCategory,
    clickStats,
    loadLinks,
    loadClickStats,
    incrementClickCount,
    setSearchQuery,
    setSelectedCategory,
    filteredLinks
  }
})
