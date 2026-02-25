<template>
  <div class="flex flex-col justify-center items-center w-80 mt-12 ml-12 max-[758px]:mt-4 max-[758px]:ml-0 max-[758px]:w-full">
    <h1 class="text-[30px] font-bold m-0">Dashboard</h1>
    <p class="mt-2 font-normal text-muted">Bem-vindo de volta, {{ restaurantData?.name }}</p>
  </div>
  <div class="flex justify-center">
    <div class="flex flex-col p-8 gap-8 bg-background m-8 max-w-[1820px] w-full max-[758px]:p-4 max-[758px]:m-0">
      <QuickActions />
      <OverviewStats />
      <div class="flex gap-8 max-[900px]:flex-col">
        <div class="flex-[2] flex flex-col gap-8">
          <RecentOrders />
        </div>
        <div class="flex-1 flex flex-col gap-8">
          <RestaurantInfo :restaurantData="restaurantData" />
          <PerformanceChart
            :metrics="[
              { label: 'Visualizações', total: 1000, value: 234, suffix: '' },
              { label: 'Taxa de conversão', total: 100, value: 20.1, suffix: '%' },
            ]"
          />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import QuickActions from './QuickActions.vue';
import OverviewStats from './OverviewStats.vue';
import RecentOrders from './RecentOrders.vue';
import RestaurantInfo from './RestaurantInfo.vue';
import PerformanceChart from './PerformanceChart.vue';

defineProps({
  restaurantData: Object
})
</script>
