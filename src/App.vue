<template>
  <view id="app">
    <router-view />
  </view>
</template>

<script setup>
import { onLaunch, onShow, onHide } from '@dcloudio/uni-app'

onLaunch(() => {
  console.log('App Launch')
})

onShow(() => {
  console.log('App Show')
})

onHide(() => {
  console.log('App Hide')
})
</script>

<style>
page {
  min-height: 100%;
  background-color: #f8f9fa;
}
</style>
