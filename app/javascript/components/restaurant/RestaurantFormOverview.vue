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

defineProps({
  restaurantExists: Boolean
});
</script>
