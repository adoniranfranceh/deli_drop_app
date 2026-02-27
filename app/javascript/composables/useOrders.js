import { ref, onMounted, onUnmounted } from 'vue'
import axios from 'axios'
import { showFlash } from '../utils/flashHelper'

export function useOrders() {
  const orders = ref([])
  const meta = ref({ current_page: 1, total_pages: 1, total_count: 0 })
  const loading = ref(false)
  const currentOrder = ref(null)
  const loadingDetail = ref(false)

  const filters = ref({
    status: '',
    page: 1,
    per_page: 15,
  })

  let pollingTimer = null
  let previousOrderIds = []
  let notificationSound = null

  function initSound() {
    try {
      notificationSound = new Audio('/notification.mp3')
      notificationSound.volume = 0.5
    } catch (_) { /* sound optional */ }
  }

  function playNotificationSound() {
    if (notificationSound) {
      notificationSound.currentTime = 0
      notificationSound.play().catch(() => {})
    }
  }

  async function fetchOrders() {
    loading.value = true
    try {
      const params = { page: filters.value.page, per_page: filters.value.per_page }
      if (filters.value.status) params.status = filters.value.status

      const { data } = await axios.get('/api/v1/restaurant/orders', { params })
      const newOrders = data.orders || []

      if (previousOrderIds.length > 0 && filters.value.status !== 'delivered') {
        const newIds = newOrders.map(o => o.id)
        const hasNew = newIds.some(id => !previousOrderIds.includes(id))
        if (hasNew) playNotificationSound()
      }

      previousOrderIds = newOrders.map(o => o.id)
      orders.value = newOrders
      meta.value = data.meta || meta.value
    } catch (error) {
      console.error('Erro ao buscar pedidos:', error)
    } finally {
      loading.value = false
    }
  }

  async function fetchOrder(orderId) {
    loadingDetail.value = true
    try {
      const { data } = await axios.get(`/api/v1/restaurant/orders/${orderId}`)
      currentOrder.value = data
      return data
    } catch (error) {
      showFlash({ type: 'error', message: 'Erro ao carregar detalhes do pedido' })
      throw error
    } finally {
      loadingDetail.value = false
    }
  }

  async function acceptOrder(orderId, estimatedDeliveryTime) {
    try {
      const { data } = await axios.patch(`/api/v1/restaurant/orders/${orderId}/accept`, {
        estimated_delivery_time: estimatedDeliveryTime
      })
      showFlash({ type: 'success', message: data.message || 'Pedido aceito!' })
      await fetchOrders()
      return data
    } catch (error) {
      const msg = error.response?.data?.errors || 'Erro ao aceitar pedido'
      showFlash({ type: 'error', message: msg })
      throw error
    }
  }

  async function rejectOrder(orderId, reason) {
    try {
      const { data } = await axios.patch(`/api/v1/restaurant/orders/${orderId}/reject`, {
        reason
      })
      showFlash({ type: 'success', message: data.message || 'Pedido rejeitado' })
      await fetchOrders()
      return data
    } catch (error) {
      const msg = error.response?.data?.errors || 'Erro ao rejeitar pedido'
      showFlash({ type: 'error', message: msg })
      throw error
    }
  }

  async function updateStatus(orderId, status) {
    try {
      const { data } = await axios.patch(`/api/v1/restaurant/orders/${orderId}/status`, { status })
      showFlash({ type: 'success', message: data.message || 'Status atualizado!' })
      await fetchOrders()
      return data
    } catch (error) {
      const msg = error.response?.data?.errors || 'Erro ao atualizar status'
      showFlash({ type: 'error', message: msg })
      throw error
    }
  }

  function setStatusFilter(status) {
    filters.value.status = status
    filters.value.page = 1
    previousOrderIds = []
    fetchOrders()
  }

  function setPage(page) {
    filters.value.page = page
    fetchOrders()
  }

  function startPolling(intervalMs = 30000) {
    stopPolling()
    initSound()
    fetchOrders()
    pollingTimer = setInterval(fetchOrders, intervalMs)
  }

  function stopPolling() {
    if (pollingTimer) {
      clearInterval(pollingTimer)
      pollingTimer = null
    }
  }

  onMounted(() => startPolling())
  onUnmounted(() => stopPolling())

  return {
    orders,
    meta,
    loading,
    currentOrder,
    loadingDetail,
    filters,
    fetchOrders,
    fetchOrder,
    acceptOrder,
    rejectOrder,
    updateStatus,
    setStatusFilter,
    setPage,
    startPolling,
    stopPolling,
  }
}
