<template>
  <div class="z-[1] overflow-x-auto bg-white">
    <div class="bg-white flex items-center gap-2 relative">
      <Icon
        class="absolute left-3 top-1/2 -translate-y-1/2 pointer-events-none text-muted text-xl"
        icon="fluent:search-32-regular"
      />
      <input
        type="text"
        :placeholder="placeholder"
        :value="modelValue"
        @input="$emit('update:modelValue', $event.target.value)"
        class="py-3 pr-3 pl-9 w-full border border-border rounded-lg"
      />
      <Icon
        v-if="modelValue"
        class="absolute right-3 top-1/2 -translate-y-1/2 cursor-pointer text-primary text-xl"
        icon="material-symbols-light:close"
        @click="$emit('update:modelValue', '')"
      />
    </div>
  </div>
</template>

<script setup>
import { Icon } from '@iconify/vue';

defineProps({
  placeholder: {
    type: String,
    default: 'Buscar...'
  },
  modelValue: String
})

defineEmits(['update:modelValue', 'search'])
</script>
