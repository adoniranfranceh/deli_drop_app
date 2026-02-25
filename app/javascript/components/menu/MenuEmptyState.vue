<template>
  <div class="bg-white border border-border rounded-lg p-12 text-center text-muted mt-8">
    <Icon icon="tabler:package" width="72" height="72" class="mb-4 text-border" />
    <p class="font-semibold text-xl text-muted m-0">{{ product ? 'Nenhum produto encontrado' : 'Nenhuma categoria encontrada' }} </p>
    <p class="text-base text-muted mb-4">Comece adicionando {{ product ? 'seu primeiro produto' : 'sua primeira categoria' }}</p>
    <AppButton
      iconLeft="tabler:plus"
      :text="`Adicionar ${product ? 'Produtos' : 'Categorias'}`"
      @click="`${product ? emit('openProductForm') : emit('openCategoryModal')}`"
    />
  </div>
</template>

<script setup>
import { Icon } from '@iconify/vue'
import AppButton from '../ui/AppButton.vue';

defineProps({
  product: {
    type: Boolean,
    default: false,
  }
})

const emit = defineEmits(['openProductForm', 'openCategoryModal'])
</script>
