<template>
  <div class="dashboard-header">
    <h1 class="title">Dashboard</h1>
    <p class="welcome-msg">Bem-vindo de volta, Hamburgueria Top</p>
  </div>
  <div class="dashboard">
    <div class="dashboard-container">
      <QuickActions />
      <OverviewStats />
      <div class="dashboard-main">
        <div class="dashboard-left">
          <RecentOrders />
        </div>
        <div class="dashboard-right">
          <RestaurantInfo />
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
</script>

<style scoped>
.dashboard-header {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  width: 20rem;
  margin: 3rem 0 0 3rem;
}

.title{
  font-size: 30px;
  font-weight: 700;
  margin: 0;
}

.welcome-msg {
  margin-top: 0.5rem;
  font-weight: 400;
  color: var(--color-muted);
}

.dashboard {
  display: flex;
  justify-content: center;
}

.dashboard-container {
  display: flex;
  flex-direction: column;
  padding: 2rem;
  gap: 2rem;
  background-color: var(--color-background);
  margin: 2rem;
  width: 1820px;
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
@media (max-width: 900px) {
  .dashboard-main{
    flex-direction: column;
  }
}

@media (max-width: 758px) {
  .dashboard-container {
    width: 100%;
    margin: 0;
  }
}
</style>