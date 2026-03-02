<template>
  <view class="container">
    <!-- Header with gradient -->
    <view class="header">
      <view class="header-bg"></view>
      <view class="header-content">
        <view class="logo-row">
          <text class="logo-emoji">🔺</text>
          <view class="title-group">
            <text class="page-title">ClawHub Skills 实验室</text>
            <text class="page-desc">AI Skills 深度分析报告</text>
          </view>
        </view>
        
        <!-- Quick Stats -->
        <view class="quick-stats">
          <view class="stat-item">
            <text class="stat-value">{{ stats.analyzedSkills }}</text>
            <text class="stat-label">已分析</text>
          </view>
          <view class="stat-divider"></view>
          <view class="stat-item">
            <text class="stat-value">{{ stats.pendingSkills }}</text>
            <text class="stat-label">待安装</text>
          </view>
          <view class="stat-divider"></view>
          <view class="stat-item">
            <text class="stat-value">{{ stats.reports }}</text>
            <text class="stat-label">报告</text>
          </view>
        </view>
        
        <!-- Progress Bar -->
        <view class="progress-section">
          <view class="progress-bar">
            <view class="progress-fill" :style="{ width: '100%' }"></view>
          </view>
          <text class="progress-text">{{ stats.progress }} 完成 | {{ stats.runtime }} 运行</text>
        </view>
      </view>
    </view>

    <!-- Tab Switcher -->
    <view class="tab-switcher">
      <view class="tab" :class="{ active: activeTab === 'discovered' }" @click="activeTab = 'discovered'">
        <text class="tab-text">🆕 待安装 ({{ discovered.length }})</text>
      </view>
      <view class="tab" :class="{ active: activeTab === 'analyzed' }" @click="activeTab = 'analyzed'">
        <text class="tab-text">✅ 已分析 ({{ skills.length }})</text>
      </view>
    </view>

    <!-- Search Bar -->
    <view class="search-section">
      <view class="search-wrapper">
        <text class="search-icon">🔍</text>
        <input
          class="search-input"
          v-model="searchQuery"
          type="text"
          placeholder="搜索 Skills..."
        />
        <text v-if="searchQuery" class="clear-btn" @click="clearSearch">✕</text>
      </view>
    </view>

    <!-- Discovered Skills (Pending) -->
    <view v-if="activeTab === 'discovered'" class="section">
      <view class="section-header">
        <text class="section-title">🆕 最新发现</text>
        <text class="section-desc">高评分 Skills 等待安装</text>
      </view>
      
      <view class="skills-list">
        <view
          v-for="(skill, index) in filteredDiscovered"
          :key="skill.id"
          class="skill-card pending"
          :style="{ animationDelay: index * 0.05 + 's' }"
          @click="openReport(skill)"
        >
          <view class="pending-badge">待安装</view>
          <view class="rating-badge" :class="'rating-' + Math.round(skill.rating)">
            <text>{{ skill.rating.toFixed(1) }}</text>
          </view>
          
          <view class="skill-header">
            <view class="emoji-wrapper">
              <text class="skill-emoji">{{ skill.emoji }}</text>
            </view>
            <view class="skill-info">
              <text class="skill-name">{{ skill.name }}</text>
              <view class="skill-meta">
                <text class="skill-category-tag">{{ skill.category }}</text>
                <text class="skill-source-tag">{{ skill.source }}</text>
              </view>
            </view>
          </view>
          
          <text class="skill-desc">{{ skill.description }}</text>
          
          <view class="skill-features">
            <text
              v-for="(feature, idx) in skill.features.slice(0, 4)"
              :key="idx"
              class="feature-tag"
            >
              {{ feature }}
            </text>
          </view>
        </view>
      </view>
    </view>

    <!-- Analyzed Skills -->
    <view v-if="activeTab === 'analyzed'" class="section">
      <!-- Category Filter -->
      <view class="category-filter">
        <scroll-view scroll-x class="category-scroll">
          <view class="category-list">
            <view
              class="category-item"
              :class="{ active: selectedCategory === '' }"
              @click="selectCategory('')"
            >
              <text class="cat-name">全部</text>
              <text class="cat-count">{{ skills.length }}</text>
            </view>
            <view
              v-for="(name, id) in limitedCategories"
              :key="id"
              class="category-item"
              :class="{ active: selectedCategory === id }"
              @click="selectCategory(id)"
            >
              <text class="cat-name">{{ name }}</text>
              <text class="cat-count">{{ getCategoryCount(id) }}</text>
            </view>
          </view>
        </scroll-view>
      </view>

      <!-- Sort Options -->
      <view class="sort-section">
        <text class="result-count">{{ filteredSkills.length }} 个结果</text>
        <view class="sort-options">
          <text
            class="sort-btn"
            :class="{ active: sortBy === 'rating' }"
            @click="sortBy = 'rating'"
          >
            按评分
          </text>
          <text
            class="sort-btn"
            :class="{ active: sortBy === 'name' }"
            @click="sortBy = 'name'"
          >
            按名称
          </text>
        </view>
      </view>

      <!-- Skills List -->
      <view class="skills-list">
        <view
          v-for="(skill, index) in sortedSkills"
          :key="skill.id"
          class="skill-card"
          :style="{ animationDelay: index * 0.03 + 's' }"
          @click="openReport(skill)"
        >
          <view class="rating-badge" :class="'rating-' + skill.rating">
            <text>{{ skill.rating }}</text>
          </view>
          
          <view class="skill-header">
            <view class="emoji-wrapper">
              <text class="skill-emoji">{{ skill.emoji }}</text>
            </view>
            <view class="skill-info">
              <text class="skill-name">{{ skill.name }}</text>
              <view class="skill-meta">
                <text class="skill-category-tag">{{ skill.category }}</text>
                <text class="skill-source-tag">{{ skill.source }}</text>
              </view>
            </view>
          </view>
          
          <text class="skill-desc">{{ skill.description }}</text>
          
          <view class="skill-features">
            <text
              v-for="(feature, idx) in skill.features.slice(0, 3)"
              :key="idx"
              class="feature-tag"
            >
              {{ feature }}
            </text>
          </view>
          
          <view class="skill-footer">
            <view class="footer-left">
              <text class="star-rating">{{ '⭐'.repeat(skill.rating) }}</text>
            </view>
            <view class="view-report-btn">
              <text class="btn-text">查看报告</text>
              <text class="btn-arrow">→</text>
            </view>
          </view>
        </view>
      </view>
    </view>

    <!-- Footer -->
    <view class="footer">
      <view class="footer-card">
        <text class="footer-icon">📊</text>
        <view class="footer-info">
          <text class="footer-title">数据来源</text>
          <text class="footer-desc">每 30 分钟自动探索更新</text>
        </view>
      </view>
      <view class="footer-links">
        <text class="footer-link" @click="openGitHub">🔗 GitHub 仓库</text>
        <text class="footer-divider">|</text>
        <text class="footer-link" @click="openClawHub">🌐 ClawHub</text>
      </view>
      <text class="footer-time">最后更新: {{ stats.lastUpdated }}</text>
    </view>
  </view>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import skillsData from '@/data/skills.json'

const activeTab = ref('discovered')
const searchQuery = ref('')
const selectedCategory = ref('')
const sortBy = ref('rating')

const stats = ref(skillsData.stats)
const skills = ref(skillsData.skills)
const discovered = ref(skillsData.discovered)

const categories = computed(() => stats.value.categories)

const limitedCategories = computed(() => {
  const entries = Object.entries(stats.value.categories)
  return Object.fromEntries(entries.slice(0, 6))
})

const getCategoryCount = (categoryId) => {
  return skills.value.filter(s => s.category === categoryId).length
}

const filteredDiscovered = computed(() => {
  if (!searchQuery.value) return discovered.value
  const query = searchQuery.value.toLowerCase()
  return discovered.value.filter(s =>
    s.name.toLowerCase().includes(query) ||
    s.description.toLowerCase().includes(query)
  )
})

const filteredSkills = computed(() => {
  let result = skills.value

  if (selectedCategory.value) {
    result = result.filter(s => s.category === selectedCategory.value)
  }

  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase()
    result = result.filter(s =>
      s.name.toLowerCase().includes(query) ||
      s.description.toLowerCase().includes(query) ||
      s.features.some(f => f.toLowerCase().includes(query))
    )
  }

  return result
})

const sortedSkills = computed(() => {
  const result = [...filteredSkills.value]
  
  if (sortBy.value === 'rating') {
    result.sort((a, b) => b.rating - a.rating)
  } else if (sortBy.value === 'name') {
    result.sort((a, b) => a.name.localeCompare(b.name))
  }
  
  return result
})

const selectCategory = (categoryId) => {
  selectedCategory.value = categoryId
}

const clearSearch = () => {
  searchQuery.value = ''
}

const openReport = (skill) => {
  // #ifdef H5
  window.open(skill.reportUrl, '_blank')
  // #endif
  // #ifdef MP-WEIXIN
  uni.setClipboardData({
    data: skill.reportUrl,
    success: () => {
      uni.showToast({
        title: '链接已复制',
        icon: 'success'
      })
    }
  })
  // #endif
}

const openGitHub = () => {
  // #ifdef H5
  window.open('https://github.com/kongshan001/clawhub-lab', '_blank')
  // #endif
}

const openClawHub = () => {
  // #ifdef H5
  window.open('https://clawhub.com', '_blank')
  // #endif
}

onMounted(async () => {
  try {
    const res = await fetch('https://raw.githubusercontent.com/kongshan001/dykongshan/main/src/data/skills.json')
    if (res.ok) {
      const data = await res.json()
      stats.value = data.stats
      skills.value = data.skills
      discovered.value = data.discovered || []
    }
  } catch (e) {
    console.log('Using local data')
  }
})
</script>

<style lang="scss" scoped>
.container {
  min-height: 100vh;
  background-color: #f0f2f5;
}

// Header
.header {
  position: relative;
  overflow: hidden;
}

.header-bg {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 100%;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%);
}

.header-content {
  position: relative;
  z-index: 1;
  padding: 48rpx 32rpx 32rpx;
}

.logo-row {
  display: flex;
  align-items: center;
  margin-bottom: 32rpx;
}

.logo-emoji {
  font-size: 80rpx;
  margin-right: 24rpx;
  filter: drop-shadow(0 4rpx 8rpx rgba(0,0,0,0.2));
}

.title-group {
  display: flex;
  flex-direction: column;
}

.page-title {
  font-size: 44rpx;
  font-weight: bold;
  color: #ffffff;
  text-shadow: 0 2rpx 4rpx rgba(0,0,0,0.2);
}

.page-desc {
  font-size: 26rpx;
  color: rgba(255, 255, 255, 0.85);
  margin-top: 8rpx;
}

.quick-stats {
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(255, 255, 255, 0.15);
  backdrop-filter: blur(10px);
  border-radius: 20rpx;
  padding: 24rpx 32rpx;
  margin-bottom: 20rpx;
}

.stat-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 0 32rpx;
}

.stat-value {
  font-size: 48rpx;
  font-weight: bold;
  color: #ffffff;
}

.stat-label {
  font-size: 22rpx;
  color: rgba(255, 255, 255, 0.8);
  margin-top: 4rpx;
}

.stat-divider {
  width: 1rpx;
  height: 48rpx;
  background: rgba(255, 255, 255, 0.3);
}

.progress-section {
  margin-top: 16rpx;
}

.progress-bar {
  height: 8rpx;
  background: rgba(255, 255, 255, 0.3);
  border-radius: 4rpx;
  overflow: hidden;
}

.progress-fill {
  height: 100%;
  background: linear-gradient(90deg, #10b981, #34d399);
  border-radius: 4rpx;
}

.progress-text {
  display: block;
  text-align: center;
  font-size: 22rpx;
  color: rgba(255, 255, 255, 0.8);
  margin-top: 8rpx;
}

// Tab Switcher
.tab-switcher {
  display: flex;
  padding: 16rpx 32rpx;
  gap: 16rpx;
  background-color: #ffffff;
  border-bottom: 1rpx solid #e5e7eb;
}

.tab {
  flex: 1;
  padding: 20rpx;
  text-align: center;
  border-radius: 12rpx;
  background-color: #f3f4f6;
  
  &.active {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    
    .tab-text {
      color: #ffffff;
    }
  }
}

.tab-text {
  font-size: 28rpx;
  font-weight: 500;
  color: #374151;
}

// Search
.search-section {
  padding: 24rpx 32rpx;
}

.search-wrapper {
  display: flex;
  align-items: center;
  background-color: #ffffff;
  border-radius: 16rpx;
  padding: 20rpx 24rpx;
  box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.08);
}

.search-icon {
  font-size: 32rpx;
  margin-right: 16rpx;
}

.search-input {
  flex: 1;
  font-size: 28rpx;
  color: #111827;
}

.clear-btn {
  padding: 8rpx 16rpx;
  color: #9ca3af;
  font-size: 28rpx;
}

// Section
.section {
  padding: 0 32rpx;
}

.section-header {
  padding: 24rpx 0;
}

.section-title {
  font-size: 32rpx;
  font-weight: bold;
  color: #111827;
}

.section-desc {
  font-size: 24rpx;
  color: #6b7280;
  margin-top: 4rpx;
}

// Category Filter
.category-filter {
  padding: 0 0 24rpx;
}

.category-scroll {
  white-space: nowrap;
}

.category-list {
  display: flex;
  flex-wrap: nowrap;
  gap: 12rpx;
}

.category-item {
  display: inline-flex;
  align-items: center;
  padding: 12rpx 20rpx;
  border-radius: 12rpx;
  background-color: #ffffff;
  
  &.active {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    
    .cat-name, .cat-count {
      color: #ffffff;
    }
  }
}

.cat-name {
  font-size: 24rpx;
  color: #374151;
}

.cat-count {
  font-size: 20rpx;
  color: #9ca3af;
  margin-left: 8rpx;
  background-color: #f3f4f6;
  padding: 2rpx 10rpx;
  border-radius: 6rpx;
}

// Sort
.sort-section {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-bottom: 24rpx;
}

.result-count {
  font-size: 24rpx;
  color: #6b7280;
}

.sort-options {
  display: flex;
  gap: 16rpx;
}

.sort-btn {
  font-size: 22rpx;
  color: #9ca3af;
  padding: 8rpx 16rpx;
  border-radius: 8rpx;
  
  &.active {
    color: #667eea;
    background-color: #e0e7ff;
  }
}

// Skills List
.skills-list {
  padding-bottom: 24rpx;
}

.skill-card {
  background-color: #ffffff;
  border-radius: 20rpx;
  padding: 32rpx;
  margin-bottom: 24rpx;
  box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.06);
  position: relative;
  overflow: hidden;
  animation: fadeInUp 0.4s ease-out forwards;
  opacity: 0;
  
  &.pending {
    border: 2rpx dashed #f59e0b;
    background: linear-gradient(135deg, #fffbeb 0%, #ffffff 100%);
  }
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(20rpx);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.pending-badge {
  position: absolute;
  top: 16rpx;
  left: 16rpx;
  padding: 6rpx 16rpx;
  background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
  color: #ffffff;
  font-size: 20rpx;
  border-radius: 8rpx;
}

.rating-badge {
  position: absolute;
  top: 24rpx;
  right: 24rpx;
  width: 48rpx;
  height: 48rpx;
  border-radius: 12rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 22rpx;
  font-weight: bold;
  color: #ffffff;
  
  &.rating-5 {
    background: linear-gradient(135deg, #10b981 0%, #059669 100%);
  }
  &.rating-4 {
    background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
  }
  &.rating-3 {
    background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
  }
}

.skill-header {
  display: flex;
  align-items: center;
  margin-bottom: 16rpx;
  padding-right: 60rpx;
}

.emoji-wrapper {
  width: 80rpx;
  height: 80rpx;
  background: linear-gradient(135deg, #f3f4f6 0%, #e5e7eb 100%);
  border-radius: 16rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 16rpx;
}

.skill-emoji {
  font-size: 48rpx;
}

.skill-info {
  flex: 1;
}

.skill-name {
  font-size: 32rpx;
  font-weight: bold;
  color: #111827;
}

.skill-meta {
  display: flex;
  gap: 8rpx;
  margin-top: 6rpx;
}

.skill-category-tag {
  font-size: 20rpx;
  color: #667eea;
  background-color: #e0e7ff;
  padding: 4rpx 10rpx;
  border-radius: 6rpx;
}

.skill-source-tag {
  font-size: 20rpx;
  color: #6b7280;
  background-color: #f3f4f6;
  padding: 4rpx 10rpx;
  border-radius: 6rpx;
}

.skill-desc {
  font-size: 26rpx;
  color: #4b5563;
  line-height: 1.5;
  margin-bottom: 16rpx;
}

.skill-features {
  display: flex;
  flex-wrap: wrap;
  gap: 10rpx;
}

.feature-tag {
  padding: 8rpx 14rpx;
  background-color: #f0fdf4;
  color: #166534;
  font-size: 20rpx;
  border-radius: 8rpx;
  border: 1rpx solid #bbf7d0;
}

.skill-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 16rpx;
  margin-top: 16rpx;
  border-top: 1rpx solid #f3f4f6;
}

.star-rating {
  font-size: 18rpx;
}

.view-report-btn {
  display: flex;
  align-items: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 10rpx 20rpx;
  border-radius: 10rpx;
}

.btn-text {
  font-size: 24rpx;
  color: #ffffff;
  font-weight: 500;
}

.btn-arrow {
  font-size: 24rpx;
  color: #ffffff;
  margin-left: 8rpx;
}

// Footer
.footer {
  padding: 48rpx 32rpx;
}

.footer-card {
  display: flex;
  align-items: center;
  background-color: #ffffff;
  border-radius: 16rpx;
  padding: 24rpx;
  margin-bottom: 24rpx;
}

.footer-icon {
  font-size: 48rpx;
  margin-right: 20rpx;
}

.footer-info {
  display: flex;
  flex-direction: column;
}

.footer-title {
  font-size: 28rpx;
  font-weight: 500;
  color: #111827;
}

.footer-desc {
  font-size: 24rpx;
  color: #6b7280;
  margin-top: 4rpx;
}

.footer-links {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-bottom: 16rpx;
}

.footer-link {
  font-size: 26rpx;
  color: #667eea;
}

.footer-divider {
  margin: 0 16rpx;
  color: #d1d5db;
}

.footer-time {
  display: block;
  text-align: center;
  font-size: 22rpx;
  color: #9ca3af;
}
</style>
