<template>
  <div class="fixed inset-0 bg-black/60 flex items-center justify-center z-[1000]" @click.self="$emit('close')">
    <div class="bg-white p-8 rounded-[10px] max-w-[800px] w-full h-auto overflow-y-auto max-[758px]:h-[70%]">
      <slot />
    </div>
  </div>
</template>

<script setup>
import { onMounted, onUnmounted } from 'vue'

defineEmits(['close'])

onMounted(() => {
  document.body.style.overflow = 'hidden'
})

onUnmounted(() => {
  document.body.style.overflow = ''
})
</script>
