<template>
  <div class="w-full">
    <div class="flex gap-4 pb-4">
      <span
        class="font-medium text-muted cursor-pointer transition-colors duration-200 ml-3"
        :class="{ '!text-primary': currentTab === 'products' }"
        @click="selectTab('products')"
      >
        Produtos
      </span>
      <span
        class="font-medium text-muted cursor-pointer transition-colors duration-200 ml-3"
        :class="{ '!text-primary': currentTab === 'categories' }"
        @click="selectTab('categories')"
      >
        Categorias
      </span>
    </div>
    <div class="relative h-0 -mt-0.5">
      <div
        class="w-[90px] h-0.5 bg-primary transition-transform duration-300"
        :style="{ transform: currentTab === 'products' ? 'translateX(0%)' : 'translateX(113%)' }"
      ></div>
    </div>
    <hr />
  </div>
</template>

<script setup>
import { ref } from 'vue'

const emit = defineEmits(['changeTab'])

const currentTab = ref('products')

function selectTab(tab) {
  currentTab.value = tab
  emit('changeTab', tab)
}
</script>
