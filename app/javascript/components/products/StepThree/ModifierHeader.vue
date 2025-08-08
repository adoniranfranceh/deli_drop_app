<template>
  <div class="header-modifier">
    <div class="header-title">
      <h3><strong>{{ name }}</strong></h3>
      <ItemChip
        class="modifier-chip"
        v-if="totalSelected !== undefined"
        :class="chipClass"
        :item="chipText"
      />
    </div>
    <div class="header-info" v-if="isSimpleSelector">
      <p>{{ isRequired ? `Escolha ${freeLimit} grátis` : 'Opcional' }}</p>
    </div>
    <div class="header-info" v-else>
      <p>{{ isRequired ? `${min} Obrigatório •` : 'Opcional •' }}</p>
      <p class="modifier-free">{{ freeLimitText }}</p>
      <p>{{ maxText }}</p>
    </div>

  </div>
</template>

<script setup>
import { computed } from 'vue'
import ItemChip from '../../ui/ItemChip.vue' 

const props = defineProps({
  name: String,
  min: Number,
  max: Number,
  freeLimit: Number,
  totalSelected: Number,
  chipClass: String,
  isCheckbox: {
    type: Boolean,
    default: false
  },
  isRadio: {
    type: Boolean,
    default: false
  }
})

const isRequired = computed(() => props.min > 0)
const freeLimitText = computed(() =>
  props.freeLimit ? `Grátis até ${props.freeLimit} •` : ''
)
const maxText = computed(() =>
  props.max ? `Máximo ${props.max}` : ''
)

const isSimpleSelector = computed(() => props.isCheckbox || props.isRadio)
const chipText = computed(() => {
  if (props.max !== undefined) return `${props.totalSelected}/${props.max}`
  return `${props.totalSelected}`
})
</script>

<style scoped>
.header-modifier {
  background: var(--color-background);
  padding: 1rem;
}

.modifier-chip {
  background-color: var(--color-primary);
  color: var(--color-white);
}

.header-title {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin: 0;
}

.header-info {
  display: flex;
  font-size: 0.875rem;
  color: var(--color-muted);
  
  p {
    margin: 0;
    margin-right: 0.2rem;
  }
}

.modifier-free {
  color: var(--color-success);
  font-size: 0.9rem;
}
</style>
