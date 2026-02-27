<template>
  <span
    :class="[config.bg, config.color, config.border, 'inline-flex items-center gap-1 px-2 py-0.5 rounded-full text-xs font-medium border']"
  >
    <Icon :icon="config.icon" width="14" height="14" />
    {{ config.label }}
  </span>
</template>

<script setup>
import { computed } from 'vue'
import { Icon } from '@iconify/vue'
import { getStatusConfig } from '../../utils/orderStatusConfig'

const props = defineProps({
  status: { type: String, required: true }
})

const config = computed(() => getStatusConfig(props.status))
</script>
