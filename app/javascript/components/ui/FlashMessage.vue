<script setup>
import { Icon } from '@iconify/vue';

defineProps({
  type: { type: String, required: true },
  message: { type: String, required: true }
});
</script>

<template>
  <div class="mensages">
    <div :class="['app-flash', `app-flash--${type}`]">
      <span class="app-flash__icon">
        <Icon v-if="type === 'success'" icon="fa6-solid:check" />
        <Icon v-else icon="lucide:triangle-alert" />
      </span>
      <span class="app-flash__text">Login efetuado com sucesso!</span>
    </div>
  </div>
</template>

<style scoped>
.mensages {
  width: 100%;
  display: flex;
  justify-content: center;
  position: absolute;
  top: 1rem;
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
