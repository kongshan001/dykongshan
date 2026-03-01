<template>
  <view class="container" :class="{ dark: isDark }">
    <view class="header">
      <view class="back-btn" @click="goBack">← 返回</view>
      <text class="title">📚 文档中心</text>
      <text class="subtitle">DY Kongshan 调研报告与技术文档</text>
    </view>
    <view class="content">
      <view class="doc-list">
        <view class="doc-card" @click="openDoc('ai-coding/opencode-vs-claude-code.html')">
          <text class="doc-icon">🔬</text>
          <view class="doc-info">
            <text class="doc-title">OpenCode vs Claude Code 对比分析</text>
            <text class="doc-desc">AI 编程工具功能对比、优缺点分析</text>
          </view>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref } from 'vue'

const isDark = ref(false)

const goBack = () => {
  uni.navigateBack()
}

const openDoc = (path) => {
  // 跳转到 WebView 显示 HTML
  const url = `/pages/webview/index?url=${encodeURIComponent('/static/research/' + path)}`
  uni.navigateTo({ url })
}
</script>

<style lang="scss" scoped>
.container {
  min-height: 100vh;
  background: #f8f9fa;
}
.header {
  background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
  color: white;
  padding: 40rpx;
  text-align: center;
}
.back-btn {
  font-size: 28rpx;
  opacity: 0.9;
  margin-bottom: 20rpx;
}
.title {
  font-size: 40rpx;
  font-weight: bold;
  display: block;
}
.subtitle {
  font-size: 28rpx;
  opacity: 0.9;
  margin-top: 10rpx;
  display: block;
}
.content {
  padding: 32rpx;
}
.doc-list {
  display: flex;
  flex-direction: column;
  gap: 20rpx;
}
.doc-card {
  display: flex;
  align-items: center;
  padding: 24rpx;
  background: white;
  border-radius: 16rpx;
  box-shadow: 0 4rpx 12rpx rgba(0,0,0,0.08);
}
.doc-icon {
  font-size: 56rpx;
  margin-right: 20rpx;
}
.doc-info {
  flex: 1;
}
.doc-title {
  font-size: 30rpx;
  font-weight: bold;
  color: #333;
  display: block;
}
.doc-desc {
  font-size: 24rpx;
  color: #666;
  margin-top: 8rpx;
  display: block;
}
</style>
