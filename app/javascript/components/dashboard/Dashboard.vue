<template>
  <div class="dashboard-container">
    <QuickActions />
    <OverviewStats />
    <div class="dashboard-main">
      <div class="dashboard-left">
        <RecentOrders />
      </div>
      <div class="dashboard-right">
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

<style scoped>
.dashboard-container {
  display: flex;
  flex-direction: column;
  padding: 2rem;
  gap: 2rem;
}

.dashboard-main {
  display: flex;
  gap: 2rem;
}

.dashboard-left {
  flex: 2;
  display: flex;
  flex-direction: column;
  gap: 2rem;
}

.dashboard-right {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 2rem;
}
</style>