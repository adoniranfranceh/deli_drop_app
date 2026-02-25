<template>
  <MenuHeader
    :title="title"
    subtitle="Preencha as informações do produto"
    >
    <template #actions>
      <AppButton text="Voltar ao menu" iconLeft="ri:arrow-left-line" variant="secondary" @click="navigateTo('/menu')"/>
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
