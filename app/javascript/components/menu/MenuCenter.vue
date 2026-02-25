<template>
  <MenuOverview @openCategoryModal="openCategoryForm"/>
  <div class="flex justify-center">
    <div class="flex flex-col p-8 gap-8 bg-background mx-8 max-w-[1820px] w-full max-[758px]:w-full max-[758px]:mx-0 max-[758px]:p-4">
      <MenuCards />
      <TabMenu @changeTab="handleTabChange" />

      <div v-show="tab === 'products'">
        <ProductsMenuFilters @changeView="handleViewChange" />
        <div v-if="productsList.length > 0" class="grid gap-8 my-8 px-4 grid-cols-1 min-[758px]:grid-cols-2 min-[958px]:grid-cols-3 min-[1250px]:grid-cols-4 min-[1250px]:my-12">
          <CardProducts
            v-for="product in productsList"
            :product="product"
          />
        </div>
        <MenuEmptyState v-else :product="true" @openProductForm="navigateTo('/products/new')"/>
      </div>

      <div v-show="tab === 'categories'">
        <CategoriesFilter @openCategoryModal="openCategoryForm"/>
        <div v-if="categoriesList.length > 0" class="grid gap-8 my-8 px-4 grid-cols-1 min-[758px]:grid-cols-2 min-[958px]:grid-cols-3 min-[1250px]:grid-cols-4 min-[1250px]:my-12">
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
