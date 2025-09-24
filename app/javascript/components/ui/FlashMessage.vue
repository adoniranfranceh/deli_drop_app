<script setup>
import { ref } from 'vue'
import { Icon } from '@iconify/vue'
import AppButton from './AppButton.vue'

defineProps({
  type: { type: String, required: true },
  message: { type: String, required: true }
})

const visible = ref(true)
const close = () => {
  visible.value = false
}
</script>

<template>
  <div v-if="visible" class="messages">
    <div :class="['app-flash', `app-flash--${type}`]">
      <span class="app-flash__icon">
        <Icon v-if="type === 'success'" icon="fa6-solid:check" />
        <Icon v-else icon="lucide:triangle-alert" />
      </span>
      <span class="app-flash__text">{{ message }}</span>

      <AppButton
        icon="fa6-solid:xmark"
        class="app-flash__close"
        @click="close"
      />
    </div>
  </div>
</template>

<style scoped>
.messages {
  width: 100%;
  display: flex;
  justify-content: center;
  position: fixed;
  top: 1rem;
  z-index: 9999;
}

.app-flash {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.75rem 1rem;
  border-radius: 0.75rem;
  font-size: 0.95rem;
  font-weight: var(--font-weight-medium);
  box-shadow: var(--shadow-lg);
  animation: fadeIn 0.3s ease-out;
}

.app-flash__icon {
  font-size: 1.2rem;
}

.app-flash__close {
  background: none;
  color: inherit;
  padding: 0.3rem;
}

.app-flash__close svg {
  width: 0.7rem;
  height: 0.7rem;
}

.app-flash__close:hover {
  background: none;
  opacity: 0.7;
}

.app-flash--success {
  background-color: var(--color-success);
  color: var(--color-white);
}

.app-flash--error {
  background-color: var(--color-error);
  color: var(--color-white);
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(-5px); }
  to { opacity: 1; transform: translateY(0); }
}
</style>