<template>
  <div class="flex flex-col gap-5 w-4/5 p-8 bg-white border border-border rounded-lg max-[758px]:w-full max-[758px]:p-1.5 max-[758px]:m-0">
    <div class="flex justify-between items-center gap-2 max-[758px]:flex-col">
      <div>
        <h2 class="flex items-center gap-2 font-bold m-0 text-xl max-[758px]:text-lg">
          <Icon icon="lucide:settings" width="24" height="24" class="text-primary" /> Grupos de Modificadores
        </h2>
        <p class="text-sm text-muted m-0 max-[758px]:text-xs">Configure opções de personalização para este produto</p>
      </div>
    </div>

    <div v-if="groups.length === 0 || groups.every(g => g._destroy)" class="text-center border-2 border-dashed border-border p-6 rounded-lg mt-4">
      <Icon icon="lucide:settings" width="56" height="56" class="w-full text-border" />
      <h3 class="mt-4 text-muted font-medium">Crie seu primeiro grupo</h3>
      <p class="mt-2 text-muted">
        Grupos organizam as opções. Por exemplo: "Tamanhos", "Adicionais", "Sabores"
      </p>

      <div class="flex gap-4 justify-center flex-wrap mt-4">
        <button
          class="bg-white border border-border p-4 rounded-md w-[200px] text-center cursor-pointer flex flex-col gap-1 transition-all duration-200 hover:border-primary hover:bg-primary/10"
          @click="addGroup('single_choice')"
        >
          <strong class="text-primary text-base">Escolha Única</strong>
          <span class="text-sm text-muted">Cliente escolhe 1</span>
        </button>

        <button
          class="bg-white border border-border p-4 rounded-md w-[200px] text-center cursor-pointer flex flex-col gap-1 transition-all duration-200 hover:border-primary hover:bg-primary/10"
          @click="addGroup('multiple_choice')"
        >
          <strong class="text-primary text-base">Múltipla Escolha</strong>
          <span class="text-sm text-muted">Cliente escolhe vários</span>
        </button>

        <button
          class="bg-white border border-border p-4 rounded-md w-[200px] text-center cursor-pointer flex flex-col gap-1 transition-all duration-200 hover:border-primary hover:bg-primary/10"
          @click="addGroup('quantity')"
        >
          <strong class="text-primary text-base">Quantidade</strong>
          <span class="text-sm text-muted">Cliente define quantos</span>
        </button>
      </div>
    </div>

    <div v-else>
      <ModifierGroupCard
        v-for="(group, index) in groups.filter(g => !g._destroy)"
        :key="group.id"
        :group="group"
        :index="index"
        @remove-group="removeGroup"
        @add-modifier="addModifier"
        @remove-modifier="removeModifier"
      />
      <AppButton
        text="Adicionar Grupo"
        iconLeft="ic:round-plus"
        variant="secondary"
        @click="addGroup('')"
      />
    </div>
  </div>
</template>

<script setup>
import { toRef, watch} from 'vue'
import { Icon } from '@iconify/vue'
import AppButton from '../../../ui/AppButton.vue'
import ModifierGroupCard from './ModifierGroupCard.vue'

const props = defineProps({
  modelValue: {
    type: Array,
    default: () => []
  }
})
const emit = defineEmits(['update:modelValue'])

const groups = toRef(props, 'modelValue')

watch(groups, () => {
  emit('update:modelValue', groups)
}, { deep: true })

function addGroup(type = '') {
  let max = null
  let free_limit = null

  if (type === 'single_choice') {
    max = 1
    free_limit = 1
  }

  groups.value.push({
    name: null,
    input_type: type,
    min: null,
    max: max,
    free_limit: free_limit,
    modifiers: []
  })
}

function removeGroup(index) {
  groups.value[index]._destroy = true
}

function addModifier(index) {
  groups.value[index].modifiers.push({
    name: null,
    base_price: null,
    image: null,
  })
}

function removeModifier(groupIndex, modifierIndex) {
  groups.value[groupIndex].modifiers[modifierIndex]._destroy = true
}
</script>
