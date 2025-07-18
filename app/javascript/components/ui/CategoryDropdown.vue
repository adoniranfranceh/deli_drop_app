<template>
  <div class="dropdown-wrapper" @click="toggleDropdown">
    <div class="dropdown-display">
      <span>{{ selectedLabel }}</span>
      <Icon icon="line-md:chevron-down" class="dropdown-icon" />
    </div>

    <div v-if="isOpen" class="dropdown-menu">
      <div
        v-for="option in allOptions"
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
</template>

<script setup>
import { ref, computed, watch } from 'vue'
import { Icon } from '@iconify/vue'

const props = defineProps({
  label: {
    type: String,
    default: 'Todas as categorias',
  },
  options: {
    type: Array,
    default: () => [],
  },
  modelValue: {
    type: String,
    default: '',
  },
})

const emit = defineEmits(['update:modelValue'])

const selected = ref(props.modelValue)
const isOpen = ref(false)

watch(() => props.modelValue, (newVal) => {
  selected.value = newVal
})

const toggleDropdown = () => {
  isOpen.value = !isOpen.value
}

const selectOption = (value) => {
  selected.value = value
  emit('update:modelValue', value)
  isOpen.value = false
}

const allOptions = computed(() => [
  { label: props.label, value: '' },
  ...props.options,
])

const selectedLabel = computed(() => {
  const selectedOption = allOptions.value.find(o => o.value === selected.value)
  return selectedOption ? selectedOption.label : props.label
})
</script>

<style scoped>
.dropdown-wrapper {
  position: relative;
  width: 250px;
  font-size: 14px;
}

.dropdown-display {
  padding: 0.7rem 1rem;
  border: 1px solid var(--color-border);
  border-radius: 6px;
  background-color: var(--color-white);
  display: flex;
  justify-content: space-between;
  align-items: center;
  cursor: pointer;
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
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  z-index: 10;
  max-height: 200px;
  overflow-y: auto;
}

.dropdown-item {
  padding: 8px 12px;
  cursor: pointer;
  display: flex;
  justify-content: flex-start;
  align-items: center;
}

.dropdown-item span{
  width: 100%;
  display: flex;
  justify-content: center
}

.dropdown-item:hover {
  background-color: #f5f5f5;
}

.dropdown-item.selected {
  background-color: #f0f4ff;
}

.check-icon {
  height: 1.2rem;
  width: 1.2rem;
}
</style>
