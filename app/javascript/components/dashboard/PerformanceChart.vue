<template>
  <div class="bg-white border border-border rounded-lg p-6 shadow-sm">
    <h2 class="text-center my-4 text-xl font-bold">Desempenho hoje</h2>

    <div
      v-for="(metric, index) in processedMetrics"
      :key="index"
      class="mb-5"
    >
      <div class="flex justify-between mb-1 text-sm font-medium">
        <span>{{ metric.label }}</span>
        <span class="font-bold">{{ metric.displayValue }}</span>
      </div>
      <div class="bg-[#f1f1f1] h-2 rounded-[10px] overflow-hidden">
        <div
          class="h-full bg-primary rounded-[10px] transition-all duration-300"
          :style="{ width: metric.percentage + '%' }"
        ></div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  metrics: {
    type: Array,
    required: true,
    default: () => [],
  },
})

const processedMetrics = computed(() =>
  props.metrics.map((metric) => {
    const percentage =
      metric.total > 0 ? (metric.value / metric.total) * 100 : 0

    return {
      ...metric,
      percentage: Math.min(percentage, 100).toFixed(1),
      displayValue: `${metric.value}${metric.suffix || ''}`,
    }
  })
)
</script>
