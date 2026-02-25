<template>
  <div class="bg-[#fff7f0] border border-[#ffd8af] p-8 rounded-lg flex flex-col gap-5 mt-8 w-4/5 max-[758px]:w-full max-[758px]:p-4">
    <h2 class="flex items-center text-[rgb(154,52,18)] font-semibold gap-2 m-0 text-xl">
      <Icon icon="lucide-lightbulb" width="24" height="24" />
      Seu produto tem opções?
    </h2>
    <p class="text-muted text-base m-0">
      <strong>Modificadores</strong> permitem que seus clientes personalizem o produto. Por exemplo:
    </p>

    <div class="grid grid-cols-2 gap-4 max-[600px]:grid-cols-1">
      <div v-for="example in examples" :key="example.label" class="flex-[1_1_200px] bg-white p-3 rounded-md text-left flex flex-col gap-1">
        <div class="flex items-center gap-1 text-[#d35400] font-bold">
          <span><Icon :icon="example.icon" width="24" height="24" /></span>
          <span>{{ example.label }}</span>
        </div>
        <span class="text-muted text-sm">{{ example.description }}</span>
      </div>
    </div>

    <div class="flex gap-4 [&_button]:flex-1 [&_button]:flex [&_button]:justify-center max-[600px]:flex-col">
      <AppButton
        text="Sim, adicionar opções"
        iconLeft="lucide-settings"
        @click="emit('modifiers-decision', 2)"
      />
      <AppButton
        text="Não, produto simples"
        iconLeft="lucide:target"
        variant="secondary"
        @click="emit('modifiers-decision', 3)"
      />
    </div>
  </div>
</template>

<script setup>
import { Icon } from '@iconify/vue'
import AppButton from '../../../ui/AppButton.vue'

const emit = defineEmits(['modifiers-decision'])

const examples = [
  { icon: 'noto:pizza', label: 'Pizza', description: 'Tamanhos, sabores, bordas' },
  { icon: 'noto:hamburger', label: 'Hambúrguer', description: 'Adicionais, molhos, ponto da carne' },
  { icon: 'noto:ice-cream', label: 'Açaí', description: 'Complementos, frutas, coberturas' },
  { icon: 'noto:tropical-drink', label: 'Bebidas', description: 'Tamanhos, temperaturas' },
]
</script>
