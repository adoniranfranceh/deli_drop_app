<template>
  <button
    :style="customStyles"
    :class="[buttonClasses, { selected }]"
    @click="handleClick"
  >
    <span class="flex items-center justify-center text-lg max-[600px]:text-sm font-normal gap-2 group-hover:gap-4 transition-all duration-300 m-0">
      <Icon v-if="iconLeft" :icon="iconLeft" class="transition-transform duration-300 group-hover:translate-x-1" />
      {{ text }}
      <Icon v-if="icon" :icon="icon" class="transition-transform duration-300 group-hover:translate-x-1" />
    </span>
  </button>
</template>

<script setup>
import { computed } from 'vue'
import { Icon } from '@iconify/vue'

const props = defineProps({
  path: String,
  text: String,
  selected: Boolean,
  icon: String,
  iconLeft: String,
  customStyles: Object,
  variant: {
    type: String,
    default: 'primary'
  }
})

const emit = defineEmits(['click'])

const baseClasses = 'py-[0.7rem] px-6 max-[600px]:px-4 rounded-lg no-underline font-medium inline-block transition-all duration-300 overflow-hidden cursor-pointer hover:scale-105 disabled:opacity-70 disabled:cursor-not-allowed disabled:pointer-events-none group'

const variantClasses = computed(() => {
  const variants = {
    primary: 'bg-primary text-white border-none hover:bg-primary-hover',
    secondary: 'bg-white text-black border border-border hover:bg-border',
    danger: 'bg-white text-primary border border-border hover:bg-border',
    ghost: 'bg-transparent text-inherit border-none p-1 hover:scale-100 hover:opacity-70'
  }
  return variants[props.variant] || variants.primary
})

const buttonClasses = computed(() => `${baseClasses} ${variantClasses.value}`)

function handleClick(event) {
  event.stopPropagation()
  emit('click', event)
}
</script>
