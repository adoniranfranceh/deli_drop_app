<template>
  <div class="input-group">
    <label v-if="label" :for="id">
      <span class="label-text">{{ label }}</span>
      <span v-if="required" class="required-asterisk">*</span>
    </label>

    <div class="currency-wrapper">
      <span class="currency-icon"><Icon icon="lucide:dollar-sign" /></span>
      <input
        :id="id"
        type="text"
        :value="displayValue"
        @keydown="onKeyDown"
        @input="onInput"
        @blur="onBlur"
      />
    </div>

    <p class="error">
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

<style scoped>
.input-group {
  display: flex;
  flex-direction: column;
  flex: 1;
  min-width: 0;
  gap: 0.5rem;
}

label {
  font-weight: 500;
  color: var(--color-black);
  display: flex;
  align-items: center;
  gap: 0.4rem;
}

.label-text {
  flex: none;
}

.required-asterisk {
  color: var(--color-danger, red);
}

.currency-wrapper {
  position: relative;
  display: flex;
  align-items: center;
}

.currency-icon {
  position: absolute;
  left: 0.75rem;
  pointer-events: none;
  color: var(--color-muted);
}

input {
  padding: 0.75rem 0.75rem 0.75rem 2rem;
  border: 1px solid var(--color-border);
  border-radius: 6px;
  font-size: 1rem;
  width: 100%;
  text-align: center;
}

input:focus {
  border: 2px solid var(--color-primary);
  outline: none;
  box-shadow: var(--shadow-sm);
}

.error {
  color: var(--color-danger, red);
  font-size: 0.85rem;
  min-height: 1.2rem;
  margin: 0;
}
</style>
