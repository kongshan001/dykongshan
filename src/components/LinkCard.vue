<template>
  <a
    :href="link.url"
    target="_blank"
    rel="noopener noreferrer"
    class="block bg-white dark:bg-gray-800 rounded-lg shadow-md hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1 overflow-hidden border border-gray-200 dark:border-gray-700"
    @click.prevent="handleClick"
  >
    <div class="p-6">
      <div class="flex items-start justify-between">
        <div class="flex items-center space-x-3">
          <span class="text-4xl">{{ link.icon }}</span>
          <div>
            <h3 class="text-xl font-bold text-gray-900 dark:text-white">{{ link.title }}</h3>
            <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">{{ link.description }}</p>
          </div>
        </div>
      </div>
      <div class="mt-4 flex items-center justify-between text-sm text-gray-500 dark:text-gray-400">
        <span class="flex items-center space-x-1">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="h-4 w-4"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"
            />
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"
            />
          </svg>
          <span>{{ link.clickCount || 0 }} 次点击</span>
        </span>
        <span class="flex items-center space-x-1 text-primary-500 hover:text-primary-600">
          <span>访问</span>
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="h-4 w-4"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"
            />
          </svg>
        </span>
      </div>
    </div>
  </a>
</template>

<script setup>
const props = defineProps({
  link: {
    type: Object,
    required: true
  }
})

const emit = defineEmits(['click'])

const handleClick = () => {
  emit('click', props.link)
}
</script>
