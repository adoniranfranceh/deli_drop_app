<template>
  <div
    class="bg-white rounded-lg overflow-hidden transition-all duration-200 border border-border flex flex-col cursor-pointer hover:scale-[1.02] hover:shadow-md"
    @click="$emit('select', order)"
  >
    <div
      v-if="order.status === 'pending'"
      class="h-1 w-full"
      :style="{ background: 'var(--background-doing)' }"
    />

    <div class="p-4 flex-1 flex flex-col justify-between">
      <div>
        <div class="flex justify-between items-center mb-3">
          <span class="text-xl font-medium text-text">#{{ order.code }}</span>
          <ItemChip
            :item="statusConfig.label"
            :style="{ background: statusBg, color: statusColor }"
          />
        </div>

        <div class="flex items-center gap-2 mb-1">
          <Icon icon="tabler:user" width="16" height="16" class="text-muted" />
          <span class="text-base text-text font-medium">{{ order.customer_name }}</span>
        </div>
        <div class="flex items-center gap-2 mb-3">
          <Icon icon="tabler:phone" width="16" height="16" class="text-muted" />
          <span class="text-sm text-muted">{{ order.customer_phone }}</span>
        </div>

        <div class="flex justify-between items-center mb-2">
          <span class="text-muted text-sm">{{ order.items_count }} {{ order.items_count === 1 ? 'item' : 'itens' }}</span>
          <strong class="text-xl font-bold text-primary">{{ FloatToMoney(order.total) }}</strong>
        </div>

        <div v-if="order.status === 'pending'" class="mb-2">
          <ExpiresCountdown :expiresAt="order.expires_at" />
        </div>

        <p class="text-xs text-muted m-0">{{ relativeTime(order.created_at) }}</p>
      </div>
    </div>

    <div class="flex gap-4 p-4 border-t border-border" @click.stop>
      <template v-if="order.status === 'pending'">
        <AppButton
          class="w-full"
          text="Aceitar"
          iconLeft="tabler:check"
          variant="primary"
          :customStyles="{ background: 'var(--color-success)' }"
          @click="$emit('accept', order)"
        />
        <AppButton
          class="w-full"
          text="Rejeitar"
          iconLeft="tabler:x"
          variant="danger"
          @click="$emit('reject', order)"
        />
      </template>

      <template v-else-if="nextStatusLabel">
        <AppButton
          class="w-full"
          :text="nextStatusLabel"
          iconLeft="tabler:arrow-right"
          variant="primary"
          @click="$emit('advance', order)"
        />
      </template>

      <template v-else>
        <AppButton
          class="w-full"
          text="Ver detalhes"
          iconLeft="tabler:eye"
          variant="secondary"
          @click="$emit('select', order)"
        />
      </template>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { Icon } from '@iconify/vue'
import { FloatToMoney } from '../../utils/modey'
import { relativeTime } from '../../utils/timeHelper'
import { NEXT_STATUS_LABEL, getStatusConfig } from '../../utils/orderStatusConfig'
import AppButton from '../ui/AppButton.vue'
import ItemChip from '../ui/ItemChip.vue'
import ExpiresCountdown from './ExpiresCountdown.vue'

const props = defineProps({
  order: { type: Object, required: true }
})

defineEmits(['select', 'accept', 'reject', 'advance'])

const statusConfig = computed(() => getStatusConfig(props.order.status))
const nextStatusLabel = computed(() => NEXT_STATUS_LABEL[props.order.status] || null)

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

const statusBg = computed(() => STATUS_BG_MAP[props.order.status] || 'var(--background-doing)')
const statusColor = computed(() => STATUS_COLOR_MAP[props.order.status] || 'var(--color-doing)')
</script>
