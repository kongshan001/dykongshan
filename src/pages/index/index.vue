<template>
  <view class="container" :class="{ dark: isDark }">
    <view class="header">
      <view class="header-content">
        <view class="logo-wrapper">
          <image class="logo" src="/static/vite.svg" mode="aspectFit" />
          <view class="site-info">
            <text class="site-title">{{ siteInfo.title }}</text>
            <text class="site-desc">{{ siteInfo.description }}</text>
          </view>
        </view>
      </view>
    </view>

    <view class="main">
      <view class="search-bar">
        <view class="search-wrapper">
          <text class="search-icon">🔍</text>
          <input
            class="search-input"
            :value="linksStore.searchQuery"
            @input="handleSearchInput"
            type="text"
            placeholder="搜索子域名..."
          />
          <text v-if="linksStore.searchQuery" class="clear-btn" @click="clearSearch">✕</text>
        </view>
      </view>

      <view class="category-filter">
        <scroll-view scroll-x class="category-scroll">
          <view class="category-list">
            <view
              class="category-item"
              :class="{ active: linksStore.selectedCategory === '' }"
              @click="selectCategory('')"
            >
              <text>全部</text>
            </view>
            <view
              v-for="category in categories"
              :key="category.id"
              class="category-item"
              :class="{ active: linksStore.selectedCategory === category.id }"
              @click="selectCategory(category.id)"
            >
              <text>{{ category.icon }} {{ category.name }}</text>
            </view>
          </view>
        </scroll-view>
      </view>

      <view class="links-grid">
        <view
          v-for="link in filteredLinks"
          :key="link.id"
          class="link-card"
          @click="handleLinkClick(link)"
        >
          <view class="card-content">
            <view class="card-header">
              <text class="link-icon">{{ link.icon }}</text>
              <view class="link-info">
                <text class="link-title">{{ link.title }}</text>
                <text class="link-desc">{{ link.description }}</text>
              </view>
            </view>
            <view class="card-footer">
              <text class="click-count">{{ link.clickCount || 0 }} 次点击</text>
              <text class="visit-btn">访问 →</text>
            </view>
          </view>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useLinksStore } from '@/stores/links'
import linksData from '@/data/links.json'

const linksStore = useLinksStore()
const isDark = ref(false)
const siteInfo = ref(linksData.siteInfo || {})
const categories = ref([])

const filteredLinks = computed(() => linksStore.filteredLinks())

const handleSearchInput = (e) => {
  linksStore.setSearchQuery(e.detail.value)
}

const clearSearch = () => {
  linksStore.setSearchQuery('')
}

const selectCategory = (categoryId) => {
  linksStore.setSelectedCategory(categoryId)
}

const handleLinkClick = (link) => {
  linksStore.incrementClickCount(link.id)
  
  // 处理内部页面链接
  if (link.isInternal && link.url.startsWith('/pages/')) {
    // #ifdef H5
    uni.navigateTo({
      url: link.url
    })
    // #endif
    // #ifdef MP-WEIXIN
    uni.navigateTo({
      url: link.url
    })
    // #endif
    return
  }
  
  // #ifdef H5
  window.open(link.url, '_blank')
  // #endif
  // #ifdef MP-WEIXIN
  uni.setClipboardData({
    data: link.url,
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
  categories.value = linksData.categories || []
  linksStore.loadClickStats()
  linksStore.fetchGitHubRepos()
})
</script>

<style lang="scss" scoped>
// 渐变背景动画
@keyframes gradient-shift {
  0% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
  100% { background-position: 0% 50%; }
}

@keyframes float {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-8rpx); }
}

.container {
  min-height: 100vh;
  // 渐变背景
  background: linear-gradient(-45deg, #ee7752, #e73c7e, #23a6d5, #23d5ab);
  background-size: 400% 400%;
  animation: gradient-shift 15s ease infinite;
  
  &.dark {
    background: linear-gradient(-45deg, #1a1a2e, #16213e, #0f3460, #1f4068);
    background-size: 400% 400%;
    animation: gradient-shift 15s ease infinite;
  }
}

.header {
  // 毛玻璃效果
  background: rgba(255, 255, 255, 0.15);
  backdrop-filter: blur(20rpx);
  -webkit-backdrop-filter: blur(20rpx);
  border-bottom: 1rpx solid rgba(255, 255, 255, 0.2);
  box-shadow: 0 8rpx 32rpx rgba(0, 0, 0, 0.1);
  
  .dark & {
    background: rgba(0, 0, 0, 0.3);
    border-bottom: 1rpx solid rgba(255, 255, 255, 0.1);
  }
}

.header-content {
  padding: 40rpx 32rpx;
}

.logo-wrapper {
  display: flex;
  align-items: center;
}

.logo {
  width: 96rpx;
  height: 96rpx;
  margin-right: 24rpx;
  border-radius: 24rpx;
  box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.15);
}

.site-info {
  display: flex;
  flex-direction: column;
}

.site-title {
  font-size: 48rpx;
  font-weight: 800;
  color: #ffffff;
  text-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.2);
  letter-spacing: 2rpx;
  
  .dark & {
    color: #ffffff;
  }
}

.site-desc {
  font-size: 26rpx;
  color: rgba(255, 255, 255, 0.85);
  margin-top: 8rpx;
  
  .dark & {
    color: rgba(255, 255, 255, 0.7);
  }
}

.main {
  padding: 32rpx;
}

.search-bar {
  margin-bottom: 32rpx;
}

.search-wrapper {
  position: relative;
  display: flex;
  align-items: center;
  // 毛玻璃搜索框
  background: rgba(255, 255, 255, 0.25);
  backdrop-filter: blur(20rpx);
  -webkit-backdrop-filter: blur(20rpx);
  border: 1rpx solid rgba(255, 255, 255, 0.3);
  border-radius: 24rpx;
  padding: 28rpx 32rpx;
  box-shadow: 0 8rpx 32rpx rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
  
  &:active, &:focus-within {
    background: rgba(255, 255, 255, 0.35);
    transform: scale(1.02);
    box-shadow: 0 12rpx 40rpx rgba(0, 0, 0, 0.15);
  }
  
  .dark & {
    background: rgba(0, 0, 0, 0.25);
    border-color: rgba(255, 255, 255, 0.15);
  }
}

.search-icon {
  margin-right: 20rpx;
  font-size: 36rpx;
}

.search-input {
  flex: 1;
  font-size: 30rpx;
  color: #ffffff;
  background: transparent;
  
  &::placeholder {
    color: rgba(255, 255, 255, 0.7);
  }
  
  .dark & {
    color: #ffffff;
  }
}

.clear-btn {
  padding: 12rpx 20rpx;
  color: rgba(255, 255, 255, 0.8);
  font-size: 32rpx;
  transition: color 0.2s;
  
  &:active {
    color: #ffffff;
  }
}

.category-filter {
  margin-bottom: 32rpx;
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
  align-items: center;
  padding: 20rpx 32rpx;
  margin-right: 16rpx;
  border-radius: 50rpx;
  // 毛玻璃胶囊
  background: rgba(255, 255, 255, 0.2);
  backdrop-filter: blur(10rpx);
  -webkit-backdrop-filter: blur(10rpx);
  border: 1rpx solid rgba(255, 255, 255, 0.2);
  font-size: 26rpx;
  color: rgba(255, 255, 255, 0.9);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  white-space: nowrap;
  
  .dark & {
    background: rgba(0, 0, 0, 0.25);
    border-color: rgba(255, 255, 255, 0.1);
    color: rgba(255, 255, 255, 0.8);
  }
  
  &:active {
    transform: scale(0.95);
  }
  
  &.active {
    background: rgba(255, 255, 255, 0.95);
    color: #e73c7e;
    border-color: rgba(255, 255, 255, 0.5);
    box-shadow: 0 8rpx 24rpx rgba(231, 60, 126, 0.3);
    font-weight: 600;
    
    .dark & {
      background: #ffffff;
      color: #e73c7e;
    }
  }
}

.links-grid {
  display: flex;
  flex-wrap: wrap;
  gap: 24rpx;
}

.link-card {
  width: calc(50% - 12rpx);
  // 毛玻璃卡片
  background: rgba(255, 255, 255, 0.2);
  backdrop-filter: blur(20rpx);
  -webkit-backdrop-filter: blur(20rpx);
  border: 1rpx solid rgba(255, 255, 255, 0.25);
  border-radius: 24rpx;
  overflow: hidden;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 8rpx 32rpx rgba(0, 0, 0, 0.1);
  
  &:active {
    transform: scale(0.98);
  }
  
  &:hover {
    transform: translateY(-8rpx);
    box-shadow: 0 16rpx 48rpx rgba(0, 0, 0, 0.2);
    background: rgba(255, 255, 255, 0.3);
  }
  
  .dark & {
    background: rgba(0, 0, 0, 0.3);
    border-color: rgba(255, 255, 255, 0.1);
    
    &:hover {
      background: rgba(0, 0, 0, 0.4);
    }
  }
}

.card-content {
  padding: 32rpx;
}

.card-header {
  display: flex;
  align-items: flex-start;
  margin-bottom: 20rpx;
}

.link-icon {
  font-size: 64rpx;
  margin-right: 16rpx;
  animation: float 3s ease-in-out infinite;
}

.link-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  min-width: 0;
}

.link-title {
  font-size: 30rpx;
  font-weight: 700;
  color: #ffffff;
  text-shadow: 0 1rpx 4rpx rgba(0, 0, 0, 0.15);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  
  .dark & {
    color: #ffffff;
  }
}

.link-desc {
  font-size: 24rpx;
  color: rgba(255, 255, 255, 0.8);
  margin-top: 8rpx;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  line-height: 1.4;
  
  .dark & {
    color: rgba(255, 255, 255, 0.7);
  }
}

.card-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 22rpx;
  color: rgba(255, 255, 255, 0.7);
  margin-top: 16rpx;
  padding-top: 16rpx;
  border-top: 1rpx solid rgba(255, 255, 255, 0.15);
}

.visit-btn {
  color: #ffffff;
  font-weight: 600;
  background: rgba(255, 255, 255, 0.25);
  padding: 8rpx 20rpx;
  border-radius: 50rpx;
  transition: all 0.3s;
  
  &:active {
    transform: scale(0.9);
    background: rgba(255, 255, 255, 0.4);
  }
}
</style>
