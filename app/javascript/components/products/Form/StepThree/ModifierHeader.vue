<template>
  <div class="bg-background p-4">
    <div class="flex items-center justify-between m-0">
      <h3><strong>{{ name }}</strong></h3>
      <ItemChip
        class="!bg-primary !text-white"
        v-if="totalSelected !== undefined"
        :class="chipClass"
        :item="chipText"
      />
    </div>
    <div class="flex text-sm text-muted [&_p]:m-0 [&_p]:mr-0.5" v-if="isSimpleSelector">
      <p>{{ isRequired ? `Escolha ${freeLimit} grátis` : 'Opcional' }}</p>
    </div>
    <div class="flex text-sm text-muted [&_p]:m-0 [&_p]:mr-0.5" v-else>
      <p>{{ isRequired ? `${min} Obrigatório •` : 'Opcional •' }}</p>
      <p class="text-success text-[0.9rem]">{{ freeLimitText }}</p>
      <p>{{ maxText }}</p>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import ItemChip from '../../../ui/ItemChip.vue' 

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

