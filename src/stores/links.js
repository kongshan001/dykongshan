import { defineStore } from 'pinia'
import { ref, reactive } from 'vue'
import linksData from '../data/links.json'
import gitHubReposData from '../data/github-repos.json'

const GITHUB_USERNAME = 'kongshan001'

// 过滤出适合展示的 repos
const filterFeaturedRepos = (repos) => {
  const keywords = [
    'demo', 'test', 'learn', 'tutorial', 'example',
    'homework', 'homeworks', 'code', 'workspace'
  ]
  
  return repos
    .filter(repo => {
      // 跳过没有描述的
      if (!repo.description) return false
      // 跳过 fork 的
      if (repo.fork) return false
      // 跳过空项目
      if (repo.size === 0) return false
      return true
    })
    .map(repo => ({
      id: `gh-${repo.name}`,
      title: repo.name,
      url: repo.html_url,
      description: repo.description,
      categoryId: getCategoryForRepo(repo),
      icon: getIconForRepo(repo),
      language: repo.language,
      stars: repo.stargazers_count,
      clickCount: 0,
      createdAt: repo.created_at.split('T')[0],
      isGitHub: true
    }))
    .sort((a, b) => b.stars - a.stars) // 按星数排序
}

const getCategoryForRepo = (repo) => {
  const name = repo.name.toLowerCase()
  const desc = (repo.description || '').toLowerCase()
  
  if (name.includes('game') || name.includes('chess') || name.includes('opengl') || name.includes('unity')) {
    return 'games'
  }
  if (name.includes('opencode') || name.includes('claw') || name.includes('mcp') || name.includes('plugin')) {
    return 'ai'
  }
  if (name.includes('doc') || name.includes('kms') || name.includes('book')) {
    return 'docs'
  }
  if (name.includes('feishu') || name.includes('wechat') || name.includes('chat')) {
    return 'services'
  }
  return 'dev'
}

const getIconForRepo = (repo) => {
  const name = repo.name.toLowerCase()
  const lang = (repo.language || '').toLowerCase()
  
  if (name.includes('game') || name.includes('chess')) return '🎮'
  if (name.includes('opencode') || name.includes('claw')) return '🤖'
  if (name.includes('opengl') || name.includes('unity')) return '🎨'
  if (name.includes('feishu') || name.includes('wechat')) return '💬'
  if (name.includes('doc') || name.includes('kms')) return '📚'
  if (lang === 'python') return '🐍'
  if (lang === 'javascript' || lang === 'typescript') return '📦'
  if (lang === 'c++' || lang === 'c') return '⚡'
  return '📁'
}

const getStorageSync = (key) => {
  try {
    if (typeof uni !== 'undefined') {
      return uni.getStorageSync(key)
    } else if (typeof localStorage !== 'undefined') {
      const data = localStorage.getItem(key)
      return data ? JSON.parse(data) : null
    }
    return null
  } catch (e) {
    return null
  }
}

const setStorageSync = (key, data) => {
  try {
    if (typeof uni !== 'undefined') {
      uni.setStorageSync(key, data)
    } else if (typeof localStorage !== 'undefined') {
      localStorage.setItem(key, JSON.stringify(data))
    }
  } catch (e) {
    console.error('setStorage error:', e)
  }
}

export const useLinksStore = defineStore('links', () => {
  const links = ref([])
  const searchQuery = ref('')
  const selectedCategory = ref('')
  const clickStats = reactive({})

  const loading = ref(false)
  const gitHubRepos = ref([])

  const loadLinks = () => {
    links.value = linksData.links || []
  }

  const fetchGitHubRepos = async () => {
    if (loading.value || gitHubRepos.value.length > 0) return
    
    loading.value = true
    try {
      // 先尝试加载本地的静态 JSON 文件（由 GitHub Actions 定时更新）
      if (gitHubReposData && gitHubReposData.length > 0) {
        gitHubRepos.value = filterFeaturedRepos(gitHubReposData)
        
        const existingIds = new Set(links.value.map(l => l.id))
        const newRepos = gitHubRepos.value.filter(r => !existingIds.has(r.id))
        links.value = [...links.value, ...newRepos]
      } else {
        // 如果本地没有，回退到直接调用 GitHub API
        await fetchFromGitHubAPI()
      }
    } catch (error) {
      console.error('Failed to load GitHub repos:', error)
      // 回退到 GitHub API
      await fetchFromGitHubAPI()
    } finally {
      loading.value = false
    }
  }

  const fetchFromGitHubAPI = async () => {
    try {
      const response = await fetch(
        `https://api.github.com/users/${GITHUB_USERNAME}/repos?per_page=100&sort=updated`,
        {
          headers: {
            'Accept': 'application/vnd.github.v3+json'
          }
        }
      )
      
      if (response.ok) {
        const repos = await response.json()
        gitHubRepos.value = filterFeaturedRepos(repos)
        
        const existingIds = new Set(links.value.map(l => l.id))
        const newRepos = gitHubRepos.value.filter(r => !existingIds.has(r.id))
        links.value = [...links.value, ...newRepos]
      }
    } catch (error) {
      console.error('Failed to fetch from GitHub API:', error)
    }
  }

  const loadClickStats = () => {
    const saved = getStorageSync('clickStats')
    if (saved) {
      Object.assign(clickStats, saved)
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
    setStorageSync('clickStats', clickStats)

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
    loading,
    gitHubRepos,
    loadLinks,
    loadClickStats,
    fetchGitHubRepos,
    incrementClickCount,
    setSearchQuery,
    setSelectedCategory,
    filteredLinks
  }
})
