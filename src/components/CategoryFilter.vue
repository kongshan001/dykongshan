<template>
  <div class="flex flex-wrap gap-2 mt-6">
    <button
      @click="selectCategory('')"
      :class="[
        'px-4 py-2 rounded-lg font-medium transition-all duration-200',
        selectedCategory === ''
          ? 'bg-primary-500 text-white shadow-lg'
          : 'bg-gray-200 dark:bg-gray-700 text-gray-700 dark:text-gray-300 hover:bg-gray-300 dark:hover:bg-gray-600'
      ]"
    >
      全部
    </button>
    <button
      v-for="category in categories"
      :key="category.id"
      @click="selectCategory(category.id)"
      :class="[
        'px-4 py-2 rounded-lg font-medium transition-all duration-200 flex items-center space-x-2',
        selectedCategory === category.id
          ? 'bg-primary-500 text-white shadow-lg'
          : 'bg-gray-200 dark:bg-gray-700 text-gray-700 dark:text-gray-300 hover:bg-gray-300 dark:hover:bg-gray-600'
      ]"
    >
      <span>{{ category.icon }}</span>
      <span>{{ category.name }}</span>
    </button>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useLinks } from '../composables/useLinks'
import linksData from '../data/links.json'

const categories = ref([])
const { selectedCategory } = useLinks()

onMounted(() => {
  categories.value = linksData.categories || []
})

const selectCategory = (categoryId) => {
  selectedCategory.value = categoryId
}
</script>
