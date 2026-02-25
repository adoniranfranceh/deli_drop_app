<template>
  <div class="flex gap-8 mb-8 max-[1000px]:grid max-[1000px]:grid-cols-2 max-[758px]:flex max-[758px]:flex-col max-[758px]:gap-4">
    <CardInfo icon="tabler:package" label="Total de Produtos" value="0" color="orange" />
    <CardInfo icon="tabler:eye" label="Produtos Ativos" value="0" color="green" />
    <CardInfo icon="tabler:star" label="Em Destaque" value="0" color="yellow" />
    <CardInfo icon="tabler:currency-dollar" label="Preço Médio" value="R$ 0.00" color="blue" />
  </div>
</template>

<script setup>
import CardInfo from './CardInfo.vue';
</script>
