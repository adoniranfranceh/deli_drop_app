<template>
  <BaseModal @close="$emit('close')">
    <div class="max-w-[400px] mx-auto">
      <h2 class="text-xl font-bold text-text mb-1">Aceitar Pedido</h2>
      <p class="text-sm text-muted mb-6">Pedido <strong>{{ order.code }}</strong> — {{ order.customer_name }}</p>

      <label class="block text-sm font-medium text-text mb-2">
        Tempo estimado de entrega (minutos)
      </label>
      <input
        ref="inputRef"
        v-model.number="estimatedTime"
        type="number"
        min="5"
        max="180"
        placeholder="Ex: 30"
        class="input-base number-input mb-6"
      />

      <div class="flex gap-4">
        <AppButton
          class="w-full"
          text="Cancelar"
          variant="secondary"
          @click="$emit('close')"
        />
        <AppButton
          class="w-full"
          :text="submitting ? 'Aceitando...' : 'Confirmar'"
          iconLeft="tabler:check"
          variant="primary"
          :customStyles="{ background: 'var(--color-success)' }"
          :class="{ 'opacity-50 pointer-events-none': !estimatedTime || estimatedTime < 5 || submitting }"
          @click="handleAccept"
        />
      </div>
    </div>
  </BaseModal>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import BaseModal from '../ui/BaseModal.vue'
import AppButton from '../ui/AppButton.vue'

const props = defineProps({
  order: { type: Object, required: true }
})

const emit = defineEmits(['close', 'accept'])

const estimatedTime = ref(30)
const submitting = ref(false)
const inputRef = ref(null)

onMounted(() => {
  inputRef.value?.focus()
})

async function handleAccept() {
  if (!estimatedTime.value || estimatedTime.value < 5) return
  submitting.value = true
  try {
    emit('accept', props.order.id, estimatedTime.value)
  } finally {
    submitting.value = false
  }
}
</script>
