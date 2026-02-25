<template>
  <div class="flex items-baseline justify-between">
    <h2 class="text-xl font-bold">Visão geral</h2>
    <div class="flex gap-2">
      <AppButton
        v-for="time in times"
        :key="time"
        :text="time"
        :variant="selectedTime === time ? 'primary' : 'ghost'"
        :selected="selectedTime === time"
        class="!h-8 !px-4 !py-2 !rounded-md [&_span]:!text-base [&_span]:!font-normal"
        :class="selectedTime !== time ? '!bg-background !text-black hover:!bg-border' : ''"
        @click="selectedTime = time"
      />
    </div>
  </div>

  <div class="flex gap-10 max-[1270px]:grid max-[1270px]:grid-cols-2 max-[758px]:flex max-[758px]:flex-wrap">
    <div v-for="stat in stats" :key="stat.label" class="flex justify-between w-[23%] bg-white border border-border shadow-sm rounded-md p-8 text-center max-[1270px]:w-[85%] max-[758px]:w-full">
      <div class="flex flex-col items-baseline">
        <p class="text-muted font-medium m-0">{{ stat.label }}</p>
        <p class="text-black font-bold text-2xl m-0">{{ stat.value }}</p>
        <span class="flex items-center mt-6 text-success [&_div]:text-muted [&_div]:ml-2">
          <Icon icon="stash:chart-trend-up" width="24" height="24" />
          {{ stat.trend > 0 ? '+' : '' }}{{ stat.trend }}%
          <div>vs {{ selectedTime }}</div>
        </span>
      </div>
      <div class="bg-primary/10 text-primary w-11 h-11 flex items-center justify-center rounded-full">
        <Icon :icon="iconMap[extractBase(stat.label)]" width="20" height="20" />
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, ref } from 'vue';
import { Icon } from '@iconify/vue';
import AppButton from '../ui/AppButton.vue';

const times = ['Hoje', 'Semana', 'Mês'];
const selectedTime = ref('Hoje');

const iconMap = {
  Vendas: 'lucide:dollar-sign',
  Pedidos: 'mingcute:shopping-bag-3-line',
  Tempo: 'mdi:clock-outline',
  Avaliação: 'ci:star'
}

const extractBase = (label) => {
  if (label.startsWith('Vendas')) return 'Vendas'
  if (label.startsWith('Pedidos')) return 'Pedidos'
  if (label.startsWith('Tempo')) return 'Tempo'
  if (label.startsWith('Avaliação')) return 'Avaliação'
  return ''
}

const allStats = {
  Hoje: [
    { label: 'Vendas hoje', value: 'R$ 2.847,30', trend: 12.5 },
    { label: 'Pedidos hoje', value: '47', trend: 8.2 },
    { label: 'Tempo médio', value: '28 min', trend: -3.1 },
    { label: 'Avaliação', value: '4.8', trend: 0.2 },
  ],
  Semana: [
    { label: 'Vendas na semana', value: 'R$ 15.420,00', trend: 9.3 },
    { label: 'Pedidos na semana', value: '312', trend: 5.4 },
    { label: 'Tempo médio', value: '26 min', trend: -4.1 },
    { label: 'Avaliação média', value: '4.7', trend: -0.1 },
  ],
  Mês: [
    { label: 'Vendas no mês', value: 'R$ 62.380,00', trend: 11.8 },
    { label: 'Pedidos no mês', value: '1.249', trend: 6.7 },
    { label: 'Tempo médio', value: '27 min', trend: -2.6 },
    { label: 'Avaliação média', value: '4.75', trend: 0.3 },
  ]
}

const stats = computed(() => allStats[selectedTime.value]);
</script>
