<script setup>
import ModifierCheckbox from './ModifierCheckbox.vue'
import ModifierRadio from './ModifierRadio.vue'
import ModifierQuantity from './ModifierQuantity.vue'

const props = defineProps({
  modifier_group: Object,
})

const emit = defineEmits(['update:selected'])

const componentMap = {
  multiple_choice: ModifierCheckbox,
  single_choice: ModifierRadio,
  quantity: ModifierQuantity
}

const updateSelected = (payload) => {
  emit('update:selected', payload)
}
</script>

<template>
  <component
    :is="componentMap[modifier_group.input_type]"
    :modifier_group="modifier_group"
    @update:selected="updateSelected"
  />
</template>
