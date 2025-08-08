<template>
  <div class="quantity-wrapper">
    <span v-if="!noLabel" class="label-quantity">Quantidade:</span>
    <button
      class="btn"
      @click.stop="decreaseQuantity"
      :disabled="modelValue <= min"
      v-if="!justPlus"
    >
      <span><Icon icon="lucide:minus" class="icon" /></span>
    </button>
    <span class="value" v-if="!justPlus">{{ modelValue }}</span>
    <button
      :class="!justPlus ? 'btn' : 'btn-just-plus'"
      @click.stop="increaseQuantity"
      :disabled="disablePlus"
    >
      <span><Icon icon="lucide:plus" class="icon"/></span>
    </button>
  </div>
</template>

<script setup>
import { Icon } from '@iconify/vue'

const props = defineProps({
  modelValue: Number,
  noLabel: Boolean,
  min: { type: Number, default: 1 },
  justPlus: Boolean,
  disablePlus: Boolean
})

const emit = defineEmits(['plus', 'minus'])

const increaseQuantity = () => {
  if (!props.disablePlus) {
    emit('plus', props.modelValue)
  }
}

const decreaseQuantity = () => {
  if (props.modelValue > props.min) {
    emit('minus', props.modelValue)
  }
}
</script>

<style scoped>
.quantity-wrapper {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  padding: 0.5rem;
  transition: all 0.2s ease;
}

.label-quantity {
  font-weight: 600;
  font-size: 1.125rem;
}

.btn {
  width: 2.2rem;
  height: 2.2rem;
  border: 1px solid var(--color-border);
  background-color: var(--color-white);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.2s ease;
  font-size: 0;

  .icon {
    width: 1.2rem;
    height: 1.2rem;
    color: var(--color-black);
  }
}

.btn-just-plus {
  background-color: var(--color-primary);
  width: 2.2rem;
  height: 2.2rem;
  border: 1px solid var(--color-border);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.2s ease;
  font-size: 0;

  .icon {
    width: 1.2rem;
    height: 1.2rem;
    color: var(--color-white);
  }
}

.btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.btn-just-plus:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.value {
  font-size: 1.25rem;
  font-weight: 700;
  color: var(--color-text);
  margin: 0 10px;
}

@media (max-width: 1000px) {
  .label-quantity {
    display: none;
  }
}
</style>
