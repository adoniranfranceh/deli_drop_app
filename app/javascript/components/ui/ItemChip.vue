<template>
  <span class="bg-[#f1f1f1] font-semibold text-text py-1.5 px-3 m-0 rounded-full text-sm transition-colors duration-200 shrink-0 hover:bg-border">
    {{ item }}
    <button
      v-if="hasRemoveListener"
      class="bg-transparent border-none text-muted text-base cursor-pointer p-0 ml-1 leading-none hover:text-primary"
      @click="$emit('remove')"
    >×</button>
  </span>
</template>

<script setup>
import { computed, useAttrs } from 'vue';

defineProps({
  item: {
    type: [String, Number],
    required: true
  }
})

const attrs = useAttrs();
const hasRemoveListener = computed(() => !!attrs.onRemove);
</script>
