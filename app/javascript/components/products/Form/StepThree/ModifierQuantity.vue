<script setup>
import { ref, computed, watch } from 'vue'
import WrapperQuantity from '../../../ui/WrapperQuantity.vue'
import ModifierHeader from './ModifierHeader.vue'
import { FloatToMoney } from '../../../../utils/modey'

const props = defineProps({
  modifier_group: { type: Object, required: true }
})

const emit = defineEmits(['update:selected'])

const quantities = ref({})
const extraPrice = ref(0)

const modifiers = computed(() => (props.modifier_group.modifiers || []).filter(m => !m._destroy))

const totalSelected = computed(() =>
  Object.values(quantities.value).reduce((sum, entry) => sum + (entry?.quantity || 0), 0)
)

const reachedMax = computed(() =>
  props.modifier_group.max && totalSelected.value >= props.modifier_group.max
)

const getQty = (item) => {
  return quantities.value[item.id]?.quantity ?? 0
}

function updateQuantity(item, delta) {
  const currentQty = getQty(item)
  const newQty = Math.max(0, currentQty + delta)

  const copy = { ...quantities.value }

  if (newQty === 0) {
    delete copy[item.id]
  } else {
    copy[item.id] = { item, quantity: newQty }
  }

  quantities.value = copy
  emitUpdate();
}

const increment = (item) => {
  if (reachedMax.value) return
  const freeLimit = props.modifier_group.free_limit
  const totalBeforeIncrement = totalSelected.value
  
  if (totalBeforeIncrement >= freeLimit) {
    extraPrice.value += item.base_price || 0
  }
  updateQuantity(item, 1)
}

const decrement = (item) => {
  if (getQty(item) > 0) {
    const freeLimit = props.modifier_group.free_limit
    const totalBeforeDecrement = totalSelected.value
    
    if (totalBeforeDecrement > freeLimit) {
      extraPrice.value -= item.base_price || 0
    }
    updateQuantity(item, -1)
  }
}

function emitUpdate() {
  emit('update:selected', {
    group_id: props.modifier_group.id,
    items: {
      quantities: { ...quantities.value }
    },
    extra_price: extraPrice.value
  });
}

watch(
  () => props.modifier_group?.selected,
  (initial) => {
    quantities.value = initial?.quantities || {}
  },
  { immediate: true }
)

function getPriceLabel(item) {
  const freeLimit = props.modifier_group.free_limit ?? 0
  const isFree = totalSelected.value < freeLimit
  if (freeLimit === props.modifier_group.max) {
    return 'Grátis'
  }
  return isFree ? 'Grátis' : `+ ${FloatToMoney(item.base_price || 0)}`
}

const headerProps = computed(() => ({
  name: props.modifier_group.name,
  min: props.modifier_group.min,
  max: props.modifier_group.max,
  freeLimit: props.modifier_group.free_limit,
  totalSelected: totalSelected.value
}))
</script>

<template>
  <ModifierHeader v-bind="headerProps" />

  <ul class="p-0 list-none">
    <li
      v-for="item in modifiers"
      :key="item.id"
      class="grid border-b border-border pt-6 pr-4 pb-2 pl-2"
    >
      <div class="flex justify-between items-center">
        <div class="flex items-center h-[50px]">
          <img :src="item.image" :alt="item.name" class="w-10 h-10 rounded mr-4 object-cover" />
          <div class="flex flex-col justify-around h-full">
            {{ item.name }}
            <div class="text-primary font-semibold">{{ getPriceLabel(item) }}</div>
          </div>
        </div>

        <div class="flex items-center gap-2">
          <WrapperQuantity
            :modelValue="quantities[item.id]?.quantity ?? 0"
            @plus="() => increment(item)"
            @minus="() => decrement(item)"
            :noLabel="true"
            :min="0"
            :disablePlus="reachedMax"
            :justPlus="getQty(item) <= 0"
          />
        </div>
      </div>
    </li>
  </ul>
</template>


