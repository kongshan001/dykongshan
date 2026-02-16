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
  uni.setClipboardData({
    data: link.url,
    success: () => {
      uni.showToast({
        title: '链接已复制',
        icon: 'success'
      })
    }
  })
}

onMounted(() => {
  categories.value = linksData.categories || []
  linksStore.loadClickStats()
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
  background-color: #ffffff;
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.1);
  
  .dark & {
    background-color: #374151;
  }
}

.header-content {
  padding: 32rpx;
}

.logo-wrapper {
  display: flex;
  align-items: center;
}

.logo {
  width: 80rpx;
  height: 80rpx;
  margin-right: 24rpx;
}

.site-info {
  display: flex;
  flex-direction: column;
}

.site-title {
  font-size: 40rpx;
  font-weight: bold;
  color: #111827;
  
  .dark & {
    color: #ffffff;
  }
}

.site-desc {
  font-size: 24rpx;
  color: #6b7280;
  
  .dark & {
    color: #d1d5db;
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
  background-color: #ffffff;
  border: 2rpx solid #e5e7eb;
  border-radius: 16rpx;
  padding: 24rpx;
  
  .dark & {
    background-color: #374151;
    border-color: #4b5563;
  }
}

.search-icon {
  margin-right: 16rpx;
  font-size: 32rpx;
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
  padding: 16rpx 32rpx;
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
    background-color: #3b82f6;
    color: #ffffff;
  }
}

.links-grid {
  display: flex;
  flex-wrap: wrap;
  gap: 24rpx;
}

.link-card {
  width: calc(50% - 12rpx);
  background-color: #ffffff;
  border-radius: 16rpx;
  box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.08);
  overflow: hidden;
  
  .dark & {
    background-color: #374151;
  }
}

.card-content {
  padding: 32rpx;
}

.card-header {
  display: flex;
  align-items: flex-start;
  margin-bottom: 24rpx;
}

.link-icon {
  font-size: 56rpx;
  margin-right: 16rpx;
}

.link-info {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.link-title {
  font-size: 30rpx;
  font-weight: bold;
  color: #111827;
  
  .dark & {
    color: #ffffff;
  }
}

.link-desc {
  font-size: 24rpx;
  color: #6b7280;
  margin-top: 8rpx;
  
  .dark & {
    color: #9ca3af;
  }
}

.card-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 24rpx;
  color: #9ca3af;
}

.visit-btn {
  color: #3b82f6;
}
</style>
