<template>
  <div class="bg-white border border-border shadow-sm rounded-md flex flex-col justify-center">
    <div class="flex justify-between items-center m-8">
      <h2 class="m-0 text-xl font-bold">Pedidos recentes</h2>
      <ItemChip
        v-if="activeCount > 0"
        :item="`${activeCount} ${activeCount === 1 ? 'ativo' : 'ativos'}`"
      />
    </div>

    <div v-if="loading" class="flex justify-center p-8">
      <Icon icon="tabler:loader-2" width="32" height="32" class="animate-spin text-muted" />
    </div>

    <div v-else-if="orders.length === 0" class="flex flex-col items-center p-8 text-muted">
      <Icon icon="tabler:receipt-off" width="48" height="48" class="mb-2 text-border" />
      <p class="m-0 text-sm">Nenhum pedido recente</p>
    </div>

    <template v-else>
      <div v-for="order in orders" :key="order.id">
        <div class="py-6 hover:bg-background transition-colors duration-150 cursor-pointer" @click="navigateTo('/orders')">
          <div class="flex justify-between items-center gap-4">
            <span class="px-8 text-base font-medium">#{{ order.code }} - {{ order.customer_name }}</span>
            <ItemChip
              :item="statusLabel(order.status)"
              class="mx-8"
              :style="{
                background: statusBg(order.status),
                color: statusColor(order.status)
              }"
            />
          </div>
          <p class="flex justify-center text-muted text-sm my-1">
            {{ order.items_count }} {{ order.items_count === 1 ? 'item' : 'itens' }}
          </p>
          <div class="flex justify-between items-center">
            <span class="px-8 text-base font-medium">R$ {{ formatPrice(order.total) }}</span>
            <span class="px-8 text-muted text-sm">{{ timeAgo(order.created_at) }}</span>
          </div>
        </div>
        <hr>
      </div>
    </template>

    <div class="flex justify-center p-4">
      <AppButton
        text="Ver todos os pedidos"
        variant="secondary"
        class="w-full !border-primary"
        @click="navigateTo('/orders')"
      />
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import axios from 'axios'
import { Icon } from '@iconify/vue'
import AppButton from '../ui/AppButton.vue'
import ItemChip from '../ui/ItemChip.vue'
import { navigateTo } from '../../utils/navigation'
import { getStatusConfig } from '../../utils/orderStatusConfig'

const orders = ref([])
const loading = ref(false)

const activeStatuses = ['pending', 'confirmed', 'preparing', 'ready', 'out_for_delivery']

const activeCount = computed(() =>
  orders.value.filter(o => activeStatuses.includes(o.status)).length
)

function statusLabel(status) {
  return getStatusConfig(status).label
}

function statusColor(status) {
  const cfg = getStatusConfig(status)
  const colorMap = {
    'text-amber-700': '#b45309',
    'text-blue-700': '#1d4ed8',
    'text-yellow-700': '#a16207',
    'text-indigo-700': '#4338ca',
    'text-purple-700': '#7e22ce',
    'text-green-700': '#15803d',
    'text-red-700': '#b91c1c',
  }
  return colorMap[cfg.color] || '#666666'
}

function statusBg(status) {
  const cfg = getStatusConfig(status)
  const bgMap = {
    'bg-amber-100': '#fef3c7',
    'bg-blue-100': '#dbeafe',
    'bg-yellow-100': '#fef9c3',
    'bg-indigo-100': '#e0e7ff',
    'bg-purple-100': '#f3e8ff',
    'bg-green-100': '#dcfce7',
    'bg-red-100': '#fee2e2',
  }
  return bgMap[cfg.bg] || '#f1f1f1'
}

function formatPrice(value) {
  if (value == null) return '0,00'
  return Number(value).toFixed(2).replace('.', ',')
}

function timeAgo(dateStr) {
  if (!dateStr) return ''
  const now = new Date()
  const date = new Date(dateStr)
  const diffMs = now - date
  const diffMin = Math.floor(diffMs / 60000)

  if (diffMin < 1) return 'agora'
  if (diffMin < 60) return `há ${diffMin} min`

  const diffHours = Math.floor(diffMin / 60)
  if (diffHours < 24) return `há ${diffHours}h`

  const diffDays = Math.floor(diffHours / 24)
  return `há ${diffDays}d`
}

async function fetchRecentOrders() {
  loading.value = true
  try {
    const { data } = await axios.get('/api/v1/restaurant/orders', {
      params: { page: 1, per_page: 5 }
    })
    orders.value = data.orders || []
  } catch (error) {
    console.error('Erro ao buscar pedidos recentes:', error)
  } finally {
    loading.value = false
  }
}

onMounted(() => fetchRecentOrders())
</script>
