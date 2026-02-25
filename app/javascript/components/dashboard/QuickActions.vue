<template>
  <h2 class="m-0 flex justify-center text-xl font-bold">Ações rápidas</h2>
  <div class="flex gap-6 max-[758px]:flex-wrap">
    <div
      v-for="action in actions"
      :key="action.label"
      class="w-[23%] bg-white border border-primary rounded-md py-6 px-4 text-center cursor-pointer transition-shadow duration-200 hover:bg-background max-[758px]:w-full"
      @click="navigateTo(action.path)"
    >
      <div class="flex justify-center mb-2"><Icon :icon="action.icon" width="26" height="26" /></div>
      <span class="flex justify-center font-medium text-black">{{ action.label }}</span>
    </div>
  </div>
</template>

<script setup>
import { Icon } from '@iconify/vue';
import { navigateTo } from '../../utils/navigation';

const actions = [
  { label: 'Gerenciar Menu', icon: 'tabler:chef-hat', path: '/menu' },
  { label: 'Ver Pedidos', icon: 'iconoir:bell', path: '/orders' },
  { label: 'Horários', icon: 'lucide:calendar', path: '/schedules' },
  { label: 'Área de Entrega', icon: 'tdesign:location', path: '/delivery-area' }
]
</script>
