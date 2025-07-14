<template>
  <span class="chip">
    {{ item }}
  </span>
</template>

<style scoped>
.chip {
  background-color: #f1f1f1;
  font-weight: 600;
  color: #333;
  padding: 0.4rem 0.75rem;
  margin: 0;
  border-radius: 9999px;
  font-size: 0.9rem;
  transition: background-color 0.2s;
  flex-shrink: 0;
}

.chip:hover {
  background-color: #e0e0e0;
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
