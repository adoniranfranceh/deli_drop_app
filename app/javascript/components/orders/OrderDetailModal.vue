<template>
  <BaseModal @close="$emit('close')">
    <div v-if="loadingDetail" class="flex justify-center items-center py-12">
      <Icon icon="tabler:loader-2" width="32" height="32" class="animate-spin text-muted" />
    </div>

    <div v-else-if="orderData">
      <div class="flex justify-between items-center mb-6">
        <div>
          <h2 class="text-xl font-bold text-text m-0">Pedido {{ orderData.order.code }}</h2>
          <p class="text-sm text-muted mt-1 mb-0">{{ formatDateTime(orderData.order.created_at) }}</p>
        </div>
        <div class="flex items-center gap-3">
          <ItemChip
            :item="statusLabel"
            :style="{ background: statusBg, color: statusTextColor }"
          />
          <button @click="$emit('close')" class="text-muted hover:text-text transition-colors cursor-pointer bg-transparent border-none">
            <Icon icon="tabler:x" width="20" height="20" />
          </button>
        </div>
      </div>

      <hr class="mb-4" />

      <div class="mb-4">
        <h3 class="text-sm font-semibold text-muted uppercase tracking-wide mb-2">Cliente</h3>
        <div class="bg-white border border-border rounded-md p-4 flex flex-col gap-2">
          <div class="flex items-center gap-2">
            <Icon icon="tabler:user" width="16" height="16" class="text-muted" />
            <span class="text-sm text-text font-medium">{{ orderData.order.customer.name }}</span>
          </div>
          <div class="flex items-center gap-2">
            <Icon icon="tabler:phone" width="16" height="16" class="text-muted" />
            <span class="text-sm text-text">{{ orderData.order.customer.phone }}</span>
          </div>
          <div v-if="orderData.order.customer.email" class="flex items-center gap-2">
            <Icon icon="tabler:mail" width="16" height="16" class="text-muted" />
            <span class="text-sm text-text">{{ orderData.order.customer.email }}</span>
          </div>
        </div>
      </div>

      <div class="mb-4">
        <h3 class="text-sm font-semibold text-muted uppercase tracking-wide mb-2">Entrega</h3>
        <div class="bg-white border border-border rounded-md p-4 flex flex-col gap-2">
          <div class="flex items-center gap-2">
            <Icon icon="tabler:map-pin" width="16" height="16" class="text-muted" />
            <span class="text-sm text-text">{{ orderData.order.delivery_address }}</span>
          </div>
          <div v-if="orderData.order.delivery_complement" class="flex items-center gap-2">
            <Icon icon="tabler:building" width="16" height="16" class="text-muted" />
            <span class="text-sm text-text">{{ orderData.order.delivery_complement }}</span>
          </div>
          <div v-if="orderData.order.delivery_neighborhood" class="flex items-center gap-2">
            <Icon icon="tabler:home" width="16" height="16" class="text-muted" />
            <span class="text-sm text-text">{{ orderData.order.delivery_neighborhood }}</span>
          </div>
          <div v-if="orderData.order.delivery_reference" class="flex items-center gap-2">
            <Icon icon="tabler:info-circle" width="16" height="16" class="text-muted" />
            <span class="text-sm text-text italic">{{ orderData.order.delivery_reference }}</span>
          </div>
          <div v-if="orderData.order.estimated_delivery_time" class="flex items-center gap-2">
            <Icon icon="tabler:clock" width="16" height="16" class="text-muted" />
            <span class="text-sm text-text font-medium">{{ orderData.order.estimated_delivery_time }} min</span>
          </div>
        </div>
      </div>

      <div class="mb-4">
        <h3 class="text-sm font-semibold text-muted uppercase tracking-wide mb-2">Itens</h3>
        <div class="bg-white border border-border rounded-md overflow-hidden">
          <div
            v-for="(item, index) in orderData.order.items"
            :key="item.id"
          >
            <div class="p-4">
              <div class="flex justify-between">
                <span class="text-sm font-medium text-text">{{ item.quantity }}x {{ item.product_name }}</span>
                <span class="text-sm font-bold text-text">{{ FloatToMoney(item.total_price) }}</span>
              </div>
              <div v-if="item.modifiers && item.modifiers.length" class="mt-2 ml-4">
                <div
                  v-for="mod in item.modifiers"
                  :key="mod.id"
                  class="flex justify-between text-xs text-muted py-0.5"
                >
                  <span>+ {{ mod.quantity }}x {{ mod.modifier_name }} ({{ mod.group_name }})</span>
                  <span>{{ FloatToMoney(mod.unit_price * mod.quantity) }}</span>
                </div>
              </div>
              <p v-if="item.comment" class="text-xs text-muted italic mt-2 mb-0 ml-4">
                <Icon icon="tabler:message" width="12" height="12" class="inline mr-1" />
                {{ item.comment }}
              </p>
            </div>
            <hr v-if="index < orderData.order.items.length - 1" />
          </div>
        </div>
      </div>

      <div v-if="orderData.order.customer_note" class="mb-4">
        <h3 class="text-sm font-semibold text-muted uppercase tracking-wide mb-2">Observação do cliente</h3>
        <div class="text-sm text-text border border-border rounded-md p-4" style="background: var(--bg-highlight);">
          {{ orderData.order.customer_note }}
        </div>
      </div>

      <div class="mb-4">
        <h3 class="text-sm font-semibold text-muted uppercase tracking-wide mb-2">Pagamento</h3>
        <div class="bg-white border border-border rounded-md p-4 flex flex-col gap-2">
          <div class="flex justify-between text-sm">
            <span class="text-muted">Subtotal</span>
            <span class="text-text">{{ FloatToMoney(orderData.order.subtotal) }}</span>
          </div>
          <div class="flex justify-between text-sm">
            <span class="text-muted">Taxa de entrega</span>
            <span class="text-text">{{ FloatToMoney(orderData.order.delivery_fee) }}</span>
          </div>
          <div v-if="orderData.order.discount > 0" class="flex justify-between text-sm">
            <span class="text-muted">Desconto</span>
            <span class="text-success">- {{ FloatToMoney(orderData.order.discount) }}</span>
          </div>
          <hr class="my-1" />
          <div class="flex justify-between text-sm font-bold">
            <span class="text-text">Total</span>
            <strong class="text-xl text-primary">{{ FloatToMoney(orderData.order.total) }}</strong>
          </div>
          <div class="flex items-center gap-2 mt-1">
            <Icon icon="tabler:credit-card" width="14" height="14" class="text-muted" />
            <span class="text-xs text-muted">
              {{ paymentLabel }}
              <template v-if="orderData.order.change_for">
                (troco para {{ FloatToMoney(orderData.order.change_for) }})
              </template>
            </span>
          </div>
        </div>
      </div>

      <div v-if="orderData.order.rejection_reason" class="mb-4">
        <h3 class="text-sm font-semibold text-error uppercase tracking-wide mb-2">Motivo da rejeição</h3>
        <div class="text-sm border rounded-md p-4" style="background: var(--color-error-bg); border-color: var(--color-error-border); color: var(--color-error-text);">
          {{ orderData.order.rejection_reason }}
        </div>
      </div>
      <div v-if="orderData.order.cancellation_reason" class="mb-4">
        <h3 class="text-sm font-semibold text-error uppercase tracking-wide mb-2">Motivo do cancelamento</h3>
        <div class="text-sm border rounded-md p-4" style="background: var(--color-error-bg); border-color: var(--color-error-border); color: var(--color-error-text);">
          {{ orderData.order.cancellation_reason }}
        </div>
      </div>

      <div v-if="orderData.status_logs && orderData.status_logs.length">
        <h3 class="text-sm font-semibold text-muted uppercase tracking-wide mb-2">Histórico</h3>
        <div class="bg-white border border-border rounded-md p-4">
          <div
            v-for="(log, index) in orderData.status_logs"
            :key="index"
            class="flex items-center gap-3 text-xs"
            :class="{ 'mt-3': index > 0 }"
          >
            <span class="text-muted w-12 shrink-0">{{ formatTime(log.created_at) }}</span>
            <div class="w-2 h-2 rounded-full bg-primary shrink-0" />
            <span class="text-text font-medium">
              {{ getStatusConfig(statusNameFromValue(log.to_status)).label }}
            </span>
            <span class="text-muted">por {{ log.changed_by }}</span>
          </div>
        </div>
      </div>

      <div v-if="orderData.order.status === 'pending'" class="flex gap-4 mt-6">
        <AppButton
          class="w-full"
          text="Aceitar"
          iconLeft="tabler:check"
          variant="primary"
          :customStyles="{ background: 'var(--color-success)' }"
          @click="$emit('accept', orderData.order)"
        />
        <AppButton
          class="w-full"
          text="Rejeitar"
          iconLeft="tabler:x"
          variant="danger"
          @click="$emit('reject', orderData.order)"
        />
      </div>

      <div v-else-if="nextStatusLabel" class="mt-6">
        <AppButton
          class="w-full"
          :text="nextStatusLabel"
          iconLeft="tabler:arrow-right"
          variant="primary"
          @click="$emit('advance', orderData.order)"
        />
      </div>
    </div>
  </BaseModal>
</template>

<script setup>
import { computed } from 'vue'
import { Icon } from '@iconify/vue'
import BaseModal from '../ui/BaseModal.vue'
import AppButton from '../ui/AppButton.vue'
import ItemChip from '../ui/ItemChip.vue'
import { FloatToMoney } from '../../utils/modey'
import { formatTime, formatDateTime } from '../../utils/timeHelper'
import { getStatusConfig, NEXT_STATUS_LABEL, PAYMENT_METHODS } from '../../utils/orderStatusConfig'

const props = defineProps({
  orderData: { type: Object, default: null },
  loadingDetail: { type: Boolean, default: false },
})

defineEmits(['close', 'accept', 'reject', 'advance'])

const STATUS_VALUE_MAP = {
  0: 'pending',
  5: 'confirmed',
  10: 'preparing',
  15: 'ready',
  20: 'out_for_delivery',
  25: 'delivered',
  90: 'cancelled',
  95: 'rejected',
}

const STATUS_BG_MAP = {
  pending: 'var(--background-doing)',
  confirmed: 'var(--background-done)',
  preparing: 'var(--background-doing)',
  ready: 'var(--background-done)',
  out_for_delivery: 'var(--background-done)',
  delivered: 'var(--background-delivered)',
  cancelled: 'var(--color-error-bg)',
  rejected: 'var(--color-error-bg)',
}

const STATUS_COLOR_MAP = {
  pending: 'var(--color-doing)',
  confirmed: 'var(--color-done)',
  preparing: 'var(--color-doing)',
  ready: 'var(--color-done)',
  out_for_delivery: 'var(--color-done)',
  delivered: 'var(--color-delivered)',
  cancelled: 'var(--color-error)',
  rejected: 'var(--color-error)',
}

function statusNameFromValue(value) {
  return STATUS_VALUE_MAP[value] || 'pending'
}

const statusLabel = computed(() => {
  if (!props.orderData) return ''
  return getStatusConfig(props.orderData.order.status).label
})

const statusBg = computed(() => {
  if (!props.orderData) return ''
  return STATUS_BG_MAP[props.orderData.order.status] || 'var(--background-doing)'
})

const statusTextColor = computed(() => {
  if (!props.orderData) return ''
  return STATUS_COLOR_MAP[props.orderData.order.status] || 'var(--color-doing)'
})

const nextStatusLabel = computed(() => {
  if (!props.orderData) return null
  return NEXT_STATUS_LABEL[props.orderData.order.status] || null
})

const paymentLabel = computed(() => {
  if (!props.orderData) return ''
  return PAYMENT_METHODS[props.orderData.order.payment_method] || props.orderData.order.payment_method
})
</script>
