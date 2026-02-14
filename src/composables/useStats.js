import { ref, reactive, onMounted } from 'vue'
import linksData from '../data/links.json'

export function useStats() {
  const stats = reactive({})
  const totalClicks = ref(0)

  const loadStats = () => {
    const saved = localStorage.getItem('clickStats')
    if (saved) {
      const data = JSON.parse(saved)
      Object.keys(data).forEach(key => {
        stats[key] = data[key]
      })
      totalClicks.value = Object.values(data).reduce((sum, item) => sum + item.count, 0)
    }
  }

  const getLinkStats = (linkId) => {
    return stats[linkId] || { count: 0, lastClickAt: null }
  }

  const getTopLinks = (limit = 5) => {
    const allLinks = linksData.links || []
    return allLinks
      .map(link => ({
        ...link,
        stats: stats[link.id] || { count: 0 }
      }))
      .sort((a, b) => b.stats.count - a.stats.count)
      .slice(0, limit)
  }

  onMounted(loadStats)

  return {
    stats,
    totalClicks,
    loadStats,
    getLinkStats,
    getTopLinks
  }
}
