<template>
  <div class="flex flex-col gap-4 p-2 bg-background rounded-lg min-h-32">
    <label class="font-medium text-black flex gap-1.5 justify-center relative" for="ingredients">Ingredientes</label>
    <div class="flex gap-2 items-end [&_p]:hidden">
      <InputGroup
        id="ingredients"
        v-model="ingredient"
        placeholder="Digite um ingrediente"
        @keyup.enter="addIngredient"
      />
      <AppButton
        text="Incluir"
        :disabled="ingredient.trim() === ''"
        @click="addIngredient"
      />
    </div>
    <div class="flex flex-wrap gap-2 min-w-0 [&>span]:max-w-full [&>span]:break-words [&>span]:whitespace-normal [&>span]:shrink" v-if="ingredients.length">
      <ItemChip
        v-for="(item, index) in ingredients"
        :key="index"
        :item="item"
        @remove="removeIngredient(index)"
      />
    </div>
  </div>
</template>

<script setup>
import { ref, watch } from 'vue'
import InputGroup from '../../../ui/InputGroup.vue'
import AppButton from '../../../ui/AppButton.vue'
import ItemChip from '../../../ui/ItemChip.vue'

const props = defineProps({
  modelValue: { type: [Array, Object], default: () => [] }
})
const emit = defineEmits(['update:modelValue'])

const ingredient = ref('')
const ingredients = props.modelValue

watch(() => props.modelValue, (newVal) => {
  ingredients.value = [...newVal]
})

watch(ingredients, () => {
  emit('update:modelValue', ingredients.value)
}, { deep: true })

function addIngredient() {
  const newIngredient = ingredient.value.trim()
  if (newIngredient && !ingredients.value.includes(newIngredient)) {
    ingredients.value.push(newIngredient)
  }
  ingredient.value = ''
}

function removeIngredient(index) {
  ingredients.value.splice(index, 1)
}
</script>
