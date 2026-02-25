<template>
  <div class="flex justify-between bg-white rounded-lg p-4 border border-border gap-4 max-[758px]:flex-col max-[758px]:items-stretch">
    <SearchInput class="flex-1 max-[758px]:p-0" />
    <div class="flex flex-col gap-4">
      <InputDropdown
        class="gap-0 max-[758px]:p-0 max-[758px]:w-full"
        placeholder="Todas as categorias"
        :options="[
          { label: 'Bebidas', value: 'bebidas' },
          { label: 'Comidas', value: 'comidas' },
          { label: 'Sobremesas', value: 'sobremesas' }
        ]"
      />
      <div class="flex gap-2 justify-end">
        <button
          class="bg-white border border-border rounded-md py-1.5 pl-3 pr-5 cursor-pointer text-black flex max-[758px]:w-full max-[758px]:justify-center max-[758px]:items-center max-[758px]:gap-4"
          :class="{ '!bg-primary !text-white !border-primary': activeView === 'grid' }"
          @click="setView('grid')"
        >
          <Icon icon="ic:round-grid-on" width="20" height="20" />
          <span class="hidden max-[758px]:block">Grade</span>
        </button>
        <button
          class="bg-white border border-border rounded-md py-1.5 pl-3 pr-5 cursor-pointer text-black flex max-[758px]:w-full max-[758px]:justify-center max-[758px]:items-center max-[758px]:gap-4"
          :class="{ '!bg-primary !text-white !border-primary': activeView === 'list' }"
          @click="setView('list')"
        >
          <Icon icon="material-symbols:list-rounded" width="20" height="20" />
          <span class="hidden max-[758px]:block">Lista</span>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { Icon } from '@iconify/vue'
import SearchInput from '../ui/SearchInput.vue';
import InputDropdown from '../ui/InputDropdown.vue';

const emit = defineEmits(['changeView'])
const activeView = ref('grid')

function setView(view) {
  activeView.value = view
  emit('changeView', view)
}
</script>
