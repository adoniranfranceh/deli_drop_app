<template>
  <div class="performance-chart">
    <h2>Desempenho hoje</h2>

    <div
      v-for="(metric, index) in processedMetrics"
      :key="index"
      class="metric"
    >
      <div class="metric-header">
        <span>{{ metric.label }}</span>
        <span class="value">{{ metric.displayValue }}</span>
      </div>
      <div class="progress-bar">
        <div
          class="progress-fill"
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

<style scoped>
.performance-chart {
  background: var(--color-white);
  border: 1px solid var(--color-border);
  border-radius: 8px;
  padding: 1.5rem;
  box-shadow: var(--shadow-sm);
  font-family: var(--font-family);
}

.performance-chart h2 {
  text-align: center;
  margin: 1rem 0;
}

.metric {
  margin-bottom: 1.2rem;
}

.metric-header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 0.4rem;
  font-size: 0.9rem;
  font-weight: 500;
}

.value {
  font-weight: bold;
}

.progress-bar {
  background-color: #f1f1f1;
  height: 8px;
  border-radius: 10px;
  overflow: hidden;
}

.progress-fill {
  height: 100%;
  background-color: var(--color-primary);
  border-radius: 10px;
  transition: width 0.3s ease;
}
</style>
