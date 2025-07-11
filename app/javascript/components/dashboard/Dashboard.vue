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
import QuickActions from './components/dashboard/QuickActions.vue';
import OverviewStats from './components/dashboard/OverviewStats.vue'
import RecentOrders from './components/dashboard/RecentOrders.vue'
import RestaurantInfo from './components/dashboard/RestaurantInfo.vue'
import PerformanceChart from './components/dashboard/PerformanceChart.vue'
</script>
