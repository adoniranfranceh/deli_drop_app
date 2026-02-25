<script setup>
import { ref, computed } from 'vue'
import { Icon } from '@iconify/vue'
import AppButton from './AppButton.vue'

const props = defineProps({
  type: { type: String, required: true },
  message: { type: String, required: true }
})

const visible = ref(true)
const close = () => {
  visible.value = false
}

const flashClasses = computed(() => {
  const base = 'flex items-center gap-3 py-3 px-4 rounded-xl text-[0.95rem] font-medium shadow-lg animate-fade-in'
  const types = {
    success: 'bg-success text-white',
    error: 'bg-error text-white'
  }
  return `${base} ${types[props.type] || types.error}`
})
</script>

<template>
  <div v-if="visible" class="w-full flex justify-center fixed top-4 z-[9999]">
    <div :class="flashClasses">
      <span class="text-xl">
        <Icon v-if="type === 'success'" icon="fa6-solid:check" />
        <Icon v-else icon="lucide:triangle-alert" />
      </span>
      <span>{{ message }}</span>

      <AppButton
        icon="fa6-solid:xmark"
        variant="ghost"
        @click="close"
      />
    </div>
  </div>
</template>
