<template>
  <div class="bg-white border border-border shadow-sm rounded-md flex flex-col justify-center">
    <div class="flex justify-between items-center m-8">
      <h2 class="m-0 text-xl font-bold">Pedidos recentes</h2>
      <ItemChip item="4 ativos" />
    </div>
    <div v-for="order in orders" :key="order.id">
      <div class="py-8 hover:bg-background">
        <div class="flex justify-between items-center gap-4">
          <span class="px-8 text-xl font-medium">#{{ order.id }} - {{ order.name }}</span>
          <ItemChip
            :item="order.status"
            class="mx-8"
            :style="{
              background: statusBackground(order.status),
              color: statusColor(order.status)
            }"
          />
        </div>
        <p class="flex justify-center text-muted">{{ order.items }}</p>
        <div class="flex justify-between">
          <span class="px-8 text-xl font-medium">R$ {{ order.total }}</span>
          <div>
            <span class="px-8 text-muted">{{ order.timeAgo }}</span>
          </div>
        </div>
      </div>

      <hr>
    </div>
    <div class="flex justify-center p-4">
      <AppButton
        text="Ver todos os pedidos"
        variant="secondary"
        class="w-full !border-primary"
      />
    </div>
  </div>
</template>

<script setup>
import AppButton from '../ui/AppButton.vue'
import ItemChip from '../ui/ItemChip.vue'

const orders = [
  { id: 1247, name: 'Maria Silva', items: '2x Açaí 500ml, 1x Hamburger Especial', total: '45,90', status: 'Preparando', timeAgo: 'há 5 min' },
  { id: 1246, name: 'João Santos', items: '1x Combo Mix, 1x Coca Cola', total: '32,50', status: 'Pronto', timeAgo: 'há 8 min' },
  { id: 1245, name: 'Ana Costa', items: '1x Açaí 300ml com granola', total: '18,90', status: 'Entregue', timeAgo: 'há 15 min' },
  { id: 1244, name: 'Pedro Lima', items: '2x Hamburger Clássico', total: '38,00', status: 'Preparando', timeAgo: 'há 20 min' },
]

const statusColor = (status) => {
  switch (status) {
    case 'Preparando':
      return 'var(--color-doing)'
    case 'Pronto':
      return 'var(--color-done)'
    case 'Entregue':
      return 'var(--color-delivered)'
    default:
      return 'var(--color-muted)'
  }
}


const statusBackground = (status) => {
  switch (status) {
    case 'Preparando': return 'var(--background-doing)'
    case 'Pronto': return 'var(--background-done)'
    case 'Entregue': return 'var(--background-delivered)'
    default: return 'var(--color-muted)'
  }
}
</script>
