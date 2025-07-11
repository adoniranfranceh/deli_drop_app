<template>
  <div>
    <button
      v-for="action in actions"
      :key="action.label"
    >
      {{ action.label }}
    </button>
  </div>
</template>

<script setup>
const actions = [
  { label: 'Gerenciar Menu' },
  { label: 'Ver Pedidos' },
  { label: 'Horários' },
  { label: 'Área de Entrega' },
]
</script>
