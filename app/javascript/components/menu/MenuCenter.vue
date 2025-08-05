<template>
  <MenuOverview />
  <div class="menu">
    <div class="menu-center">
      <MenuCards />
      <TabMenu @changeTab="handleTabChange" />

      <div v-show="tab === 'products'" class="products-tab">
        <ProductsMenuFilters @changeView="handleViewChange" />
        <MenuEmptyState :product="true"/>
      </div>

      <div v-show="tab === 'categories'">
        <CategoriesFilter
          @changeView="handleViewChange"
        />
        <MenuEmptyState />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import MenuOverview from './MenuOverview.vue'
import MenuCards from './MenuCards.vue'
import ProductsMenuFilters from './ProductsMenuFilters.vue'
import MenuEmptyState from './MenuEmptyState.vue'
import TabMenu from './TabMenu.vue'
import CategoriesFilter from './CategoriesFilter.vue'

const tab = ref('products')

function handleViewChange(view) {
  console.log('Visualização selecionada:', view)
}

function handleTabChange(view) {
  tab.value = view
}
</script>

<style scoped>
.menu {
  display: flex;
  justify-content: center;
}

.menu-center {
  display: flex;
  flex-direction: column;
  padding: 2rem;
  gap: 2rem;
  background-color: var(--color-background);
  margin: 0 2rem;
  width: 1820px;
}

.tab {
  display: flex;
  gap: 1rem;
}

@media (max-width: 758px) {
  .menu-center {
    width: 100%;
    margin: 0;
    padding: 1rem;
  }
}
</style>
