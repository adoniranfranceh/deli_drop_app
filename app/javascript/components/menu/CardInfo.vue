<template>
  <div class="flex flex-col items-center bg-white rounded-lg py-8 max-[1000px]:py-4 flex-1 border border-border">
    <Icon :icon="icon" :style="{ color }" width="64" height="64" class="max-[1000px]:!w-12 max-[1000px]:!h-12" />
    <div class="flex flex-col items-center">
      <p class="text-[2.5rem] max-[1000px]:text-2xl font-semibold mt-4 mb-2">{{ value }}</p>
      <p class="text-xl max-[1000px]:text-base text-muted m-0">{{ label }}</p>
    </div>
  </div>
</template>

<script setup>
import { Icon } from '@iconify/vue'

defineProps({
  icon: String,
  label: String,
  value: [String, Number],
  color: String
})
</script>
