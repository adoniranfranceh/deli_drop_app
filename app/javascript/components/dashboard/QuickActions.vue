<template>
  <h2 class="quick-title">Ações rápidas</h2>
  <div class="quick-actions">
    <div
      v-for="action in actions"
      :key="action.label"
      class="quick-action-card"
      @click="navigateTo(action.path)"
    >
      <div class="quick-action-icon"><Icon :icon="action.icon" /></div>
      <span class="quick-action-label">{{ action.label }}</span>
    </div>
  </div>
</template>

<script setup>
import { Icon } from '@iconify/vue';

const actions = [
  { label: 'Gerenciar Menu', icon: 'tabler:chef-hat', path: '/menu' },
  { label: 'Ver Pedidos', icon: 'iconoir:bell', path: '/orders' },
  { label: 'Horários', icon: 'lucide:calendar', path: '/schedules' },
  { label: 'Área de Entrega', icon: 'tdesign:location', path: '/delivery-area' }
]

const navigateTo = (path) => {
  if (path) window.location.href = path
}
</script>

<style scoped>
.quick-title {
  margin: 0;
  display: flex;
  justify-content: center;
}

.quick-actions {
  display: flex;
  gap: 1.5rem;
}

.quick-action-card {
  width: 23%;
  height: 54px;
  background: var(--color-white);
  border: 1px solid var(--color-primary);
  border-radius: 6px;
  padding: 1.5rem 1rem;
  text-align: center;
  cursor: pointer;
  transition: box-shadow 0.2s ease;
}

.quick-action-card:hover {
  background-color: var(--color-background);
}

.quick-action-icon {
  font-size: 1.6rem;
  margin-bottom: 0.5rem;
}

.quick-action-label {
  font-weight: 500;
  color: var(--color-black);
}

@media (max-width: 758px) {
  .quick-actions {
    flex-wrap: wrap;
  }

  .quick-action-card {
    width: 100%;
  }
}
</style>
