<template>
  <MenuHeader
    title="Central do Menu"
    subtitle="Gerencie seus produtos de forma simples e eficiente"
  >
    <template #actions>
      <AppButton
        text="Nova Categoria"
        iconLeft="tabler:plus"
        class="new-category"
        @click="emit('openCategoryModal')"
      />
      <AppButton
        text="Novo Produto"
        iconLeft="tabler:plus"
        @click="navigateTo('/products/new')"
      />
    </template>
  </MenuHeader>
</template>

<script setup>
import AppButton from '../ui/AppButton.vue';
import MenuHeader from '../ui/MenuHeader.vue';

const navigateTo = (path) => {
  if (path) window.location.href = path
}

const emit = defineEmits(['openCategoryModal'])
</script>

<style scoped>
.new-category {
  background-color: var(--color-white);
  color: var(--color-black);
  border: 1px solid var(--color-border);
}

.new-category:hover {
  background-color: var(--color-border);
}
</style>
