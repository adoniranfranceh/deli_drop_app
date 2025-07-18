<template>
  <div class="tab-container">
    <div class="tab">
      <span
        :class="{ active: currentTab === 'products' }"
        @click="selectTab('products')"
      >
        Produtos
      </span>
      <span
        :class="{ active: currentTab === 'categories' }"
        @click="selectTab('categories')"
      >
        Categorias
      </span>
    </div>
    <div class="underline-container">
      <div
        class="underline"
        :style="{ transform: currentTab === 'products' ? 'translateX(0%)' : 'translateX(113%)' }"
      ></div>
    </div>
    <hr />
  </div>
</template>

<script setup>
import { ref } from 'vue'

const emit = defineEmits('changeTab')

const currentTab = ref('products')

function selectTab(tab) {
  currentTab.value = tab
  emit('changeTab', tab)
}
</script>

<style scoped>
.tab-container {
  width: 100%;
}

.tab {
  display: flex;
  gap: 1rem;
  padding-bottom: 1rem;
}

.tab span {
  font-weight: 500;
  color: var(--color-muted);
  cursor: pointer;
  transition: color 0.2s;
  margin-left: 0.7rem;
}

.tab span.active {
  color: var(--color-primary);
}

.underline-container {
  position: relative;
  height: 0px;
  margin-top: -2px;
}

.underline {
  width: 90px;
  height: 2px;
  background-color: var(--color-primary);
  transition: transform 0.3s;
}
</style>
