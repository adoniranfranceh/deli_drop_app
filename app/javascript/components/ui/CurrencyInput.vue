<template>
  <div class="flex flex-col flex-1 min-w-0 gap-2">
    <label v-if="label" :for="id" class="font-medium text-black flex justify-center gap-1">
      <span class="flex-none">{{ label }}</span>
      <span v-if="required" class="text-error">*</span>
    </label>

    <div class="relative flex items-center">
      <span class="absolute left-3 pointer-events-none text-muted">
        <Icon icon="lucide:dollar-sign" />
      </span>
      <input
        :id="id"
        type="text"
        :value="displayValue"
        @keydown="onKeyDown"
        @input="onInput"
        @blur="onBlur"
        class="py-3 pr-3 pl-8 border border-border rounded-md text-base w-full text-center focus:border-2 focus:border-primary focus:outline-none focus:shadow-sm"
      />
    </div>

    <p class="text-error text-sm min-h-5 m-0">
      <span v-if="touched && externalError">{{ externalError }}</span>
      <span v-else>&nbsp;</span>
    </p>
  </div>
</template>

<script setup>
import { Icon } from '@iconify/vue'
import { ref, computed, watch, toRef } from 'vue'
import { useField } from '../../composables/useFields'

const props = defineProps({
  id: String,
  modelValue: Number,
  label: String,
  required: Boolean,
  externalError: String,
})

const emit = defineEmits(['update:modelValue'])

const value = toRef(props, 'modelValue')
const { touched, onBlur } = useField({ modelValue: value, required: props.required })

const internalValue = ref(props.modelValue || 0)

watch(() => props.modelValue, (newVal) => {
  internalValue.value = newVal || 0
})

const displayValue = computed(() => {
  return formatCurrency(internalValue.value)
})

function formatCurrency(valueInCents) {
  const reais = (valueInCents / 100).toFixed(2)
  return `${reais.replace('.', ',')}`
}

function onInput(event) {
  let digits = event.target.value.replace(/\D/g, '')
  const value = parseInt(digits || '0', 10)
  internalValue.value = value
  emit('update:modelValue', value)
}

function onKeyDown(event) {
  if (event.key === 'Backspace' || event.key === 'Delete') {
    event.preventDefault()
    const digits = internalValue.value.toString().padStart(3, '0')
    const shortened = digits.slice(0, -1)
    const newValue = parseInt(shortened || '0', 10)
    internalValue.value = newValue
    emit('update:modelValue', newValue)
  }

  if (event.key.length === 1 && !/\d/.test(event.key)) {
    event.preventDefault()
  }
}
</script>
