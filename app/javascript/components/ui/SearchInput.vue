<template>
  <div class="floating-search">
    <div class="search-bar">
      <Icon class="search-icon" icon="fluent:search-32-regular" />
      <input
        type="text"
        :placeholder="placeholder"
        :value="modelValue"
        @input="$emit('update:modelValue', $event.target.value)"
      />
      <Icon
        v-if="modelValue"
        class="close-icon"
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


<style scoped>
.floating-search {
  position: sticky;
  top: 100px;
  z-index: 1;
  overflow-x: auto;
  background-color: var(--color-white);
}

.search-bar {
  background: var(--color-white);
  display: flex;
  align-items: center;
  gap: 0.5rem;
  position: relative;
}

.search-icon {
  position: absolute;
  left: 0.7rem;
  top: 50%;
  transform: translateY(-50%);
  pointer-events: none;
  color: var(--color-muted);
  font-size: 1.2rem;
}

.close-icon {
  position: absolute;
  right: 0.7rem;
  top: 50%;
  transform: translateY(-50%);
  pointer-events: auto;
  color: var(--color-primary);
  font-size: 1.2rem;
}

.search-bar input {
  padding: 0.7rem 0rem 0.7rem 2.3rem;
  width: 100%;
  border: 1px solid var(--color-border);
  border-radius: 7px;
}

@media (max-width: 758px) {
  .search-bar input {
    width: 100%
  }
}
</style>
