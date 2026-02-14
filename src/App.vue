<template>
  <div id="app" :class="{ dark: isDark }">
    <Header />
    <main class="container mx-auto px-4 py-8 max-w-7xl">
      <SearchBar />
      <CategoryFilter />
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mt-8">
        <LinkCard
          v-for="link in filteredLinks"
          :key="link.id"
          :link="link"
          @click="handleLinkClick"
        />
      </div>
    </main>
  </div>
</template>

<script setup>
import { computed, onMounted } from 'vue'
import { useTheme } from './composables/useTheme'
import { useLinks } from './composables/useLinks'
import Header from './components/Header.vue'
import SearchBar from './components/SearchBar.vue'
import CategoryFilter from './components/CategoryFilter.vue'
import LinkCard from './components/LinkCard.vue'

const { isDark } = useTheme()
const { links, searchQuery, selectedCategory, loadClickStats, incrementClickCount } = useLinks()

const filteredLinks = computed(() => {
  let result = links.value

  if (selectedCategory.value) {
    result = result.filter(link => link.categoryId === selectedCategory.value)
  }

  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase()
    result = result.filter(link =>
      link.title.toLowerCase().includes(query) ||
      link.description.toLowerCase().includes(query)
    )
  }

  return result
})

const handleLinkClick = (link) => {
  incrementClickCount(link.id)
  window.open(link.url, '_blank')
}

onMounted(() => {
  loadClickStats()
})
</script>

<style>
html, body, #app {
  min-height: 100%;
}
</style>
