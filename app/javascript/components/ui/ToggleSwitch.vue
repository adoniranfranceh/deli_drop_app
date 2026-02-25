<template>
  <label class="inline-flex items-center gap-2.5 cursor-pointer text-base max-[600px]:text-[0.95rem] max-[600px]:gap-2">
    <span class="relative inline-block w-[50px] h-7 max-[600px]:w-11 max-[600px]:h-6">
      <input
        type="checkbox"
        :checked="checked"
        @change="emit('update:modelValue', $event.target.checked)"
        class="hidden peer"
      />
      <span class="w-[50px] h-7 bg-border rounded-full relative transition-colors duration-300 block peer-checked:bg-primary max-[600px]:w-11 max-[600px]:h-6 before:content-[''] before:absolute before:left-[3px] before:top-[3px] before:w-[22px] before:h-[22px] before:bg-white before:rounded-full before:transition-transform before:duration-300 before:shadow-sm peer-checked:before:translate-x-[22px] max-[600px]:before:w-5 max-[600px]:before:h-5 max-[600px]:before:top-0.5 max-[600px]:before:left-0.5 max-[600px]:peer-checked:before:translate-x-5"></span>
    </span>
    <span class="font-medium">{{ label }}</span>
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
