<template>
  <div>
    <div v-for="stat in stats" :key="stat.label">
      <p>{{ stat.label }}</p>
      <p>{{ stat.value }}</p>
      <p>
        {{ stat.trend > 0 ? '+' : '' }}{{ stat.trend }}% vs ontem
      </p>
    </div>
  </div>
</template>

<script setup>
const stats = [
  { label: 'Vendas hoje', value: 'R$ 2.847,30', trend: 12.5 },
  { label: 'Pedidos hoje', value: '47', trend: 8.2 },
  { label: 'Tempo médio', value: '28 min', trend: -3.1 },
  { label: 'Avaliação', value: '4.8', trend: 0.2 },
]
</script>
