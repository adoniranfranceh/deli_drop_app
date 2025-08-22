<template>
  <div class="restaurant-info">
    <div class="restaurant-top">
      <h2>Informações do restaurante</h2>
      <AppButton
        text="Editar"
        @click="navigateTo('/restaurants/edit')"
        iconLeft="lucide-pen-line"
        class="btn-edit"
      />
    </div>
    <div class="restaurant-header">
      <img
        alt="restaurant-img"
        class="restaurant-img"
        src="https://cdn.pixabay.com/photo/2016/03/05/19/02/hamburger-1238246_1280.jpg"
      />

      <div class="restaurant-title">
        <h3>Hamburgueria Top</h3>
      </div>
    </div>

    <hr>

    <div class="info">
      <div v-for="info in informations">
        <span>{{ info.label }}</span>
        <span class="info-value">{{ info.value }}</span>
      </div>
    </div>
  </div>
</template>

<script setup>
import AppButton from '../ui/AppButton.vue'
import { navigateTo } from '../../utils/navigation'

const informations = [
  { label: 'Avaliação', value: '4.8' },
  { label: 'Tempo médio', value: '25,35 min' },
  { label: 'Taxa de entrega', value: 'Grátis' }
]
</script>

<style scoped>
.restaurant-info {
  border: 1px solid var(--color-border);
  box-shadow: var(--shadow-sm);
  border-radius: 6px;
  background-color: var(--color-white);
  padding: 1rem 3rem;

  h2 {
    display: flex;
    justify-content: center;
    width: auto;
  }
}

.restaurant-top {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.btn-edit {
  background-color: var(--color-white);
  border: 1px solid var(--color-border);
  color: var(--color-black);
}

.btn-edit:hover {
  background-color: var(--color-border);
}

.restaurant-img {
  width: 4rem;
  height: 4rem;
  border-radius: 10px;
  margin-right: 1rem;
}

.restaurant-title {
  display: flex;
  flex-direction: column;
  justify-content: center;

  h3 {
    margin: 0;
  }
}

.restaurant-header{
  display: flex;
  margin: 1rem 0;
}

.info {
  display: flex;
  flex-direction: column;
  padding: 1rem 0;
  gap: 1rem;

  div {
    display: flex;
    justify-content: space-between;
  }

  span {
    color: var(--color-muted);
    font-weight: 500;
  }
}

.info-value {
  color: var(--color-black) !important;
  font-weight: 600 !important;
  font-size: 16px;
}

@media (max-width: 1500px) {
  .restaurant-top h2 {
    width: 180px;
  }
}

@media (max-width: 758px) {
  .restaurant-top {
    flex-direction: column;

    h2 {
      width: 100%;
    }
  }

  .btn-edit {
    width: 100%;
  }
}
</style>
