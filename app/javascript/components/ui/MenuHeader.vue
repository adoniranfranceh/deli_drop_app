<template>
  <div class="flex justify-center">
    <header class="flex justify-between items-center py-4 px-8 w-full border-b border-border mx-8 max-[1000px]:flex-col max-[1000px]:items-start max-[758px]:mx-0 max-[758px]:p-4">
      <div>
        <h1 class="text-2xl font-bold flex items-center gap-2 my-2 max-[1000px]:m-0">
          <Icon :icon="icon" class="text-primary" />
          {{ title }}
        </h1>
        <p class="mt-1 text-muted max-[1000px]:text-base">{{ subtitle }}</p>
      </div>
      <div class="flex gap-4 max-[1000px]:w-full max-[1000px]:flex-col">
        <slot name="actions" />
      </div>
    </header>
  </div>
</template>

<script setup>
import { Icon } from '@iconify/vue'

defineProps({
  title: String,
  subtitle: String,
  icon: {
    type: String,
    default: 'tabler:chef-hat',
  }
})
</script>
