<template>
  <div class="info-card">
    <Icon :icon="icon" :style="{ color }" class="info-icon" />
    <div class="info-content">
      <p class="info-value">{{ value }}</p>
      <p class="info-label">{{ label }}</p>
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

<style scoped>
.info-card {
  display: flex;
  flex-direction: column;
  align-items: center;
  background: var(--color-white);
  border-radius: 8px;
  padding: 2rem 0;
  flex: 1;
  border: 1px solid var(--color-border);
}

.info-icon {
  width: 4rem;
  height: 4rem;
}

.info-content {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.info-value {
  font-size: 2.5rem;
  font-weight: 600;
  margin: 1rem 0 0.5rem 0;
}

.info-label {
  font-size: 1.2rem;
  color: var(--color-muted);
  margin: 0;
}

@media (max-width: 1000px) {
  .info-icon {
    width: 3rem;
    height: 3rem;
  }
}
</style>