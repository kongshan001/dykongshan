<template>
  <view class="repo-preview" :class="{ dark: isDark }">
    <!-- Loading -->
    <view v-if="loading" class="loading-container">
      <view class="loading-spinner"></view>
      <text class="loading-text">正在加载仓库信息...</text>
    </view>

    <!-- Error -->
    <view v-else-if="error" class="error-container">
      <text class="error-icon">⚠️</text>
      <text class="error-text">{{ error }}</text>
      <button class="retry-btn" @click="loadRepo">重试</button>
    </view>

    <!-- Content -->
    <view v-else class="content">
      <!-- Header Card -->
      <view class="repo-header-card">
        <view class="repo-title-row">
          <text class="repo-icon">📦</text>
          <view class="repo-title-info">
            <text class="repo-name">{{ repoInfo.name }}</text>
            <text class="repo-full-name">{{ repoInfo.fullName }}</text>
          </view>
        </view>
        
        <text class="repo-description">{{ repoInfo.description || '暂无描述' }}</text>
        
        <!-- Stats -->
        <view class="repo-stats">
          <view class="stat-item">
            <text class="stat-icon">⭐</text>
            <text class="stat-value">{{ formatNumber(repoInfo.stars) }}</text>
            <text class="stat-label">Stars</text>
          </view>
          <view class="stat-item">
            <text class="stat-icon">🍴</text>
            <text class="stat-value">{{ formatNumber(repoInfo.forks) }}</text>
            <text class="stat-label">Forks</text>
          </view>
          <view class="stat-item">
            <text class="stat-icon">👁️</text>
            <text class="stat-value">{{ formatNumber(repoInfo.watchers) }}</text>
            <text class="stat-label">Watchers</text>
          </view>
          <view class="stat-item">
            <text class="stat-icon">📝</text>
            <text class="stat-value">{{ repoInfo.issues }}</text>
            <text class="stat-label">Issues</text>
          </view>
        </view>
        
        <!-- Tags -->
        <view class="repo-tags" v-if="repoInfo.topics?.length">
          <text class="tag" v-for="topic in repoInfo.topics.slice(0, 6)" :key="topic">{{ topic }}</text>
        </view>
        
        <!-- Actions -->
        <view class="repo-actions">
          <button class="action-btn primary" @click="openGitHub">
            <text>🔗 查看 GitHub</text>
          </button>
          <button class="action-btn secondary" @click="copyUrl">
            <text>📋 复制链接</text>
          </button>
        </view>
        
        <view class="repo-meta">
          <text class="meta-item">🕐 更新于 {{ repoInfo.updatedAt }}</text>
          <text class="meta-item">📂 {{ repoInfo.language || 'Unknown' }}</text>
        </view>
      </view>
      
      <!-- README Section -->
      <view class="readme-section" v-if="readmeContent">
        <view class="section-header">
          <text class="section-title">📖 README</text>
        </view>
        <view class="readme-content" v-html="readmeContent"></view>
      </view>
      
      <!-- Loading README -->
      <view v-else-if="readmeLoading" class="readme-loading">
        <text>📖 正在加载 README...</text>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const loading = ref(true)
const readmeLoading = ref(true)
const error = ref('')
const repoInfo = ref({})
const readmeContent = ref('')

const getRepoPath = () => {
  const pages = getCurrentPages()
  const currentPage = pages[pages.length - 1]
  const options = currentPage.options || {}
  return options.repo || ''
}

const loadRepo = async () => {
  loading.value = true
  error.value = ''
  
  const repoPath = getRepoPath()
  if (!repoPath) {
    error.value = '未提供仓库路径'
    loading.value = false
    return
  }
  
  try {
    // Fetch repo info
    const repoRes = await fetch(`https://api.github.com/repos/${repoPath}`)
    if (!repoRes.ok) throw new Error('仓库不存在或访问受限')
    const repoData = await repoRes.json()
    
    repoInfo.value = {
      name: repoData.name,
      fullName: repoData.full_name,
      description: repoData.description,
      stars: repoData.stargazers_count,
      forks: repoData.forks_count,
      watchers: repoData.watchers_count,
      issues: repoData.open_issues_count,
      topics: repoData.topics || [],
      language: repoData.language,
      updatedAt: new Date(repoData.updated_at).toLocaleDateString('zh-CN'),
      htmlUrl: repoData.html_url
    }
    
    // Fetch README
    readmeLoading.value = true
    try {
      // Try to get README in different formats
      const readmeRes = await fetch(`https://api.github.com/repos/${repoPath}/readme`, {
        headers: { 'Accept': 'application/vnd.github.raw' }
      })
      if (readmeRes.ok) {
        const readmeText = await readmeRes.text()
        // Simple markdown to HTML conversion (basic)
        readmeContent.value = simpleMarkdown(readmeText)
      }
    } catch (e) {
      console.log('README not found')
    }
    readmeLoading.value = false
    
  } catch (e) {
    error.value = e.message || '加载失败'
  }
  
  loading.value = false
}

const simpleMarkdown = (text) => {
  if (!text) return ''
  
  let html = text
    // Headers
    .replace(/^### (.*$)/gm, '<h3>$1</h3>')
    .replace(/^## (.*$)/gm, '<h2>$1</h2>')
    .replace(/^# (.*$)/gm, '<h1>$1</h1>')
    // Bold
    .replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')
    // Italic
    .replace(/\*(.*?)\*/g, '<em>$1</em>')
    // Code blocks
    .replace(/```(\w*)\n([\s\S]*?)```/g, '<pre><code class="language-$1">$2</code></pre>')
    .replace(/`(.*?)`/g, '<code>$1</code>')
    // Links
    .replace(/\[(.*?)\]\((.*?)\)/g, '<a href="$2" target="_blank">$1</a>')
    // Lists
    .replace(/^- (.*$)/gm, '<li>$1</li>')
    .replace(/^(\d+)\. (.*$)/gm, '<li>$2</li>')
    // Line breaks
    .replace(/\n\n/g, '</p><p>')
    .replace(/\n/g, '<br>')
  
  return `<p>${html}</p>`
}

const formatNumber = (num) => {
  if (num >= 1000) {
    return (num / 1000).toFixed(1) + 'k'
  }
  return num
}

const openGitHub = () => {
  // #ifdef H5
  window.open(repoInfo.value.htmlUrl, '_blank')
  // #endif
  // #ifdef MP-WEIXIN
  uni.setClipboardData({
    data: repoInfo.value.htmlUrl,
    success: () => {
      uni.showToast({ title: '链接已复制', icon: 'success' })
    }
  })
  // #endif
}

const copyUrl = () => {
  uni.setClipboardData({
    data: repoInfo.value.htmlUrl,
    success: () => {
      uni.showToast({ title: '链接已复制', icon: 'success' })
    }
  })
}

onMounted(() => {
  loadRepo()
})
</script>

<style lang="scss" scoped>
.repo-preview {
  min-height: 100vh;
  background: linear-gradient(-45deg, #ee7752, #e73c7e, #23a6d5, #23d5ab);
  background-size: 400% 400%;
  animation: gradient-shift 15s ease infinite;
  padding: 32rpx;
  
  &.dark {
    background: linear-gradient(-45deg, #1a1a2e, #16213e, #0f3460, #1f4068);
  }
}

@keyframes gradient-shift {
  0% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
  100% { background-position: 0% 50%; }
}

.loading-container, .error-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 60vh;
}

.loading-spinner {
  width: 80rpx;
  height: 80rpx;
  border: 6rpx solid rgba(255, 255, 255, 0.3);
  border-top-color: #fff;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.loading-text, .error-text {
  color: rgba(255, 255, 255, 0.9);
  margin-top: 24rpx;
  font-size: 28rpx;
}

.error-icon {
  font-size: 80rpx;
}

.retry-btn {
  margin-top: 32rpx;
  padding: 20rpx 60rpx;
  background: rgba(255, 255, 255, 0.25);
  border: 1rpx solid rgba(255, 255, 255, 0.3);
  border-radius: 50rpx;
  color: #fff;
  font-size: 28rpx;
}

.repo-header-card {
  background: rgba(255, 255, 255, 0.2);
  backdrop-filter: blur(20rpx);
  border: 1rpx solid rgba(255, 255, 255, 0.25);
  border-radius: 24rpx;
  padding: 40rpx;
  margin-bottom: 32rpx;
}

.repo-title-row {
  display: flex;
  align-items: flex-start;
  margin-bottom: 24rpx;
}

.repo-icon {
  font-size: 72rpx;
  margin-right: 24rpx;
}

.repo-title-info {
  flex: 1;
}

.repo-name {
  display: block;
  font-size: 44rpx;
  font-weight: 800;
  color: #fff;
  text-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.2);
}

.repo-full-name {
  display: block;
  font-size: 26rpx;
  color: rgba(255, 255, 255, 0.75);
  margin-top: 8rpx;
}

.repo-description {
  display: block;
  font-size: 28rpx;
  color: rgba(255, 255, 255, 0.9);
  line-height: 1.6;
  margin-bottom: 32rpx;
}

.repo-stats {
  display: flex;
  justify-content: space-around;
  padding: 24rpx 0;
  border-top: 1rpx solid rgba(255, 255, 255, 0.15);
  border-bottom: 1rpx solid rgba(255, 255, 255, 0.15);
  margin-bottom: 24rpx;
}

.stat-item {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.stat-icon {
  font-size: 32rpx;
}

.stat-value {
  font-size: 36rpx;
  font-weight: 700;
  color: #fff;
  margin-top: 8rpx;
}

.stat-label {
  font-size: 22rpx;
  color: rgba(255, 255, 255, 0.7);
}

.repo-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 12rpx;
  margin-bottom: 24rpx;
}

.tag {
  padding: 8rpx 20rpx;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 50rpx;
  font-size: 22rpx;
  color: #fff;
}

.repo-actions {
  display: flex;
  gap: 24rpx;
  margin-bottom: 24rpx;
}

.action-btn {
  flex: 1;
  padding: 24rpx;
  border-radius: 16rpx;
  font-size: 28rpx;
  text-align: center;
  border: none;
  
  &.primary {
    background: rgba(255, 255, 255, 0.95);
    color: #e73c7e;
    font-weight: 600;
  }
  
  &.secondary {
    background: rgba(255, 255, 255, 0.2);
    color: #fff;
  }
}

.repo-meta {
  display: flex;
  justify-content: space-between;
}

.meta-item {
  font-size: 24rpx;
  color: rgba(255, 255, 255, 0.7);
}

.readme-section {
  background: rgba(255, 255, 255, 0.2);
  backdrop-filter: blur(20rpx);
  border: 1rpx solid rgba(255, 255, 255, 0.25);
  border-radius: 24rpx;
  padding: 32rpx;
}

.section-header {
  margin-bottom: 24rpx;
}

.section-title {
  font-size: 32rpx;
  font-weight: 700;
  color: #fff;
}

.readme-content {
  font-size: 26rpx;
  color: rgba(255, 255, 255, 0.9);
  line-height: 1.8;
  
  :deep(h1), :deep(h2), :deep(h3) {
    color: #fff;
    margin: 24rpx 0 16rpx;
  }
  
  :deep(p) {
    margin-bottom: 16rpx;
  }
  
  :deep(ul), :deep(ol) {
    padding-left: 32rpx;
    margin-bottom: 16rpx;
  }
  
  :deep(li) {
    margin-bottom: 8rpx;
  }
  
  :deep(code) {
    background: rgba(0, 0, 0, 0.2);
    padding: 4rpx 12rpx;
    border-radius: 8rpx;
    font-size: 24rpx;
  }
  
  :deep(pre) {
    background: rgba(0, 0, 0, 0.3);
    padding: 24rpx;
    border-radius: 12rpx;
    overflow-x: auto;
    margin: 16rpx 0;
  }
  
  :deep(a) {
    color: #ffd700;
    text-decoration: underline;
  }
  
  :deep(strong) {
    font-weight: 700;
  }
}

.readme-loading {
  text-align: center;
  padding: 40rpx;
  color: rgba(255, 255, 255, 0.8);
  font-size: 28rpx;
}
</style>
