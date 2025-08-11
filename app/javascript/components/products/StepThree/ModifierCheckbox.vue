<script setup>
import { computed, ref, watch } from 'vue'
import ModifierListBase from './ModifierListBase.vue'

const props = defineProps({
  modifier_group: {
    type: Object,
    required: true
  }
})

const selectedItems = ref([])

const selectedIds = computed(() => selectedItems.value.map(i => i.id))

const isSelected = (item) => selectedIds.value.includes(item.id)

const faded = (item) =>
  selectedIds.value.length >= (props.modifier_group.max ?? Infinity) &&
  !isSelected(item)

const getBasePrice = (item) => item.base_price || 0

function toggle(item) {
  const exists = selectedIds.value.includes(item.id)

  if (exists) {
    selectedItems.value = selectedItems.value.filter(i => i.id !== item.id)
  } else {
    if (!props.modifier_group.max || selectedItems.value.length < props.modifier_group.max) {
      selectedItems.value.push(item)
    }
  }
}

watch(
  () => props.modifier_group?.selected,
  (initial) => {
    selectedItems.value = initial ?? []
  },
  { immediate: true }
)
</script>

<template>
  <ModifierListBase
    :modifier_group="modifier_group"
    :totalSelected="selectedItems.length"
    :isSelected="isSelected"
    :faded="faded"
    :toggle="toggle"
    :getBasePrice="getBasePrice"
    :multiple="true"
    :isCheckbox="true"
  />
</template>
