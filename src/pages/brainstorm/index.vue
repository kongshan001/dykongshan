<template>
  <view class="container">
    <!-- Header -->
    <view class="header">
      <view class="header-bg"></view>
      <view class="header-content">
        <view class="logo-row">
          <text class="logo-emoji">🧠</text>
          <view class="title-group">
            <text class="page-title">头脑风暴</text>
            <text class="page-desc">捕捉每一个灵感闪念</text>
          </view>
        </view>
        
        <!-- Quick Stats -->
        <view class="quick-stats">
          <view class="stat-item">
            <text class="stat-value">{{ stats.total }}</text>
            <text class="stat-label">想法</text>
          </view>
          <view class="stat-divider"></view>
          <view class="stat-item">
            <text class="stat-value">{{ stats.completed }}</text>
            <text class="stat-label">已实现</text>
          </view>
          <view class="stat-divider"></view>
          <view class="stat-item">
            <text class="stat-value">{{ stats.inProgress }}</text>
            <text class="stat-label">进行中</text>
          </view>
        </view>
      </view>
    </view>

    <!-- Status Filter -->
    <view class="status-filter">
      <view
        class="status-item"
        :class="{ active: selectedStatus === '' }"
        @click="selectStatus('')"
      >
        <text>全部</text>
      </view>
      <view
        class="status-item"
        :class="{ active: selectedStatus === 'idea' }"
        @click="selectStatus('idea')"
      >
        <text>💡 想法</text>
      </view>
      <view
        class="status-item"
        :class="{ active: selectedStatus === 'inProgress' }"
        @click="selectStatus('inProgress')"
      >
        <text>🚧 进行中</text>
      </view>
      <view
        class="status-item"
        :class="{ active: selectedStatus === 'completed' }"
        @click="selectStatus('completed')"
      >
        <text>✅ 已实现</text>
      </view>
    </view>

    <!-- Ideas List -->
    <view class="ideas-list">
      <view
        v-for="idea in filteredIdeas"
        :key="idea.id"
        class="idea-card"
        @click="openIdea(idea)"
      >
        <view class="idea-header">
          <text class="idea-status">{{ idea.statusEmoji }}</text>
          <view class="idea-info">
            <text class="idea-title">{{ idea.title }}</text>
            <text class="idea-date">{{ idea.date }}</text>
          </view>
        </view>
        
        <text class="idea-summary">{{ idea.summary }}</text>
        
        <view class="idea-tags">
          <text
            v-for="tag in idea.tags.slice(0, 3)"
            :key="tag"
            class="tag"
          >
            #{{ tag }}
          </text>
        </view>
      </view>
    </view>

    <!-- Empty State -->
    <view v-if="ideas.length === 0" class="empty-state">
      <text class="empty-icon">💭</text>
      <text class="empty-title">还没有记录想法</text>
      <text class="empty-desc">随时告诉我你的灵感，我会帮你记录</text>
    </view>

    <!-- Add Button -->
    <view class="add-hint">
      <text class="hint-icon">💡</text>
      <text class="hint-text">直接发送消息给我，即可记录新想法</text>
    </view>

    <!-- Footer -->
    <view class="footer">
      <text class="footer-link" @click="openGitHub">📦 查看 GitHub 仓库</text>
      <text class="footer-time">最后更新: {{ stats.lastUpdated }}</text>
    </view>
  </view>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'

const selectedStatus = ref('')
const stats = ref({
  total: 1,
  completed: 1,
  inProgress: 0,
  abandoned: 0,
  lastUpdated: '2026-03-01'
})

const ideas = ref([
  {
    id: 'clawhub-lab',
    title: 'ClawHub Lab 自动探索系统',
    date: '2026-02-28',
    status: 'completed',
    statusEmoji: '✅',
    tags: ['AI', '自动化', 'Skills'],
    summary: '定时任务自动探索 ClawHub Skills，生成分析报告并展示在主页',
    url: 'https://github.com/kongshan001/brainstorm/blob/main/ideas/2026-02-28-clawhub-lab.md'
  }
])

const filteredIdeas = computed(() => {
  if (!selectedStatus.value) return ideas.value
  return ideas.value.filter(i => i.status === selectedStatus.value)
})

const selectStatus = (status) => {
  selectedStatus.value = status
}

const openIdea = (idea) => {
  // #ifdef H5
  window.open(idea.url, '_blank')
  // #endif
  // #ifdef MP-WEIXIN
  uni.setClipboardData({
    data: idea.url,
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
  window.open('https://github.com/kongshan001/brainstorm', '_blank')
  // #endif
}

// 从 GitHub raw 加载数据
onMounted(async () => {
  try {
    const res = await fetch('https://raw.githubusercontent.com/kongshan001/brainstorm/main/data.json')
    if (res.ok) {
      const data = await res.json()
      stats.value = data.stats
      ideas.value = data.ideas
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
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
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
}

.title-group {
  display: flex;
  flex-direction: column;
}

.page-title {
  font-size: 44rpx;
  font-weight: bold;
  color: #ffffff;
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
  background: rgba(255, 255, 255, 0.2);
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

.status-filter {
  display: flex;
  padding: 24rpx 32rpx;
  gap: 16rpx;
  overflow-x: auto;
}

.status-item {
  flex-shrink: 0;
  padding: 16rpx 28rpx;
  background-color: #ffffff;
  border-radius: 16rpx;
  font-size: 26rpx;
  color: #374151;
  
  &.active {
    background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
    color: #ffffff;
  }
}

.ideas-list {
  padding: 0 32rpx;
}

.idea-card {
  background-color: #ffffff;
  border-radius: 20rpx;
  padding: 32rpx;
  margin-bottom: 24rpx;
  box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.06);
}

.idea-header {
  display: flex;
  align-items: center;
  margin-bottom: 16rpx;
}

.idea-status {
  font-size: 48rpx;
  margin-right: 16rpx;
}

.idea-info {
  flex: 1;
}

.idea-title {
  font-size: 32rpx;
  font-weight: bold;
  color: #111827;
}

.idea-date {
  font-size: 22rpx;
  color: #9ca3af;
  margin-top: 4rpx;
}

.idea-summary {
  font-size: 28rpx;
  color: #4b5563;
  line-height: 1.6;
  margin-bottom: 16rpx;
}

.idea-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 12rpx;
}

.tag {
  font-size: 22rpx;
  color: #f5576c;
  background-color: #fef2f2;
  padding: 6rpx 14rpx;
  border-radius: 8rpx;
}

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

.empty-title {
  font-size: 32rpx;
  font-weight: 500;
  color: #374151;
}

.empty-desc {
  font-size: 26rpx;
  color: #9ca3af;
  margin-top: 12rpx;
}

.add-hint {
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
  margin: 24rpx 32rpx;
  padding: 24rpx;
  border-radius: 16rpx;
}

.hint-icon {
  font-size: 36rpx;
  margin-right: 16rpx;
}

.hint-text {
  font-size: 26rpx;
  color: #92400e;
}

.footer {
  padding: 48rpx 32rpx;
  text-align: center;
}

.footer-link {
  font-size: 28rpx;
  color: #f5576c;
  font-weight: 500;
}

.footer-time {
  display: block;
  font-size: 22rpx;
  color: #9ca3af;
  margin-top: 16rpx;
}
</style>
