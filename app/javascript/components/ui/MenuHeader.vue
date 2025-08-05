<template>
  <div class="menu-overview">
    <header class="menu-header">
      <div>
        <h1 class="title"><Icon :icon="icon" /> {{ title }}</h1>
        <p class="subtitle">{{ subtitle }}</p>
      </div>
      <div class="header-actions">
        <slot name="actions" />
      </div>
    </header>
  </div>
</template>

<script setup>
import { Icon } from '@iconify/vue'

defineProps({
  title: String,
  subtitle: String,
  icon: {
    type: String,
    default: 'tabler:chef-hat',
  }
})
</script>

<style scoped>
.menu-overview {
  display: flex;
  justify-content: center;
}

.menu-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem 2rem;
  width: 100%;
  border-bottom: 1px solid var(--color-border);
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

@media (max-width: 1000px) {
  .menu-header {
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
}

@media (max-width: 758px) {
  .menu-header {
    margin: 0;
    padding: 1rem;
  }
}
</style>
