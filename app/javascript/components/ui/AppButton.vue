<template>
  <button
    class="cta-button"
    :style="customStyles"
    :class="{ selected }"
    @click="handleClick"
  >
    <span class="text-btn">
      <Icon v-if="iconLeft" :icon="iconLeft" class="btn-icon" />
      {{ text }}
      <Icon v-if="icon" :icon="icon" class="btn-icon" />
    </span>
  </button>
</template>

<script setup>
import { Icon } from '@iconify/vue'

const props = defineProps({
  path: String,
  text: String,
  selected: Boolean,
  icon: String,
  iconLeft: String,
  customStyles: Object
})

const emit = defineEmits(['click'])

function handleClick(event) {
  event.stopPropagation()
  emit('click', event)
}
</script>

<style scoped>
.cta-button {
  background-color: var(--color-primary);
  color: var(--color-white);
  padding: 0.7rem 1.5rem;
  border-radius: 8px;
  text-decoration: none;
  font-weight: 500;
  display: inline-block;
  transition:
    background-color 0.3s ease,
    transform 0.3s ease;
  overflow: hidden;
  border: none;
  cursor: pointer;
}

.cta-button:hover {
  background-color: var(--color-primary-hover);
  transform: scale(1.05);
}

.cta-button:disabled {
  opacity: 0.7;
  cursor: not-allowed;
  pointer-events: none;
}

span {
  display: flex;
  align-items: center;
  font-size: 18px;
  font-weight: 400;
  gap: 0.5rem;
  transition: gap 0.3s ease;
  margin: 0;
}

.cta-button:hover span {
  gap: 1rem;
}

.btn-icon {
  transition: transform 0.3s ease;
}

.cta-button:hover .btn-icon {
  transform: translateX(4px);
}

@media (max-width: 600px) {
  .cta-button {
    padding: 0.7rem 1rem;
  }

  span {
    font-size: 14px;
  }
}
</style>
