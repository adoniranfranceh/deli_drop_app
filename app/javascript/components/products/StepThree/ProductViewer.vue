<template>
  <div class="product-viewer">
    <div class="image-wrapper">
      <img :src="product.image_url" :alt="product.name" class="product-image" />
    </div>

    <div class="product-details">
      <div class="about-product">
        <h2>{{ product.name }}</h2>
        <div class="product-price">{{ FloatToMoney(finalPrice) }}</div>
      </div>

      <div class="info">
        <p>{{ product.description }}</p>
        <DeliveryDuration :duration="product.duration" />
      </div>

      <hr />

      <ModifierGroup
        v-if="product.modifier_groups?.length > 0"
        v-for="group in product.modifier_groups"
        :key="group.id"
        :modifier_group="group"
        @update:selected="handleUpdateSelected"
      />

      <ProductIngredients
        v-if="product.ingredients?.length"
        :ingredients="product.ingredients"
      />

      <div class="comment-content">
        <label for="comment">Algum comentário?</label>
        <textarea
          id="comment"
          rows="5"
          placeholder="Ex: sem cebola, sem maionese..."
          v-model="comment"
        />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { FloatToMoney } from '../../../utils/modey'
import DeliveryDuration from '../../ui/DeliveryDuration.vue'
import ModifierGroup from './ModifierGroup.vue'
import ProductIngredients from '../../ui/ProductIngredients.vue'

const props = defineProps({
  product: {
    type: Object,
    required: true
  }
})

const comment = ref('')
const selectedByGroup = ref({}); 

function handleUpdateSelected({ group_id, items, extra_price }) {
  selectedByGroup.value[group_id] = { items, extra_price }; 
}

const additionalTotal = computed(() => {
  return Object.values(selectedByGroup.value).reduce(
    (total, group) => total + (group.extra_price || 0),
    0
  );
});

const finalPrice = computed(() => {
  return (props.product.price || 0) + additionalTotal.value
});
</script>

<style scoped>
.product-viewer {
  display: flex;
  flex-direction: column;
  width: 800px;
}

.product-viewer h2 {
  color: var(--color-primary);
  font-size: 1.5rem;
  margin-bottom: 0;
}

.image-wrapper {
  width: 100%;
  height: 400px;
  overflow: hidden;
  background-color: var(--background-color);
}

.product-image {
  width: 100%;
  height: 100%;
  border-top-left-radius: 10px;
  border-top-right-radius: 10px;
  display: block;
  object-fit: cover;
}

.product-details {
  padding: 1.5rem;
  background-color: var(--color-white);
  border-bottom-left-radius: 10px;
  border-bottom-right-radius: 10px;
  box-shadow: var(--shadow-sm);
}

.about-product {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.product-price {
  font-size: 1.6rem;
  font-weight: 700;
  color: var(--color-black);
}

.info {
  margin-top: 1rem;
  color: #555;
  line-height: 1.5;
}

.comment-content {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  margin: 2rem 0;
}

.comment-content label {
  font-weight: 700;
}

.comment-content textarea {
  width: 100%;
  border: 1px solid var(--color-border);
  border-radius: 0.5rem;
  margin-top: 1rem;
  resize: none;
}

hr {
  margin: 2rem 0;
  border-top: 1px solid var(--color-border);
}

@media (max-width: 758px) {
  .product-viewer {
    width: 100%;
    height: 100%;
    border-radius: 0;
  }

  .product-details {
    padding: 2rem 1rem;
  }

  .image-wrapper {
    height: 270px;
  }

  .comment-content textarea {
    width: 97%;
  }

  .about-product {
    flex-direction: column;
    align-items: flex-start;
    gap: 0.5rem;
  }

  .info {
    text-align: center;
  }
}
</style>
