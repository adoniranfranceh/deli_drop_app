<template>
  <div class="border border-border shadow-sm rounded-md bg-white py-4 px-12">
    <div class="flex items-center justify-between max-[758px]:flex-col">
      <h2 class="flex justify-center w-auto text-xl font-bold max-[1500px]:w-[180px] max-[758px]:w-full">Informações do restaurante</h2>
      <AppButton
        text="Editar"
        @click="navigateTo(`/restaurants/${restaurantData?.id}/edit`)"
        iconLeft="lucide-pen-line"
        variant="secondary"
        class="max-[758px]:w-full"
      />
    </div>
    <div class="flex my-4">
      <img
        alt="restaurant-img"
        class="w-16 h-16 rounded-[10px] mr-4"
        src="https://cdn.pixabay.com/photo/2016/03/05/19/02/hamburger-1238246_1280.jpg"
      />

      <div class="flex flex-col justify-center">
        <h3 class="m-0 font-bold">Hamburgueria Top</h3>
      </div>
    </div>

    <hr>

    <div class="flex flex-col py-4 gap-4">
      <div v-for="info in informations" class="flex justify-between">
        <span class="text-muted font-medium">{{ info.label }}</span>
        <span class="text-black font-semibold text-base">{{ info.value }}</span>
      </div>
    </div>
  </div>
</template>

<script setup>
import AppButton from '../ui/AppButton.vue'
import { navigateTo } from '../../utils/navigation'

defineProps({
  restaurantData: Object
})

const informations = [
  { label: 'Avaliação', value: '4.8' },
  { label: 'Tempo médio', value: '25,35 min' },
  { label: 'Taxa de entrega', value: 'Grátis' }
]
</script>
