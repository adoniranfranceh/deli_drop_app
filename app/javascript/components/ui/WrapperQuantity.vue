<template>
  <div class="flex items-center justify-center gap-2 p-2 transition-all duration-200">
    <span v-if="!noLabel" class="font-semibold text-lg max-[1000px]:hidden">Quantidade:</span>
    <button
      class="w-9 h-9 border border-border bg-white rounded-full flex items-center justify-center cursor-pointer transition-all duration-200 text-[0] disabled:opacity-50 disabled:cursor-not-allowed"
      @click.stop="decreaseQuantity"
      :disabled="modelValue <= min"
      v-if="!justPlus"
    >
      <span><Icon icon="lucide:minus" class="w-5 h-5 text-black" /></span>
    </button>
    <span v-if="!justPlus" class="text-xl font-bold text-text mx-2.5">{{ modelValue }}</span>
    <button
      :class="justPlus
        ? 'w-9 h-9 bg-primary border border-border rounded-full flex items-center justify-center cursor-pointer transition-all duration-200 text-[0] disabled:opacity-50 disabled:cursor-not-allowed'
        : 'w-9 h-9 border border-border bg-white rounded-full flex items-center justify-center cursor-pointer transition-all duration-200 text-[0] disabled:opacity-50 disabled:cursor-not-allowed'"
      @click.stop="increaseQuantity"
      :disabled="disablePlus"
    >
      <span><Icon icon="lucide:plus" :class="justPlus ? 'w-5 h-5 text-white' : 'w-5 h-5 text-black'" /></span>
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
