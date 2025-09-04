<template>
  <div class="select-group" ref="dropdownRef">
    <label :for="id || 'product-select'" @click="toggleDropdown">
      <span class="label-text">{{ label }}</span>

      <span v-if="required" class="required-asterisk">*</span>
    </label>

    <div class="dropdown-wrapper" @click="toggleDropdown">
      <div class="dropdown-display" @click="toggleDropdown">
        <input
          :id="id || 'product-select'"
          v-model="searchQuery"
          :placeholder="selectedPlaceholder"
          class="dropdown-input"
          :class="{ 'has-value': selected }"
          @click.stop
          @focus="toggleDropdown()"
        />
        <Icon icon="line-md:chevron-down" class="dropdown-icon" />
      </div>

      <div v-if="isOpen" class="dropdown-menu">
        <div
          v-for="option in filteredOptions"
          :key="option.value"
          class="dropdown-item"
          :class="{ selected: option.value === selected }"
          @click.stop="selectOption(option.value)"
        >
          <Icon
            v-if="option.value === selected"
            icon="material-symbols:check-rounded"
            class="check-icon"
          />
          <span>{{ option.label }}</span>
        </div>
      </div>
    </div>

    <p class="error">
      <span v-if="(touched || forceShowError) && externalError">{{ externalError }}</span>
      <span v-else>&nbsp;</span>
    </p>
  </div>
</template>

<script setup>
import { ref, computed, watch, onMounted, onBeforeUnmount, toRef } from 'vue'
import { Icon } from '@iconify/vue'
import { useField } from '../../composables/useFields'

const props = defineProps({
  id: String,
  placeholder: String,
  options: {
    type: Array,
    default: () => [],
  },
  modelValue: {
    type: String,
    default: '',
  },
  label: String,
  required: Boolean,
  externalError: String,
  forceShowError: Boolean
})

const searchQuery = ref("")
const emit = defineEmits(['update:modelValue'])

const selected = ref(props.modelValue)
const isOpen = ref(false)
const dropdownRef = ref(null)
const wasInteracted = ref(false)

watch(() => props.modelValue, (newVal) => {
  selected.value = newVal
})

const toggleDropdown = () => {
  isOpen.value = !isOpen.value
  if (isOpen.value) wasInteracted.value = true
}

const selectOption = (value) => {
  selected.value = value
  emit('update:modelValue', value)
  searchQuery.value = ""
  isOpen.value = false
  onBlur()
}

const allOptions = computed(() => [
  { label: props.placeholder, value: '' },
  ...props.options,
])

const filteredOptions = computed(() => {
  if (!searchQuery.value) return allOptions.value
  return allOptions.value.filter(option =>
    option.label.toLowerCase().includes(searchQuery.value.toLowerCase())
  )
})

const selectedPlaceholder = computed(() => {
  const selectedOption = allOptions.value.find(o => o.value === selected.value)
  return selectedOption ? selectedOption.label : props.placeholder
})

const value = toRef(props, 'modelValue')
const { touched, onBlur } = useField({ modelValue: value, required: props.required })

const handleClickOutside = (event) => {
  if (dropdownRef.value && !dropdownRef.value.contains(event.target)) {
    isOpen.value = false
    if (wasInteracted.value) {
      onBlur()
    }
  }
}

onMounted(() => {
  document.addEventListener('click', handleClickOutside)
})

onBeforeUnmount(() => {
  document.removeEventListener('click', handleClickOutside)
})
</script>

<style scoped>
.select-group {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  position: relative;
}

label {
  display: flex;
  justify-content: center;
  gap: 0.4rem;
  font-weight: 500;
  color: var(--color-black);
}

.label-text {
  flex: none;
}

.required-asterisk {
  color: red;
}

.dropdown-wrapper {
  position: relative;
  width: 100%;
  font-size: 1rem;
}

.dropdown-display {
  padding-right: 0.5rem;
  border: 1px solid var(--color-border);
  border-radius: 6px;
  background-color: var(--color-white);
  display: flex;
  justify-content: space-between;
  align-items: center;
  cursor: pointer;
}

.dropdown-input {
  width: 100%;
  height: 100%;
  border: none;
  outline: none;
  background: transparent;
  padding: 0.75rem;
  font-size: 1rem;
  color: var(--color-black);
}

.dropdown-input::placeholder {
  color: var(--color-muted);
}

.dropdown-input.has-value::placeholder {
  color: var(--color-black);
}

.dropdown-icon {
  color: var(--color-muted);
}

.dropdown-menu {
  position: absolute;
  top: 110%;
  left: 0;
  right: 0;
  background: var(--color-white);
  border: 1px solid var(--color-border);
  border-radius: 6px;
  box-shadow: var(--shadow-sm);
  z-index: 10;
  max-height: 200px;
  overflow-y: auto;
}

.dropdown-item {
  padding: 8px 12px;
  cursor: pointer;
  display: flex;
  align-items: center;
}

.dropdown-item span {
  padding-left: 0.25rem;
}

.dropdown-display:hover,
.dropdown-display:focus {
  border: 2px solid var(--color-primary);
  box-shadow: var(--shadow-sm);
}

.dropdown-item.selected {
  background-color: #f0f4ff;
}

.check-icon {
  height: 1.2rem;
  width: 1.2rem;
}

.error {
  color: red;
  font-size: 0.85rem;
  min-height: 1.2rem;
  margin: 0;
}
</style>
