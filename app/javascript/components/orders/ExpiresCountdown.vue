<template>
  <span
    v-if="remaining > 0"
    class="inline-flex items-center gap-1 text-xs font-medium"
    :class="remaining <= 120 ? 'text-red-600' : 'text-amber-600'"
  >
    <Icon icon="tabler:hourglass" width="14" height="14" />
    Expira em {{ formatCountdown(remaining) }}
  </span>
  <span v-else class="inline-flex items-center gap-1 text-xs font-medium text-red-600">
    <Icon icon="tabler:hourglass-off" width="14" height="14" />
    Expirado
  </span>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { Icon } from '@iconify/vue'
import { expiresInSeconds, formatCountdown } from '../../utils/timeHelper'

const props = defineProps({
  expiresAt: { type: String, default: null }
})

const remaining = ref(expiresInSeconds(props.expiresAt))
let timer = null

onMounted(() => {
  timer = setInterval(() => {
    remaining.value = expiresInSeconds(props.expiresAt)
    if (remaining.value <= 0) clearInterval(timer)
  }, 1000)
})

onUnmounted(() => {
  if (timer) clearInterval(timer)
})
</script>
