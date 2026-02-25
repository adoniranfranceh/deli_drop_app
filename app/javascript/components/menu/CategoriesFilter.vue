<template>
  <div class="flex items-center justify-between max-[758px]:flex-col max-[758px]:items-start">
    <h2 class="text-xl font-bold">Gerenciar Categorias</h2>
    <AppButton
      text="Nova Categoria"
      class="max-[758px]:w-full max-[758px]:flex max-[758px]:justify-center max-[758px]:mb-4"
      iconLeft="tabler:plus"
      @click="openCategory"
    />
  </div>
  <div class="flex justify-between bg-white rounded-lg p-4 border border-border gap-4">
    <SearchInput class="flex-1 max-[758px]:p-0" />
  </div>
</template>

<script setup>
import AppButton from '../ui/AppButton.vue'
import SearchInput from '../ui/SearchInput.vue'

const emit = defineEmits(['openCategoryModal'])

function openCategory() {
  emit('openCategoryModal')
}
</script>
