<template>
  <MenuHeader
    title="Configurações do Restaurante"
    subtitle="Gerencie as informações e configurações do seu restaurante"
    icon="lucide-store"
  >
    <template #actions>
      <AppButton 
        v-if="restaurantExists"
        text="Voltar a tela inicial"
        iconLeft="ri:arrow-left-line"
        @click="navigateTo('/')"
      />
    </template>
  </MenuHeader>
</template>

<script setup>
import AppButton from '../ui/AppButton.vue';
import MenuHeader from '../ui/MenuHeader.vue';
import { navigateTo } from '../../utils/navigation';

defineProps({
  restaurantExists: Boolean
});
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
