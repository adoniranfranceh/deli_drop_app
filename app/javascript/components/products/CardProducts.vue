<template>
  <div class="product-card">
    <div class="card-header">
      <div class="image-wrapper">
        <img :src="product.image" :alt="product.name" class="product-image" />
        <span class="product-stamp">
          {{ product.featured ?  'Destaque' : product?.category_name }}
        </span>
      </div>
      <div class="product-details">
      <div class="product-info">
        <div class="product-headinfo">
          <h3>{{ product.name }}</h3>
          <div class="toggle-container">
            <ToggleSwitch
              v-model:is-active="product.active"
              @update:is-active="$emit('toggle-product', product.id, product.active)"
            />
          </div>
        </div>
        </div>
        <p class="description">{{ product.description }}</p>
        <div class="info-row">
          <strong class="price">{{ FloatToMoney(product.base_price) }}</strong>
          <DeliveryDuration :duration="product.duration" />
        </div>
      </div>
    </div>
    <div class="actions-footer">
      <AppButton
        class="action-btn edit-btn"
        text="Editar"
        iconLeft="lucide:pen-line"
      />
      <AppButton
        class="action-btn delete-btn"
        iconLeft="lucide:trash-2"
      />
    </div>
  </div>
</template>

<script setup>
import AppButton from '../ui/AppButton.vue';
import ToggleSwitch from '../ui/ToggleSwitch.vue';
import { FloatToMoney } from '../../utils/modey';
import DeliveryDuration from '../ui/DeliveryDuration.vue';

defineProps({
  product: {
    type: Object,
    required: true,
  },
});

defineEmits(['toggle-product', 'edit-product', 'view-product', 'delete-product']);
</script>

<style scoped>
.product-card {
  background: var(--color-white);
  border-radius: 8px;
  overflow: hidden;
  transition: transform 0.2s, box-shadow 0.3s;
  border: 1px solid var(--color-border);
  display: flex;
  flex-direction: column;
  cursor: pointer;
}

.product-card:hover {
  transform: scale(1.02);
  box-shadow: var(--shadow-md);
}

.card-header {
  position: relative;
}

.product-image {
  width: 100%;
  height: 200px;
  object-fit: cover;
  border-top-left-radius: 8px;
  border-top-right-radius: 8px;
}

.product-stamp {
  background: var(--color-primary);
  position: absolute;
  top: 10px;
  left: 10px;
  border-radius: 9999px;
  font-size: 12px;
  font-weight: 600;
  color: var(--color-white);
  padding: 4px 20px;
}

.product-details {
  padding: 1rem;
}

.product-info h3 {
  font-size: 1.5rem;
  margin: 0;
  color: var(--color-text);
}

.product-headinfo {
  display: flex;
  justify-content: space-between;
}

.product-info .description {
  font-size: 1rem;
  color: var(--color-muted);
  margin: 0.5rem 0;
  line-height: 1.4;
}

.info-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 1rem;
}

.price {
  font-size: 1.8rem;
  font-weight: 700;
  color: var(--color-primary);
}

.actions-footer {
  display: flex;
  justify-content: space-between;
  gap: 1rem;
  padding: 1rem;
  border-top: 1px solid var(--color-border);
}

.edit-btn {
  width: 100%;
  color: var(--color-black);
  border: 1px solid var(--color-border);
  background-color: var(--color-white);
}

.edit-btn:hover {
  background-color: var(--color-border);
}

.delete-btn {
  color: var(--color-primary);
  border: 1px solid var(--color-border);
  background-color: var(--color-white);
}

.delete-btn :deep(svg) {
  width: 1.5rem;
  height: 1.5rem;
}

.delete-btn:hover {
  background-color: var(--color-border);
}

.icon-text {
  display: none;
}

@media (min-width: 768px) {
  .icon-text {
    display: inline;
  }
}
</style>
