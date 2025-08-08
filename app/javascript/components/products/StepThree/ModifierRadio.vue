<script setup>
import { computed, ref, watch } from 'vue';
import ModifierListBase from './ModifierListBase.vue';

const props = defineProps({
  modifier_group: {
    type: Object,
    required: true,
  },
});

const selectedItem = ref(null);

const isSelected = (item) => selectedItem.value?.id === item.id;

const faded = (item) =>
  selectedItem.value && !isSelected(item);

const getBasePrice = (item) => item.base_price || 0;

function toggle(item) {
  // Se o item já estiver selecionado, deseleciona.
  // Caso contrário, seleciona o novo item.
  if (isSelected(item)) {
    selectedItem.value = null;
  } else {
    selectedItem.value = item;
  }
}

watch(
  () => props.modifier_group?.selected,
  (initial) => {
    // Para seleção única, pegamos o primeiro item do array, se existir.
    selectedItem.value = initial?.[0] ?? null;
  },
  { immediate: true },
);
</script>

<template>
  <ModifierListBase
    :modifier_group="modifier_group"
    :totalSelected="selectedItem ? 1 : 0"
    :isSelected="isSelected"
    :faded="faded"
    :toggle="toggle"
    :getBasePrice="getBasePrice"
    :multiple="false"
    :isRadio="true"
  />
</template>
