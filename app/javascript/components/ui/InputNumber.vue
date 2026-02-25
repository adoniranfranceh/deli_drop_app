<template>
  <div class="flex flex-col gap-2 relative flex-1 min-w-[85px]">
    <label :for="id" v-if="label" class="font-medium text-black flex justify-center gap-1 relative">
      <span class="flex-none max-[758px]:text-[0.7rem]">{{ label }}</span>
      <span v-if="required" class="text-error">*</span>
    </label>

    <div class="relative flex items-center min-w-20 max-w-full">
      <input
        :id="id"
        type="number"
        :placeholder="placeholder"
        :value="modelValue"
        step="1"
        inputmode="numeric"
        @input="onInput"
        @blur="onBlur"
        :disabled="disabled"
        class="number-input w-full min-w-4 py-3 pl-4 pr-9 border border-border rounded-md text-base text-center appearance-none box-border flex-1 disabled:opacity-50 disabled:cursor-not-allowed focus:border-2 focus:border-primary focus:outline-none focus:shadow-sm"
      />
      <div class="absolute right-0.5 top-0.5 bottom-1 flex flex-col justify-between gap-0.5">
        <button
          type="button"
          class="bg-transparent p-0 px-1 cursor-pointer leading-none flex items-center justify-center h-5 transition-opacity duration-200 disabled:opacity-40 disabled:cursor-not-allowed"
          @click="increment"
          :disabled="modelValue >= max || disabled"
        >
          <Icon icon="mdi:chevron-up" class="text-primary text-xl" />
        </button>
        <button
          type="button"
          class="bg-transparent p-0 px-1 cursor-pointer leading-none flex items-center justify-center h-5 transition-opacity duration-200 disabled:opacity-40 disabled:cursor-not-allowed"
          @click="decrement"
          :disabled="modelValue <= min || disabled"
        >
          <Icon icon="mdi:chevron-down" class="text-primary text-xl" />
        </button>
      </div>
    </div>

    <p class="text-error text-sm min-h-8 m-0">
      <span v-if="touched && externalError" v-html="externalError"></span>
      <span v-else>&nbsp;</span>
    </p>
  </div>
</template>

<script setup>
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

const { touched } = useField()

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
