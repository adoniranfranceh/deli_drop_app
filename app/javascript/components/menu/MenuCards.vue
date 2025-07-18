<template>
  <div class="menu-cards">
    <CardInfo icon="tabler:package" label="Total de Produtos" value="0" color="orange" />
    <CardInfo icon="tabler:eye" label="Produtos Ativos" value="0" color="green" />
    <CardInfo icon="tabler:star" label="Em Destaque" value="0" color="yellow" />
    <CardInfo icon="tabler:currency-dollar" label="Preço Médio" value="R$ 0.00" color="blue" />
  </div>
</template>

<script setup>
import CardInfo from './CardInfo.vue';

</script>

<style scoped>
.menu-cards {
  display: flex;
  gap: 2em;
  margin-bottom: 2rem;
}

@media (max-width: 1000px) {
  .menu-cards {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 2em;
  }
}

@media (max-width: 758px) {
  .menu-cards {
    display: flex;
    flex-direction: column;
    gap: 1em;
  }
}
</style>
