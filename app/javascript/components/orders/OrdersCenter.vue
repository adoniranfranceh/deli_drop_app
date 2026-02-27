<template>
  <MenuHeader
    title="Central de Pedidos"
    subtitle="Gerencie os pedidos do seu restaurante"
    icon="tabler:receipt"
  >
    <template #actions>
      <AppButton
        text="Voltar a tela inicial"
        iconLeft="ri:arrow-left-line"
        variant="secondary"
        @click="navigateTo('/')"
      />
    </template>
  </MenuHeader>

  <div class="orders-layout">
    <StatusSidebar
      :tabs="STATUS_TABS"
      v-model="activeTab"
      :pendingCount="pendingCount"
      @update:modelValue="handleTabChange"
    />

    <div class="orders-layout__content">
      <div v-if="loading && orders.length === 0" class="bg-white border border-border rounded-lg p-12 flex justify-center">
        <Icon icon="tabler:loader-2" width="48" height="48" class="animate-spin text-muted" />
      </div>

      <div v-else-if="orders.length === 0" class="bg-white border border-border rounded-lg p-12 flex flex-col items-center text-muted">
        <Icon icon="tabler:receipt-off" width="72" height="72" class="mb-4 text-border" />
        <p class="font-semibold text-xl text-muted m-0">Nenhum pedido encontrado</p>
        <p class="text-base text-muted mb-0">
          {{ activeTab === 'all' ? 'Quando novos pedidos chegarem, eles aparecerão aqui.' : 'Nenhum pedido com este status no momento.' }}
        </p>
      </div>

      <div v-else>
        <div class="grid gap-8 grid-cols-1 min-[758px]:grid-cols-2 min-[958px]:grid-cols-3 min-[1250px]:grid-cols-4">
          <OrderCard
            v-for="order in orders"
            :key="order.id"
            :order="order"
            @select="handleSelectOrder"
            @accept="handleOpenAccept"
            @reject="handleOpenReject"
            @advance="handleAdvanceStatus"
          />
        </div>

        <div v-if="meta.total_pages > 1" class="flex justify-center items-center gap-4 mt-8">
          <AppButton
            text="Anterior"
            iconLeft="tabler:chevron-left"
            variant="secondary"
            :class="{ 'opacity-50 pointer-events-none': meta.current_page <= 1 }"
            @click="setPage(meta.current_page - 1)"
          />
          <span class="text-sm text-muted">
            Página {{ meta.current_page }} de {{ meta.total_pages }}
          </span>
          <AppButton
            text="Próxima"
            icon="tabler:chevron-right"
            variant="secondary"
            :class="{ 'opacity-50 pointer-events-none': meta.current_page >= meta.total_pages }"
            @click="setPage(meta.current_page + 1)"
          />
        </div>
      </div>
    </div>
  </div>

  <OrderDetailModal
    v-if="showDetailModal"
    :orderData="currentOrder"
    :loadingDetail="loadingDetail"
    @close="closeDetailModal"
    @accept="handleOpenAcceptFromDetail"
    @reject="handleOpenRejectFromDetail"
    @advance="handleAdvanceStatusFromDetail"
  />

  <AcceptOrderModal
    v-if="showAcceptModal"
    :order="selectedOrder"
    @close="showAcceptModal = false"
    @accept="handleAccept"
  />

  <RejectOrderModal
    v-if="showRejectModal"
    :order="selectedOrder"
    @close="showRejectModal = false"
    @reject="handleReject"
  />
</template>

<script setup>
import { ref, computed } from 'vue'
import { Icon } from '@iconify/vue'
import { useOrders } from '../../composables/useOrders'
import { STATUS_TABS, NEXT_STATUS } from '../../utils/orderStatusConfig'
import { navigateTo } from '../../utils/navigation'
import MenuHeader from '../ui/MenuHeader.vue'
import AppButton from '../ui/AppButton.vue'
import StatusSidebar from './StatusSidebar.vue'
import OrderCard from './OrderCard.vue'
import OrderDetailModal from './OrderDetailModal.vue'
import AcceptOrderModal from './AcceptOrderModal.vue'
import RejectOrderModal from './RejectOrderModal.vue'

const {
  orders,
  meta,
  loading,
  currentOrder,
  loadingDetail,
  fetchOrder,
  acceptOrder,
  rejectOrder,
  updateStatus,
  setStatusFilter,
  setPage,
} = useOrders()

const activeTab = ref('all')
const showDetailModal = ref(false)
const showAcceptModal = ref(false)
const showRejectModal = ref(false)
const selectedOrder = ref(null)

const pendingCount = computed(() =>
  orders.value.filter(o => o.status === 'pending').length
)

function handleTabChange(tabKey) {
  activeTab.value = tabKey
  setStatusFilter(tabKey === 'all' ? '' : tabKey)
}

async function handleSelectOrder(order) {
  showDetailModal.value = true
  await fetchOrder(order.id)
}

function closeDetailModal() {
  showDetailModal.value = false
  currentOrder.value = null
}

function handleOpenAccept(order) {
  selectedOrder.value = order
  showAcceptModal.value = true
}

function handleOpenReject(order) {
  selectedOrder.value = order
  showRejectModal.value = true
}

function handleOpenAcceptFromDetail(order) {
  selectedOrder.value = { id: order.id, code: order.code, customer_name: order.customer.name }
  showDetailModal.value = false
  showAcceptModal.value = true
}

function handleOpenRejectFromDetail(order) {
  selectedOrder.value = { id: order.id, code: order.code, customer_name: order.customer.name }
  showDetailModal.value = false
  showRejectModal.value = true
}

async function handleAccept(orderId, estimatedTime) {
  await acceptOrder(orderId, estimatedTime)
  showAcceptModal.value = false
  selectedOrder.value = null
}

async function handleReject(orderId, reason) {
  await rejectOrder(orderId, reason)
  showRejectModal.value = false
  selectedOrder.value = null
}

async function handleAdvanceStatus(order) {
  const nextStatus = NEXT_STATUS[order.status]
  if (nextStatus) {
    await updateStatus(order.id, nextStatus)
  }
}

async function handleAdvanceStatusFromDetail(order) {
  const nextStatus = NEXT_STATUS[order.status]
  if (nextStatus) {
    await updateStatus(order.id, nextStatus)
    closeDetailModal()
  }
}
</script>

<style scoped>
.orders-layout {
  display: flex;
  min-height: calc(100vh - 80px);
  background-color: var(--color-background);
}

.orders-layout__content {
  flex: 1;
  min-width: 0;
  padding: 2rem;
  display: flex;
  flex-direction: column;
  gap: 2rem;
}

@media (max-width: 758px) {
  .orders-layout {
    flex-direction: column;
    min-height: auto;
  }

  .orders-layout__content {
    padding: 1rem;
  }
}
</style>
