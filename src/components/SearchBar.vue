<template>
  <div class="relative">
    <input
      :value="linksStore.searchQuery"
      @input="handleSearchInput"
      type="text"
      placeholder="搜索子域名..."
      class="w-full px-4 py-3 pl-12 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-transparent transition-all duration-200"
    />
    <svg
      xmlns="http://www.w3.org/2000/svg"
      class="h-5 w-5 absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400"
      fill="none"
      viewBox="0 0 24 24"
      stroke="currentColor"
    >
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"
      />
    </svg>
    <button
      v-if="linksStore.searchQuery"
      @click="clearSearch"
      class="absolute right-4 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-gray-600 dark:hover:text-gray-200"
    >
      <svg
        xmlns="http://www.w3.org/2000/svg"
        class="h-5 w-5"
        fill="none"
        viewBox="0 0 24 24"
        stroke="currentColor"
      >
        <path
          stroke-linecap="round"
          stroke-linejoin="round"
          stroke-width="2"
          d="M6 18L18 6M6 6l12 12"
        />
      </svg>
    </button>
  </div>
</template>

<script setup>
import { useLinksStore } from '../stores/links'

const linksStore = useLinksStore()

const handleSearchInput = (e) => {
  linksStore.setSearchQuery(e.target.value)
}

const clearSearch = () => {
  linksStore.setSearchQuery('')
}
</script>
