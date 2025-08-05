<template>
  <span class="chip">
    {{ item }}
    <button class="remove-btn" @click="$emit('remove')">×</button>
  </span>
</template>

<style scoped>
.chip {
  background-color: #f1f1f1;
  font-weight: 600;
  color: var(--color-text);
  padding: 0.4rem 0.75rem;
  margin: 0;
  border-radius: 9999px;
  font-size: 0.9rem;
  transition: background-color 0.2s;
  flex-shrink: 0;
}

.chip:hover {
  background-color: var(--color-border);
}

.remove-btn {
  background: transparent;
  border: none;
  color: var(--color-muted);
  font-size: 1rem;
  cursor: pointer;
  padding: 0;
  margin-left: 0.3rem;
  line-height: 1;
}

.remove-btn:hover {
  color: var(--color-primary);
}
</style>

<script setup>
  defineProps({
    item: {
      type: String,
      required: true
    }
  })
</script>
