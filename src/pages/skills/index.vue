<template>
  <view class="container" :class="{ dark: isDark }">
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
            <text class="stat-value">{{ stats.totalSkills }}</text>
            <text class="stat-label">Skills</text>
          </view>
          <view class="stat-divider"></view>
          <view class="stat-item">
            <text class="stat-value">{{ categoryCount }}</text>
            <text class="stat-label">分类</text>
          </view>
          <view class="stat-divider"></view>
          <view class="stat-item">
            <text class="stat-value">{{ avgRating }}</text>
            <text class="stat-label">均分</text>
          </view>
        </view>
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

    <!-- Category Filter with Icons -->
    <view class="category-filter">
      <scroll-view scroll-x class="category-scroll">
        <view class="category-list">
          <view
            class="category-item"
            :class="{ active: selectedCategory === '' }"
            @click="selectCategory('')"
          >
            <text class="cat-icon">📋</text>
            <text class="cat-name">全部</text>
            <text class="cat-count">{{ skills.length }}</text>
          </view>
          <view
            v-for="(name, id) in categoriesWithIcons"
            :key="id"
            class="category-item"
            :class="{ active: selectedCategory === id }"
            @click="selectCategory(id)"
          >
            <text class="cat-icon">{{ getCategoryIcon(id) }}</text>
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
          @click="setSortBy('rating')"
        >
          按评分
        </text>
        <text
          class="sort-btn"
          :class="{ active: sortBy === 'name' }"
          @click="setSortBy('name')"
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
        :style="{ animationDelay: index * 0.05 + 's' }"
        @click="openReport(skill)"
      >
        <!-- Rating Badge -->
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
            v-for="(feature, idx) in skill.features.slice(0, 4)"
            :key="idx"
            class="feature-tag"
          >
            {{ feature }}
          </text>
          <text v-if="skill.features.length > 4" class="feature-more">
            +{{ skill.features.length - 4 }}
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

    <!-- Empty State -->
    <view v-if="filteredSkills.length === 0" class="empty-state">
      <text class="empty-icon">🔍</text>
      <text class="empty-text">没有找到匹配的 Skills</text>
      <text class="empty-hint">尝试其他搜索词或分类</text>
    </view>

    <!-- Footer -->
    <view class="footer">
      <view class="footer-card">
        <text class="footer-icon">📊</text>
        <view class="footer-info">
          <text class="footer-title">数据来源</text>
          <text class="footer-desc">ClawHub Lab 每小时自动探索更新</text>
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

const isDark = ref(false)
const searchQuery = ref('')
const selectedCategory = ref('')
const sortBy = ref('rating')
const stats = ref(skillsData.stats)
const skills = ref(skillsData.skills)

// Category icons mapping
const categoryIcons = {
  '开发工具': '⚙️',
  '图像视频': '🖼️',
  'AI集成': '🤖',
  '系统安全': '🛡️',
  '智能家居': '🏠'
}

const categories = computed(() => stats.value.categories)

const categoriesWithIcons = computed(() => stats.value.categories)

const categoryCount = computed(() => Object.keys(stats.value.categories).length)

const avgRating = computed(() => {
  const total = skills.value.reduce((sum, s) => sum + s.rating, 0)
  return (total / skills.value.length).toFixed(1)
})

const getCategoryIcon = (categoryId) => {
  return categoryIcons[categoryId] || '📁'
}

const getCategoryCount = (categoryId) => {
  return skills.value.filter(s => s.category === categoryId).length
}

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

const setSortBy = (type) => {
  sortBy.value = type
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

onMounted(() => {
  // 可以添加动态数据加载
})
</script>

<style lang="scss" scoped>
.container {
  min-height: 100vh;
  background-color: #f0f2f5;
  
  &.dark {
    background-color: #111827;
  }
}

// Header with gradient background
.header {
  position: relative;
  padding-bottom: 32rpx;
  overflow: hidden;
}

.header-bg {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 100%;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%);
  
  .dark & {
    background: linear-gradient(135deg, #3730a3 0%, #4c1d95 50%, #701a75 100%);
  }
}

.header-content {
  position: relative;
  z-index: 1;
  padding: 48rpx 32rpx 24rpx;
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

// Search Section
.search-section {
  padding: 24rpx 32rpx;
  margin-top: -16rpx;
}

.search-wrapper {
  display: flex;
  align-items: center;
  background-color: #ffffff;
  border-radius: 16rpx;
  padding: 20rpx 24rpx;
  box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.08);
  
  .dark & {
    background-color: #1f2937;
  }
}

.search-icon {
  font-size: 32rpx;
  margin-right: 16rpx;
}

.search-input {
  flex: 1;
  font-size: 28rpx;
  color: #111827;
  
  .dark & {
    color: #ffffff;
  }
}

.clear-btn {
  padding: 8rpx 16rpx;
  color: #9ca3af;
  font-size: 28rpx;
}

// Category Filter
.category-filter {
  padding: 0 32rpx 24rpx;
}

.category-scroll {
  white-space: nowrap;
}

.category-list {
  display: flex;
  flex-wrap: nowrap;
  gap: 16rpx;
}

.category-item {
  display: inline-flex;
  align-items: center;
  padding: 16rpx 24rpx;
  border-radius: 16rpx;
  background-color: #ffffff;
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.06);
  
  .dark & {
    background-color: #1f2937;
  }
  
  &.active {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    box-shadow: 0 4rpx 12rpx rgba(102, 126, 234, 0.4);
    
    .cat-icon, .cat-name, .cat-count {
      color: #ffffff;
    }
  }
}

.cat-icon {
  font-size: 28rpx;
  margin-right: 8rpx;
}

.cat-name {
  font-size: 26rpx;
  color: #374151;
  
  .dark & {
    color: #d1d5db;
  }
}

.cat-count {
  font-size: 22rpx;
  color: #9ca3af;
  margin-left: 8rpx;
  background-color: #f3f4f6;
  padding: 4rpx 12rpx;
  border-radius: 8rpx;
  
  .dark & {
    background-color: #374151;
  }
}

// Sort Section
.sort-section {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 32rpx 24rpx;
}

.result-count {
  font-size: 26rpx;
  color: #6b7280;
}

.sort-options {
  display: flex;
  gap: 16rpx;
}

.sort-btn {
  font-size: 24rpx;
  color: #9ca3af;
  padding: 8rpx 16rpx;
  border-radius: 8rpx;
  
  &.active {
    color: #667eea;
    background-color: #e0e7ff;
    
    .dark & {
      background-color: #312e81;
    }
  }
}

// Skills List
.skills-list {
  padding: 0 32rpx;
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
  
  .dark & {
    background-color: #1f2937;
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
  font-size: 24rpx;
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
  &.rating-2 {
    background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
  }
}

.skill-header {
  display: flex;
  align-items: center;
  margin-bottom: 20rpx;
}

.emoji-wrapper {
  width: 96rpx;
  height: 96rpx;
  background: linear-gradient(135deg, #f3f4f6 0%, #e5e7eb 100%);
  border-radius: 20rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 20rpx;
  
  .dark & {
    background: linear-gradient(135deg, #374151 0%, #4b5563 100%);
  }
}

.skill-emoji {
  font-size: 56rpx;
}

.skill-info {
  flex: 1;
  padding-right: 60rpx;
}

.skill-name {
  font-size: 34rpx;
  font-weight: bold;
  color: #111827;
  
  .dark & {
    color: #ffffff;
  }
}

.skill-meta {
  display: flex;
  gap: 12rpx;
  margin-top: 8rpx;
}

.skill-category-tag {
  font-size: 22rpx;
  color: #667eea;
  background-color: #e0e7ff;
  padding: 4rpx 12rpx;
  border-radius: 6rpx;
  
  .dark & {
    background-color: #312e81;
  }
}

.skill-source-tag {
  font-size: 22rpx;
  color: #6b7280;
  background-color: #f3f4f6;
  padding: 4rpx 12rpx;
  border-radius: 6rpx;
  
  .dark & {
    background-color: #374151;
  }
}

.skill-desc {
  font-size: 28rpx;
  color: #4b5563;
  line-height: 1.6;
  margin-bottom: 20rpx;
  
  .dark & {
    color: #9ca3af;
  }
}

.skill-features {
  display: flex;
  flex-wrap: wrap;
  gap: 12rpx;
  margin-bottom: 24rpx;
}

.feature-tag {
  padding: 10rpx 18rpx;
  background-color: #f0fdf4;
  color: #166534;
  font-size: 22rpx;
  border-radius: 10rpx;
  border: 1rpx solid #bbf7d0;
  
  .dark & {
    background-color: #14532d;
    color: #86efac;
    border-color: #166534;
  }
}

.feature-more {
  padding: 10rpx 18rpx;
  background-color: #f3f4f6;
  color: #6b7280;
  font-size: 22rpx;
  border-radius: 10rpx;
}

.skill-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 20rpx;
  border-top: 1rpx solid #f3f4f6;
  
  .dark & {
    border-top-color: #374151;
  }
}

.star-rating {
  font-size: 20rpx;
}

.view-report-btn {
  display: flex;
  align-items: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 12rpx 24rpx;
  border-radius: 12rpx;
}

.btn-text {
  font-size: 26rpx;
  color: #ffffff;
  font-weight: 500;
}

.btn-arrow {
  font-size: 26rpx;
  color: #ffffff;
  margin-left: 8rpx;
}

// Empty State
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 80rpx 32rpx;
}

.empty-icon {
  font-size: 80rpx;
  margin-bottom: 24rpx;
}

.empty-text {
  font-size: 32rpx;
  color: #374151;
  font-weight: 500;
  
  .dark & {
    color: #d1d5db;
  }
}

.empty-hint {
  font-size: 26rpx;
  color: #9ca3af;
  margin-top: 12rpx;
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
  
  .dark & {
    background-color: #1f2937;
  }
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
  
  .dark & {
    color: #ffffff;
  }
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
