<template>
  <div class="recent-orders">
    <div class="orders-header">
      <h2>Pedidos recentes</h2>
      <ItemChip item="4 ativos" />
    </div>
    <div v-for="order in orders" :key="order.id">
      <div class="order">
        <div class="order-header">
          <span class="order-id">#{{ order.id }} - {{ order.name }}</span>
          <ItemChip
            :item="order.status"
            class="status-chip"
            :style="{
              background: statusBackground(order.status),
              color: statusColor(order.status)
            }"
          />
        </div>
        <p class="order-items">{{ order.items }}</p>
        <div class="footer-order">
          <span class="order-total">R$ {{ order.total }}</span>
          <div>
            <span class="order-ago">{{ order.timeAgo }}</span>
          </div>
        </div>
      </div>

      <hr>
    </div>
    <div class="btn-orders">
      <AppButton text="Ver todos os pedidos" />
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

<style scoped>
.recent-orders {
  background-color: var(--color-white);
  border: 1px solid var(--color-border);
  box-shadow: var(--shadow-sm);
  border-radius: 6px;
  display: flex;
  flex-direction: column;
  justify-content: center;

  h2 {
    margin: 0;
  }
}

:deep(.cta-button) {
  display: flex;
  justify-content: center;
  background-color: var(--color-white);
  color: var(--color-black);
  border: 1px solid var(--color-primary);
  width: 100%;
}

:deep(.cta-button:hover) {
  background-color: var(--color-border);
}

.orders-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin: 2rem;
}

.order {
  padding: 2rem 0;

  p {
    display: flex;
    justify-content: center
  }
}

.order-id,
.order-total,
.order-ago{
  padding: 0 2rem;
}

.order-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 1rem;
}

.order:hover {
  background-color: var(--color-background);
}

.order-id {
  font-size: 20px;
  font-weight: 500;
}

.status-chip {
  margin: 0 2rem;
}

.order-items {
  color: var(--color-muted);
}

.footer-order {
  display: flex;
  justify-content: space-between;
}

.order-total {
  font-size: 20px;
  font-weight: 500;
}

.order-ago {
  color: var(--color-muted);
}

.btn-orders {
  display: flex;
  justify-content: center;
  padding: 1rem;
}
</style>
