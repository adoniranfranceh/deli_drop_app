<template>
  <MenuHeader
    title="Central do Menu"
    subtitle="Gerencie seus produtos de forma simples e eficiente"
  >
    <template #actions>
      <AppButton
        text="Nova Categoria"
        iconLeft="tabler:plus"
        variant="secondary"
        @click="emit('openCategoryModal')"
      />
      <AppButton
        text="Novo Produto"
        iconLeft="tabler:plus"
        @click="navigateTo('/products/new')"
      />
      <AppButton
        text="Voltar a tela inicial"
        iconLeft="ri:arrow-left-line"
        variant="secondary"
        @click="navigateTo('/')"
      />
    </template>
  </MenuHeader>
</template>

<script setup>
import AppButton from '../ui/AppButton.vue';
import MenuHeader from '../ui/MenuHeader.vue';
import { navigateTo } from '../../utils/navigation';

const emit = defineEmits(['openCategoryModal'])
</script>
