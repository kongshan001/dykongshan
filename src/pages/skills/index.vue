<template>
  <view class="container" :class="{ dark: isDark }">
    <!-- Header -->
    <view class="header">
      <view class="header-content">
        <text class="page-title">🔺 ClawHub Skills 实验室</text>
        <text class="page-desc">AI Skills 深度分析报告</text>
      </view>
    </view>

    <!-- Stats Cards -->
    <view class="stats-section">
      <view class="stats-grid">
        <view class="stat-card">
          <text class="stat-number">{{ stats.totalSkills }}</text>
          <text class="stat-label">已分析 Skills</text>
        </view>
        <view class="stat-card">
          <text class="stat-number">{{ categoryCount }}</text>
          <text class="stat-label">分类</text>
        </view>
        <view class="stat-card">
          <text class="stat-number">{{ avgRating }}</text>
          <text class="stat-label">平均评分</text>
        </view>
      </view>
    </view>

    <!-- Category Filter -->
    <view class="category-filter">
      <scroll-view scroll-x class="category-scroll">
        <view class="category-list">
          <view
            class="category-item"
            :class="{ active: selectedCategory === '' }"
            @click="selectCategory('')"
          >
            <text>全部</text>
          </view>
          <view
            v-for="(name, id) in categories"
            :key="id"
            class="category-item"
            :class="{ active: selectedCategory === id }"
            @click="selectCategory(id)"
          >
            <text>{{ name }}</text>
          </view>
        </view>
      </scroll-view>
    </view>

    <!-- Skills List -->
    <view class="skills-list">
      <view
        v-for="skill in filteredSkills"
        :key="skill.id"
        class="skill-card"
        @click="openReport(skill)"
      >
        <view class="skill-header">
          <text class="skill-emoji">{{ skill.emoji }}</text>
          <view class="skill-info">
            <view class="skill-title-row">
              <text class="skill-name">{{ skill.name }}</text>
              <text class="skill-rating">{{ '⭐'.repeat(skill.rating) }}</text>
            </view>
            <text class="skill-category">{{ skill.category }}</text>
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
          <text class="skill-source">{{ skill.source }}</text>
          <text class="view-report">查看报告 →</text>
        </view>
      </view>
    </view>

    <!-- Footer -->
    <view class="footer">
      <text class="footer-text">📊 数据来源: ClawHub Lab 每小时自动探索</text>
      <text class="footer-text">🔗 github.com/kongshan001/clawhub-lab</text>
    </view>
  </view>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import skillsData from '@/data/skills.json'

const isDark = ref(false)
const selectedCategory = ref('')
const stats = ref(skillsData.stats)
const skills = ref(skillsData.skills)

const categories = computed(() => stats.value.categories)

const categoryCount = computed(() => Object.keys(stats.value.categories).length)

const avgRating = computed(() => {
  const total = skills.value.reduce((sum, s) => sum + s.rating, 0)
  return (total / skills.value.length).toFixed(1)
})

const filteredSkills = computed(() => {
  if (!selectedCategory.value) return skills.value
  return skills.value.filter(s => s.category === selectedCategory.value)
})

const selectCategory = (categoryId) => {
  selectedCategory.value = categoryId
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

onMounted(() => {
  // 可以在这里添加从 GitHub API 动态获取数据的逻辑
})
</script>

<style lang="scss" scoped>
.container {
  min-height: 100vh;
  background-color: #f8f9fa;
  
  &.dark {
    background-color: #1f2937;
  }
}

.header {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 48rpx 32rpx;
  
  .dark & {
    background: linear-gradient(135deg, #3730a3 0%, #4c1d95 100%);
  }
}

.header-content {
  display: flex;
  flex-direction: column;
}

.page-title {
  font-size: 44rpx;
  font-weight: bold;
  color: #ffffff;
  margin-bottom: 12rpx;
}

.page-desc {
  font-size: 28rpx;
  color: rgba(255, 255, 255, 0.8);
}

.stats-section {
  padding: 32rpx;
  margin-top: -24rpx;
}

.stats-grid {
  display: flex;
  gap: 20rpx;
}

.stat-card {
  flex: 1;
  background-color: #ffffff;
  border-radius: 16rpx;
  padding: 32rpx 24rpx;
  text-align: center;
  box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.08);
  
  .dark & {
    background-color: #374151;
  }
}

.stat-number {
  display: block;
  font-size: 48rpx;
  font-weight: bold;
  color: #667eea;
  
  .dark & {
    color: #818cf8;
  }
}

.stat-label {
  display: block;
  font-size: 24rpx;
  color: #6b7280;
  margin-top: 8rpx;
  
  .dark & {
    color: #9ca3af;
  }
}

.category-filter {
  padding: 0 32rpx;
  margin-bottom: 24rpx;
}

.category-scroll {
  white-space: nowrap;
}

.category-list {
  display: flex;
  flex-wrap: nowrap;
}

.category-item {
  display: inline-flex;
  padding: 16rpx 28rpx;
  margin-right: 16rpx;
  border-radius: 12rpx;
  background-color: #e5e7eb;
  font-size: 26rpx;
  color: #374151;
  
  .dark & {
    background-color: #4b5563;
    color: #d1d5db;
  }
  
  &.active {
    background-color: #667eea;
    color: #ffffff;
  }
}

.skills-list {
  padding: 0 32rpx;
}

.skill-card {
  background-color: #ffffff;
  border-radius: 16rpx;
  padding: 32rpx;
  margin-bottom: 24rpx;
  box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.08);
  
  .dark & {
    background-color: #374151;
  }
}

.skill-header {
  display: flex;
  align-items: center;
  margin-bottom: 20rpx;
}

.skill-emoji {
  font-size: 64rpx;
  margin-right: 20rpx;
}

.skill-info {
  flex: 1;
}

.skill-title-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.skill-name {
  font-size: 32rpx;
  font-weight: bold;
  color: #111827;
  
  .dark & {
    color: #ffffff;
  }
}

.skill-rating {
  font-size: 20rpx;
}

.skill-category {
  font-size: 24rpx;
  color: #6b7280;
  margin-top: 8rpx;
  
  .dark & {
    color: #9ca3af;
  }
}

.skill-desc {
  font-size: 28rpx;
  color: #374151;
  line-height: 1.6;
  margin-bottom: 20rpx;
  
  .dark & {
    color: #d1d5db;
  }
}

.skill-features {
  display: flex;
  flex-wrap: wrap;
  gap: 12rpx;
  margin-bottom: 20rpx;
}

.feature-tag {
  padding: 8rpx 16rpx;
  background-color: #e0e7ff;
  color: #4338ca;
  font-size: 22rpx;
  border-radius: 8rpx;
  
  .dark & {
    background-color: #312e81;
    color: #a5b4fc;
  }
}

.skill-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 20rpx;
  border-top: 1rpx solid #e5e7eb;
  
  .dark & {
    border-top-color: #4b5563;
  }
}

.skill-source {
  font-size: 22rpx;
  color: #9ca3af;
}

.view-report {
  font-size: 26rpx;
  color: #667eea;
  font-weight: 500;
}

.footer {
  padding: 48rpx 32rpx;
  text-align: center;
}

.footer-text {
  display: block;
  font-size: 24rpx;
  color: #9ca3af;
  margin-bottom: 12rpx;
}
</style>
