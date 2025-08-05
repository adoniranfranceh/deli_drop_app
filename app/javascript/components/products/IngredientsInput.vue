<template>
  <div class="ingredients-wrapper">
    <label class="input-label" for="ingredients">Ingredientes</label>
    <div class="form-line">
      <InputGroup
        id="ingredients"
        v-model="ingredient"
        placeholder="Digite um ingredientes"
        @keyup.enter="addIngredient"
      />
      <AppButton
        text="Incluir"
        :disabled="ingredient.trim() === ''"
        @click="addIngredient"
      />
    </div>
    <div class="chips-container" v-if="ingredients.length">
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
import InputGroup from '../ui/InputGroup.vue'
import AppButton from '../ui/AppButton.vue'
import ItemChip from '../ui/ItemChip.vue'

const props = defineProps({
  modelValue: { type: Array, default: () => [] }
})
const emit = defineEmits(['update:modelValue'])

const ingredient = ref('')
const ingredients = ref([...props.modelValue])

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

<style scoped>
.input-label {
  font-weight: 500;
  color: var(--color-black);
  display: flex;
  gap: 0.4rem;
  justify-content: center;
  position: relative;
}

.ingredients-wrapper {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  padding: 0.5rem;
  background-color: var(--color-light-background);
  border-radius: 8px;
  min-height: 8rem;
}

.form-line {
  display: flex;
  gap: 0.5rem;
  align-items: flex-start;
}

:deep(.input-group .error) {
  display: none;
}

.chips-container {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
  min-width: 0;
}

.chips-container > span {
  max-width: 100%;
  word-break: break-word;
  white-space: normal;
  flex-shrink: 1;
}
</style>
