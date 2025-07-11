<template>
  <div class="restaurant-dashboard">
    <h3>{{ restaurant.name }}</h3>
    <p>{{ restaurant.description }}</p>
    <div class="rating">
      Avaliação: <strong>{{ restaurant.rating.toFixed(1) }}</strong> ⭐
    </div>
    <div>
      Tempo médio: <strong>{{ restaurant.duration }} min</strong>
    </div>
    <div>
      Taxa de entrega: <strong>{{ restaurant.delivery_fee ? `R$ ${restaurant.delivery_fee}` : 'Grátis'}}</strong>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const restaurant = ref({
  name: '',
  description: '',
  rating: 0,
  duration: 0,
  delivery_fee: 0,
})

async function fetchRestaurantData() {
  // Exemplo de fetch - adapte para sua API / store / Vuex
  const response = await fetch('/api/restaurant') 
  const data = await response.json()
  restaurant.value = data
}

onMounted(() => {
  fetchRestaurantData()
})
</script>

<style scoped>
.restaurant-dashboard {
  border: 1px solid var(--color-border);
  padding: 1rem;
  border-radius: 8px;
}
</style>
