<template>
  <MenuOverview @openCategoryModal="openCategoryForm"/>
  <div class="menu">
    <div class="menu-center">
      <MenuCards />
      <TabMenu @changeTab="handleTabChange" />

      <div v-show="tab === 'products'" class="products-tab">
        <ProductsMenuFilters @changeView="handleViewChange" />
        <div v-if="productsList.length > 0" class="products-container">
          <CardProducts
            v-for="product in productsList"
            :product="product"
          />
        </div>
        <MenuEmptyState v-else :product="true" @openProductForm="navigateTo('/products/new')"/>
      </div>

      <div v-show="tab === 'categories'">
        <CategoriesFilter @openCategoryModal="openCategoryForm"/>
        <div v-if="categoriesList.length > 0" class="categories-container">
          <CategoriesCard
            v-for="category in categoriesList"
            :key="category.id"
            :category="category"
            @openCategoryForm="openCategoryForm(category)"
          />
        </div>
        <MenuEmptyState v-else @openCategoryModal="openCategoryForm"  />
      </div>
    </div>
  </div>

  <CategoryFormModal
    v-if="openModal"
    @close="closeModal"
    :categoryData="selectedCategory"
    @saved="handleCategorySaved"
  />
</template>

<script setup>
import { ref, reactive } from 'vue'
import MenuOverview from './MenuOverview.vue'
import MenuCards from './MenuCards.vue'
import ProductsMenuFilters from './ProductsMenuFilters.vue'
import MenuEmptyState from './MenuEmptyState.vue'
import TabMenu from './TabMenu.vue'
import CategoriesFilter from './CategoriesFilter.vue'
import CategoryFormModal from '../category/CategoryFormModal.vue'
import { navigateTo } from '../../utils/navigation'
import CategoriesCard from '../category/CategoriesCard.vue'
import CardProducts from '../products/CardProducts.vue'

const props = defineProps({
  categories: Object,
  products: Object,
})

const openModal = ref(false)
const selectedCategory = ref(null)
const categoriesList = reactive([...props.categories])
const productsList = reactive([...props.products])

function openCategoryForm(category = null) {
  selectedCategory.value = category
  openModal.value = true
}

function closeModal() {
  openModal.value = false
  selectedCategory.value = null
}

const tab = ref('products')

function handleCategorySaved(savedCategory) {
  if (!savedCategory.id) return;

  const index = categoriesList.findIndex(c => c.id === savedCategory.id)

  if (index >= 0) {
    categoriesList[index] = savedCategory;
  } else {
    categoriesList.push(savedCategory)
  }

  productsList.forEach(product => {
    if (product.category_id === savedCategory.id) {
      product.category_name = savedCategory.name;
    }
  });
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

.products-container,
.categories-container {
  display: grid;
  gap: 2rem;
  margin: 2rem auto;
  padding: 0 1rem;
  grid-template-columns: repeat(1, 1fr);
}

@media (min-width: 758px) {
  .products-container,
  .categories-container {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (min-width: 958px) {
  .products-container,
  .categories-container {
    grid-template-columns: repeat(3, 1fr);
  }
}

@media (min-width: 1250px) {
  .products-container,
  .categories-container {
    grid-template-columns: repeat(4, 1fr);
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
