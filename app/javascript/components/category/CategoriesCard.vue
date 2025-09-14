<template>
  <div class="category-card">
    <div class="category-info">
      <div class="category-header">
        <span class="category-title">{{ category.name }}</span>
        <div class="box-icon">
          <Icon icon="lucide:package" />
        </div>
      </div>
      <div class="category-stats">
        <div class="stat-item">
          <span class="stat-label">Produtos</span>
          <ItemChip :item="category.products_count" class="stat-value" />
        </div>
        <div class="stat-item">
          <span class="stat-label">Ativos</span>
          <ItemChip :item="category.actived_products_count" class="stat-value active" />
        </div>
        <div class="stat-item">
          <span class="stat-label">Preço Médio</span>
          <span>{{ FloatToMoney(category.average_price) }}</span>
        </div>
      </div>
    </div>
    <div class="category-actions">
      <AppButton class="edit-btn" text="Editar" iconLeft="lucide-pen-line" />
      <AppButton class="delete-btn" iconLeft="lucide:trash-2" />
    </div>
  </div>
</template>

<script setup>
import { defineProps } from 'vue';
import { Icon } from '@iconify/vue';
import AppButton from '../ui/AppButton.vue';
import ItemChip from '../ui/ItemChip.vue'
import { FloatToMoney } from '../../utils/modey';


defineProps({
  category: {
    type: Object,
    required: true,
    default: () => ({
      name: '',
      productsCount: 0,
      activeProductsCount: 0,
    }),
  },
});
</script>

<style scoped>
.category-card {
  background: var(--color-white);
  border-radius: 8px;
  transition: transform 0.2s, box-shadow 0.3s;
  border: 1px solid var(--color-border);
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  cursor: pointer;
  height: 300px;
  padding: 1.5rem;
}

.category-card:hover {
  box-shadow: var(--shadow-md);
}

.category-header {
  display: flex;
  margin-bottom: 1rem;
}

.category-title {
  font-size: 1.25rem;
  font-weight: bold;
  display: flex;
  justify-content: center;
  width: 100%;
}

.box-icon svg {
  width: 2.5rem;
  height: 2.5rem;
  color: var(--color-text-light);
}

.category-stats {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.stat-item {
  background: var(--color-background);
  padding: 0.7rem 1rem;
  border-radius: 4px;
  display: flex;
  justify-content: space-between;
}

.stat-label {
  font-size: 1rem;
  font-weight: 500;
}

.stat-value {
  font-size: 0.9rem;
  font-weight: bold;
}

.stat-value.active {
  background-color: var(--color-success);
  color: var(--color-white);
}

.category-actions {
  display: flex;
  gap: 1rem;
}

.edit-btn {
  border: 1px solid var(--color-border);
  background: var(--color-white);
  color: var(--color-black);
  width: 100%;
}

.edit-btn:hover {
  background-color: var(--color-border);
}

.delete-btn {
  border: 1px solid var(--color-border);
  background: var(--color-white);
  color: var(--color-primary);
}

.delete-btn :deep(svg) {
  width: 1.5rem;
  height: 1.5rem;
}

.delete-btn:hover {
  background: var(--color-border);
}
</style>