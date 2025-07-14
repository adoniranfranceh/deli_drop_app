<template>
  <div>
    <QuickActions />
    <OverviewStats />
    <div>
      <div>
        <RecentOrders />
      </div>
      <div>
        <RestaurantInfo />
        <PerformanceChart />
      </div>
    </div>
  </div>
</template>

<script setup>
import QuickActions from './QuickActions.vue';
import OverviewStats from './OverviewStats.vue'
import RecentOrders from './RecentOrders.vue'
import RestaurantInfo from './RestaurantInfo.vue'
import PerformanceChart from './PerformanceChart.vue'
</script>
