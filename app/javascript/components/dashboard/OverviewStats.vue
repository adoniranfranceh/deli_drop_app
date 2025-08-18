<template>
  <div class="overview-header">
    <h2>Visão geral</h2>
    <div class="times">
      <AppButton
        v-for="time in times"
        :key="time"
        :text="time"
        :selected="selectedTime === time"
        @click="selectedTime = time"
      />
    </div>
  </div>

  <div class="restaurant-info">
    <div v-for="stat in stats" :key="stat.label" class="stat">
      <div class="info-stat">
        <p class="info-title">{{ stat.label }}</p>
        <p class="info-value">{{ stat.value }}</p>
        <span class="difference">
          <Icon icon="stash:chart-trend-up" />
          {{ stat.trend > 0 ? '+' : '' }}{{ stat.trend }}%
          <div>vs {{ selectedTime }}</div>
        </span>
      </div>
      <div class="info-icon">
        <Icon :icon="iconMap[extractBase(stat.label)]" />
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

<style scoped>
.overview-header {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
}

.times {
  display: flex;
  width: 16rem;
  justify-content: space-between;
}

:deep(.cta-button) {
  height: 2rem;
  width: 5rem;
  padding: 1rem;
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: var(--color-background);
  color: var(--color-black);
  border: none;
  border-radius: 6px;
  cursor: pointer;
}

:deep(.cta-button:hover) {
  padding: 1rem;
  background-color: var(--color-border);
}

:deep(.cta-button.selected) {
  background-color: var(--color-primary);
  color: white;
}

:deep(.text-btn) {
  font-weight: 400;
  font-size: 1rem;
}

.restaurant-info {
  display: flex;
  gap: 2.5rem;
}

.stat {
  display: flex;
  justify-content: space-between;
  width: 23%;
  background: var(--color-white);
  border: 1px solid var(--color-border);
  box-shadow: var(--shadow-sm);
  border-radius: 6px;
  padding: 2rem;
  text-align: center;
}

.info-title {
  color: var(--color-muted);
  font-weight: 500;
  margin: 0;
}

.info-value {
  color: var(--color-black);
  font-weight: 700;
  font-size: 24px;
  margin: 0;
}

.difference {
  display: flex;
  align-items: center;

  svg {
    width: 1.5rem;
    height: 1.5rem;
  }
}

.restaurant-info span {
  display: flex;
  margin-top: 1.5rem;
  color: rgb(22, 163, 74);

  div {
    color: var(--color-muted);
    margin-left: 0.5rem;
  }
}

.info-stat {
  display: flex;
  flex-direction: column;
  align-items: baseline;
}

.info-icon {
  background-color: rgba(239, 68, 68, 0.125);
  color: var(--color-primary);
  width: 2.8rem;
  height: 2.8rem;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50px;

  svg {
    width: 1.3rem;
    height: 1.3rem;
  }
}

@media (max-width: 1270px) {
  .restaurant-info {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
  }

  .stat {
    width: 85%;
  }
}

@media (max-width: 758px) {
  .restaurant-info {
    display: flex;
    flex-wrap: wrap;
  }

  .stat {
    width: 100%;
  }
}


</style>
