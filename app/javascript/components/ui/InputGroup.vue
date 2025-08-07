<template>
  <div class="input-group">
    <label :for="id" v-if="label">
      <span class="label-text">{{ label }}</span>
      <span v-if="required" class="required-asterisk">*</span>
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
    />

    <p class="error">
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
  placeholder: String,
  isTextarea: Boolean,
  required: Boolean,
  externalError: String,
})

const emit = defineEmits(['update:modelValue'])

const value = toRef(props, 'modelValue')
const { touched, onBlur } = useField()
</script>

<style scoped>
.input-group {
  display: flex;
  flex-direction: column;
  flex: 1;
  min-width: 0;
  gap: 0.5rem;
  position: relative;
}

label {
  font-weight: 500;
  color: var(--color-black);
  display: flex;
  gap: 0.4rem;
  justify-content: center;
  position: relative;
}

.label-text {
  flex: none;
}

.required-asterisk {
  color: red;
}

input,
textarea {
  padding: 0.75rem;
  border: 1px solid var(--color-border);
  border-radius: 6px;
  font-size: 1rem;
}

input:focus,
textarea:focus {
  border: 2px solid var(--color-primary);
  outline: none;
  box-shadow: var(--shadow-sm);
}

textarea {
  resize: none;
}

.error {
  color: red;
  font-size: 0.85rem;
  min-height: 1.2rem;
  margin: 0;
}
</style>
