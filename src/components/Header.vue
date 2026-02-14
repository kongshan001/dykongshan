<template>
  <header class="bg-white dark:bg-gray-800 shadow-md transition-colors duration-300">
    <div class="container mx-auto px-4 py-4 max-w-7xl">
      <div class="flex items-center justify-between">
        <div class="flex items-center space-x-3">
          <img src="/vite.svg" alt="Logo" class="w-10 h-10" />
          <div>
            <h1 class="text-2xl font-bold text-gray-900 dark:text-white">{{ siteInfo.title }}</h1>
            <p class="text-sm text-gray-600 dark:text-gray-300">{{ siteInfo.description }}</p>
          </div>
        </div>
        <ThemeToggle />
      </div>
    </div>
  </header>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import ThemeToggle from './ThemeToggle.vue'
import linksData from '../data/links.json'

const siteInfo = ref(linksData.siteInfo || {})
</script>
