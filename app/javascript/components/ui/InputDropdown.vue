<template>
  <div class="flex-1 flex flex-col gap-2 relative" ref="dropdownRef">
    <label :for="id || 'product-select'" @click="toggleDropdown" class="flex justify-center gap-1 font-medium text-black">
      <span class="flex-none">{{ label }}</span>
      <span v-if="required" class="text-error">*</span>
    </label>

    <div class="relative w-full text-base" @click="toggleDropdown">
      <div class="pr-2 border border-border rounded-md bg-white flex justify-between items-center cursor-pointer hover:border-2 hover:border-primary hover:shadow-sm focus:border-2 focus:border-primary focus:shadow-sm">
        <input
          :id="id || 'product-select'"
          v-model="searchQuery"
          :placeholder="selectedPlaceholder"
          class="w-full h-full border-none outline-none bg-transparent p-3 text-base text-black placeholder:text-muted"
          :class="{ 'placeholder:text-black': selected }"
          @click.stop
          @focus="toggleDropdown()"
        />
        <Icon icon="line-md:chevron-down" class="text-muted mr-2" />
      </div>

      <div v-if="isOpen" class="absolute top-[110%] left-0 right-0 bg-white border border-border rounded-md shadow-sm z-10 max-h-[200px] overflow-y-auto">
        <div
          v-for="option in filteredOptions"
          :key="option.value"
          class="py-2 px-3 cursor-pointer flex items-center"
          :class="{ 'bg-[#f0f4ff]': option.value === selected }"
          @click.stop="selectOption(option.value)"
        >
          <Icon
            v-if="option.value === selected"
            icon="material-symbols:check-rounded"
            class="h-5 w-5"
          />
          <span class="pl-1">{{ option.label }}</span>
        </div>
      </div>
    </div>

    <p class="text-error text-sm min-h-5 m-0">
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
    type: [String, Number],
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
