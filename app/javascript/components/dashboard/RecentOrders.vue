<template>
  <div>
    <h2>Pedidos recentes</h2>
    <div v-for="order in orders" :key="order.id">
      <p>#{{ order.id }} - {{ order.name }}</p>
      <p>{{ order.items }}</p>
      <p>R$ {{ order.total }}</p>
      <div>
        <span>{{ order.status }}</span>
        <span>{{ order.timeAgo }}</span>
      </div>
    </div>
    <button>
      Ver todos os pedidos
    </button>
  </div>
</template>

<script setup>
const orders = [
  { id: 1247, name: 'Maria Silva', items: '2x Açaí 500ml, 1x Hamburger Especial', total: '45,90', status: 'Preparando', timeAgo: 'há 5 min' },
  { id: 1246, name: 'João Santos', items: '1x Combo Mix, 1x Coca Cola', total: '32,50', status: 'Pronto', timeAgo: 'há 8 min' },
  { id: 1245, name: 'Ana Costa', items: '1x Açaí 300ml com granola', total: '18,90', status: 'Entregue', timeAgo: 'há 15 min' },
  { id: 1244, name: 'Pedro Lima', items: '2x Hamburger Clássico', total: '38,00', status: 'Preparando', timeAgo: 'há 20 min' },
]

const statusColor = (status) => {
  switch (status) {
    case 'Preparando': return 'text-yellow-500'
    case 'Pronto': return 'text-blue-500'
    case 'Entregue': return 'text-green-600'
    default: return 'text-gray-400'
  }
}
</script>
