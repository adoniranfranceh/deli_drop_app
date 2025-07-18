<template>
  <header class="dashboard-header">
    <div>
      <h1 class="title"><Icon icon="tabler:chef-hat" /> Central do Menu</h1>
      <p class="subtitle">Gerencie seus produtos de forma simples e eficiente</p>
    </div>
    <div class="header-actions">
      <AppButton text="Nova Categoria" iconLeft="tabler:plus" class="new-category" />
      <AppButton text="Novo Produto" iconLeft="tabler:plus" />
    </div>
  </header>
</template>

<script setup>
import { Icon } from '@iconify/vue'
import AppButton from '../ui/AppButton.vue';
</script>

<style scoped>
.dashboard-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem 2rem;
  width: 100%;
  border-bottom: 2px solid var(--color-border);
  margin: 0 2rem;
}

.title {
  font-size: 1.5rem;
  font-weight: 700;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin: 0.5rem 0;
}

.title svg {
  color: var(--color-primary);
}

.subtitle {
  margin-top: 0.25rem;
  color: var(--color-muted);
}

.header-actions {
  display: flex;
  gap: 1rem;
}

:deep(.new-category.cta-button) {
  background-color: var(--color-white);
  color: var(--color-black);
  border: 1px solid var(--color-border);
}

:deep(.new-category.cta-button:hover) {
  background-color: var(--color-border);
}

:deep(.cta-button) {
  display: flex;
  align-items: stretch;
}

.btn-outline {
  background: var(--color-white);
  border: 1px solid var(--color-border);
  padding: 0.5rem 1rem;
  border-radius: 6px;
  cursor: pointer;
  font-weight: 500;
}

.btn-primary {
  background: var(--color-primary);
  color: var(--color-white);
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 6px;
  cursor: pointer;
  font-weight: 500;
}

@media (max-width: 1000px) {
  .dashboard-header {
    flex-direction: column;
    align-items: flex-start;
    width: 100%;
  }

  .title {
    margin: 0;
  }

  .subtitle {
    font-size: 16px;
  }

  .header-actions {
    width: 100%;
    flex-direction: column;
  }

  :deep(.cta-button) {
    justify-content: center;
  }
}
</style>
