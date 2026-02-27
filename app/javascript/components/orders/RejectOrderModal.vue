<template>
  <BaseModal @close="$emit('close')">
    <div class="max-w-[400px] mx-auto">
      <h2 class="text-xl font-bold text-text mb-1">Rejeitar Pedido</h2>
      <p class="text-sm text-muted mb-6">Pedido <strong>{{ order.code }}</strong> — {{ order.customer_name }}</p>

      <label class="block text-sm font-medium text-text mb-2">
        Motivo da rejeição
      </label>
      <textarea
        ref="textareaRef"
        v-model="reason"
        rows="3"
        placeholder="Ex: Restaurante fechando, sem ingredientes..."
        class="input-base resize-none mb-6"
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
          :text="submitting ? 'Rejeitando...' : 'Rejeitar pedido'"
          iconLeft="tabler:x"
          variant="danger"
          :class="{ 'opacity-50 pointer-events-none': !reason.trim() || submitting }"
          @click="handleReject"
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

const emit = defineEmits(['close', 'reject'])

const reason = ref('')
const submitting = ref(false)
const textareaRef = ref(null)

onMounted(() => {
  textareaRef.value?.focus()
})

async function handleReject() {
  if (!reason.value.trim()) return
  submitting.value = true
  try {
    emit('reject', props.order.id, reason.value.trim())
  } finally {
    submitting.value = false
  }
}
</script>
