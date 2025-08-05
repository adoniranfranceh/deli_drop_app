<template>
  <label class="toggle-wrapper">
    <input
      type="checkbox"
      :checked="checked"
      @change="emit('update:modelValue', $event.target.checked)"
    />
    <span class="toggle-switch"></span>
    <span class="label-text">{{ label }}</span>
  </label>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  modelValue: Boolean,
  label: String
})

const emit = defineEmits(['update:modelValue'])

const checked = computed({
  get: () => props.modelValue,
  set: value => emit('update:modelValue', value)
})
</script>

<style scoped>
.toggle-wrapper {
  display: inline-flex;
  align-items: center;
  gap: 0.6em;
  cursor: pointer;
  font-size: 1rem;
}

.toggle-wrapper input[type="checkbox"] {
  appearance: none;
  display: none !important;
}

.toggle-switch {
  width: 50px;
  height: 28px;
  background-color: var(--color-border);
  border-radius: 999px;
  position: relative;
  transition: background-color 0.3s ease;
}

.toggle-switch::before {
  content: '';
  position: absolute;
  left: 3px;
  top: 3px;
  width: 22px;
  height: 22px;
  background-color: var(--color-white);
  border-radius: 50%;
  transition: transform 0.3s ease;
  box-shadow: var(--shadow-sm);
}

input[type="checkbox"]:checked + .toggle-switch {
  background-color: var(--color-primary);
}

input[type="checkbox"]:checked + .toggle-switch::before {
  transform: translateX(22px);
}

.label-text {
  font-weight: 500;
}

@media (max-width: 600px) {
  .toggle-wrapper {
    font-size: 0.95rem;
    gap: 0.5em;
  }

  .toggle-switch {
    width: 44px;
    height: 24px;
  }

  .toggle-switch::before {
    width: 20px;
    height: 20px;
    top: 2px;
    left: 2px;
  }

  input[type="checkbox"]:checked + .toggle-switch::before {
    transform: translateX(18px);
  }
}
</style>
