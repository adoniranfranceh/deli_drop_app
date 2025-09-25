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
  
  <ul class="modifiers">
    <li
    v-for="item in modifier_group.modifiers"
    :key="item.id"
    class="modifiers-options"
    >
      <div class="content-option">
        <div class="item-details">
          <img :src="item.image" :alt="item.name" class="item-image" />
          <div class="item-info">
            {{ item.name }}
            <div class="free-modifier">{{ getPriceLabel(item) }}</div>
          </div>
        </div>

        <div class="quantity-controls">
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


<style scoped>
.header-modifier {
  background: var(--color-background);
  padding: 1rem;
}

.modifier-chip {
  background-color: var(--color-primary);
  color: var(--color-white);
}

.header-title {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin: 0;
}

.header-info {
  display: flex;
  font-size: 0.875rem;
  color: var(--color-muted);
  
  p {
    margin: 0;
    margin-right: 0.2rem;
  }
}

.modifier-free {
  margin-top: 0.5rem;
  color: var(--color-success);
  font-weight: 600;
}


.modifiers {
  padding: 0;
}

.modifiers-options {
  display: grid;
  border-bottom: 1px solid var(--color-border);
  padding: 1.5rem 1rem 0.5rem 0.5rem;
}

.content-option {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.item-details {
  display: flex;
  align-items: center;
  height: 50px;
}

.item-info {
  display: flex;
  flex-direction: column;
  justify-content: space-around;
  height: 100%;
}

.item-image {
  width: 2.5rem;
  height: 2.5rem;
  border-radius: 0.25rem;
  margin-right: 1rem;
  object-fit: cover;
}

.free-modifier {
  color: var(--color-primary);
}

.quantity-controls {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.quantity-controls button {
  background-color: #eee;
  border: none;
  padding: 0.4rem 0.6rem;
  border-radius: 4px;
  cursor: pointer;
}

.quantity-controls button:disabled {
  opacity: 0.4;
  cursor: not-allowed;
}

.chip-maxed {
  background-color: var(--color-primary);
}
</style>
