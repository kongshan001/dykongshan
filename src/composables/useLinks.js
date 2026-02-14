import { ref, reactive } from 'vue'
import linksData from '../data/links.json'

export function useLinks() {
  const links = ref([])
  const searchQuery = ref('')
  const selectedCategory = ref('')
  const clickStats = reactive({})

  const loadLinks = () => {
    links.value = linksData.links || []
  }

  const loadClickStats = () => {
    const saved = localStorage.getItem('clickStats')
    if (saved) {
      const stats = JSON.parse(saved)
      Object.keys(stats).forEach(linkId => {
        const link = links.value.find(l => l.id === linkId)
        if (link) {
          link.clickCount = stats[linkId].count
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
    localStorage.setItem('clickStats', JSON.stringify(clickStats))

    const link = links.value.find(l => l.id === linkId)
    if (link) {
      link.clickCount = clickStats[linkId].count
    }
  }

  loadLinks()

  return {
    links,
    searchQuery,
    selectedCategory,
    loadClickStats,
    incrementClickCount
  }
}
