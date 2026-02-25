<template>
  <span v-if="duration" class="flex items-center">
    <Icon icon="mdi-light:clock" class="w-5 h-5 m-1" />
    {{ duration }} min
  </span>
</template>

<script setup>
import { Icon } from '@iconify/vue';

defineProps({
  duration: {
    type: [Number, String],
    required: true
  }
})
</script>
