<template>
  <MenuHeader
    :title="title"
    subtitle="Preencha as informações do produto"
    >
    <template #actions>
      <AppButton text="Voltar ao menu" iconLeft="ri:arrow-left-line" @click="navigateTo('/menu')"/>
    </template>
  </MenuHeader>
</template>

<script setup>
import AppButton from '../../../ui/AppButton.vue';
import MenuHeader from '../../../ui/MenuHeader.vue';
import { navigateTo } from '../../../../utils/navigation';

defineProps({
  title: {
    type: String,
    required: true
  }
})
</script>

<style scoped>
:deep(.cta-button) {
  background-color: var(--color-white);
  border: 1px solid var(--color-border);
  color: var(--color-black);
}

:deep(.cta-button:hover) {
  background-color: var(--color-border);
}
</style>
