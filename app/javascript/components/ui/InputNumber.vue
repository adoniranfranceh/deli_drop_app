<template>
  <div class="input-group">
    <label :for="id" v-if="label">
      <span class="label-text">{{ label }}</span>
      <span v-if="required" class="required-asterisk">*</span>
    </label>

    <div class="number-wrapper">
      <input
      :id="id"
      type="number"
      :placeholder="placeholder"
      :value="modelValue"
      step="1"
      inputmode="numeric"
      @input="onInput"
      @blur="onBlur"
      class="number-input"
      :disabled="disabled"
    />
      <div class="controls">
        <button
          type="button"
          class="control-btn"
          @click="increment"
          :disabled="modelValue >= max || disabled"
        >
          <Icon icon="mdi:chevron-up" class="control-icon" />
        </button>
        <button
          type="button"
          class="control-btn"
          @click="decrement"
          :disabled="modelValue <= min || disabled"
        >
          <Icon icon="mdi:chevron-down" class="control-icon" />
        </button>
      </div>
    </div>

    <p class="error">
      <span v-if="touched && externalError">{{ externalError }}</span>
      <span v-else>&nbsp;</span>
    </p>
  </div>
</template>

<script setup>
import { toRef } from 'vue'
import { Icon } from '@iconify/vue'
import { useField } from '../../composables/useFields'

const props = defineProps({
  id: String,
  label: String,
  modelValue: [String, Number],
  placeholder: String,
  required: Boolean,
  min: { type: Number, default: -Infinity },
  max: { type: Number, default: Infinity },
  disabled: { type: Boolean, default: false },
  externalError: String
})

const emit = defineEmits(['update:modelValue'])

const value = toRef(props, 'modelValue')
const { touched } = useField({ modelValue: value, required: props.required })

function increment() {
  const current = Number(props.modelValue) || 0
  const next = current + 1
  if (next <= props.max) emit('update:modelValue', next)
  touched.value = true
}

function decrement() {
  const current = Number(props.modelValue) || 0
  const next = current - 1
  if (next >= props.min) emit('update:modelValue', next)
  touched.value = true
}

function onInput(event) {
  emit('update:modelValue', event.target.value)
}

function onBlur(event) {
  touched.value = true
  let val = Number(event.target.value)

  if (isNaN(val) || event.target.value === '') return

  if (val > props.max) val = props.max
  if (val < props.min) val = props.min

  emit('update:modelValue', val)
}

</script>

<style scoped>
.input-group {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  position: relative;
  flex: 1;
  min-width: 85px;
}

label {
  font-weight: 500;
  color: var(--color-black);
  display: flex;
  justify-content: center;
  gap: 0.4rem;
  position: relative;
}

.label-text {
  flex: none;
}

.required-asterisk {
  color: red;
}

.number-wrapper {
  position: relative;
  display: flex;
  align-items: center;
  min-width: 5rem;
  max-width: 100%;
}

.number-input {
  width: 100%;
  min-width: 1rem;
  padding: 0.7rem 1rem;
  padding-right: 2.25rem;
  border: 1px solid var(--color-border);
  border-radius: 6px;
  font-size: 1rem;
  text-align: center;
  appearance: none;
  box-sizing: border-box;
  flex: 1 1 0;
}

.number-input:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.number-input:focus {
  border: 2px solid var(--color-primary);
  outline: none;
  box-shadow: var(--shadow-sm);
}

.number-input::-webkit-inner-spin-button,
.number-input::-webkit-outer-spin-button {
  -webkit-appearance: none;
  margin: 0;
}

.controls {
  position: absolute;
  right: 0.1rem;
  top: 0.1rem;
  bottom: 0.4rem;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  gap: 0.2rem;
}

.control-btn {
  background: transparent;
  padding: 0 4px;
  cursor: pointer;
  line-height: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  height: 1.2rem;
  transition: opacity 0.2s ease;
}

.control-btn:disabled {
  opacity: 0.4;
  cursor: not-allowed;
}

.control-icon {
  color: var(--color-primary);
  font-size: 1.25rem;
}

.error {
  color: red;
  font-size: 0.85rem;
  min-height: 1.2rem;
  margin: 0;
}

@media (max-width: 758px) {
  .label-text {
    font-size: 0.8rem;
  }
}
</style>
