<template>
  <div class="flex flex-col flex-1 min-w-0 gap-2 relative">
    <label :for="id" v-if="label" class="font-medium text-black flex gap-1 justify-center relative">
      <span class="flex-none">{{ label }}</span>
      <span v-if="required" class="text-error">*</span>
    </label>

    <component
      :is="isTextarea ? 'textarea' : 'input'"
      :id="id"
      :type="type"
      :placeholder="placeholder"
      :value="modelValue"
      @input="$emit('update:modelValue', $event.target.value)"
      @blur="onBlur"
      :rows="isTextarea ? 4 : null"
      :disabled="disabled"
      class="p-3 border border-border rounded-md text-base focus:border-2 focus:border-primary focus:outline-none focus:shadow-sm resize-none"
    />

    <p class="text-error text-sm min-h-5 m-0">
      <span v-if="touched && externalError">{{ externalError }}</span>
      <span v-else>&nbsp;</span>
    </p>
  </div>
</template>

<script setup>
import { toRef } from 'vue'
import { useField } from '../../composables/useFields'

const props = defineProps({
  id: String,
  label: String,
  modelValue: [String, Number],
  type: { type: String, default: 'text' },
  disabled: Boolean,
  placeholder: String,
  isTextarea: Boolean,
  required: Boolean,
  externalError: String,
})

const emit = defineEmits(['update:modelValue'])

const value = toRef(props, 'modelValue')
const { touched, onBlur } = useField()
</script>
