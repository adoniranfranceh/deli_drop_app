<template>
  <div class="modal-overlay" @click.self="$emit('close')">
    <div class="modal-content">
      <slot />
    </div>
  </div>
</template>

<script setup>
import { onMounted, onUnmounted } from 'vue'

defineEmits(['close'])

onMounted(() => {
  document.body.style.overflow = 'hidden'
})

onUnmounted(() => {
  document.body.style.overflow = ''
})
</script>

<style scoped>
body {
  overflow: hidden;
}

.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.6);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.modal-content {
  background: var(--color-white);
  padding: 2rem;
  border-radius: 10px;
  max-width: 800px;
  width: 100%;
  height: auto;
  overflow-y: auto;
}

@media (max-width: 758px) {
  .modal-content {
    height: 70%;
  }
}
</style>
