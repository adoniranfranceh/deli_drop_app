<template>
  <MenuOverview @openCategoryModal="openCategoryForm"/>
  <div class="menu">
    <div class="menu-center">
      <MenuCards />
      <TabMenu @changeTab="handleTabChange" />

      <div v-show="tab === 'products'" class="products-tab">
        <ProductsMenuFilters @changeView="handleViewChange" />
        <MenuEmptyState :product="true" @openProductForm="navigateTo('/products/new')"/>
      </div>

      <div v-show="tab === 'categories'">
        <CategoriesFilter @openCategoryModal="openCategoryForm"/>
        <div v-if="categories.length > 0" class="categories-container">
          <CategoriesCard
            v-for="category in categories"
            :category="category"
          />
        </div>
        <MenuEmptyState v-else @openCategoryModal="openCategoryForm"  />
      </div>
    </div>
  </div>

  <CategoryFormModal v-if="openModal" @close="closeModal"/>
</template>

<script setup>
import { ref } from 'vue'
import MenuOverview from './MenuOverview.vue'
import MenuCards from './MenuCards.vue'
import ProductsMenuFilters from './ProductsMenuFilters.vue'
import MenuEmptyState from './MenuEmptyState.vue'
import TabMenu from './TabMenu.vue'
import CategoriesFilter from './CategoriesFilter.vue'
import CategoryFormModal from '../category/CategoryFormModal.vue'
import { navigateTo } from '../../utils/navigation'
import CategoriesCard from '../category/CategoriesCard.vue'

defineProps({
  categories: Object
})

const tab = ref('products')

const openModal = ref(false)

function openCategoryForm() {
  openModal.value = true
}

function closeModal() {
  openModal.value = false
}

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

.categories-container {
  display: grid;
  gap: 2rem;
  margin: 2rem auto;
  padding: 0 1rem;
  grid-template-columns: repeat(1, 1fr);
}

 @media (min-width: 758px) {
  .categories-container {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (min-width: 1250px) {
  .categories-container {
    grid-template-columns: repeat(3, 1fr);
    margin: 3rem auto;
  }
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
