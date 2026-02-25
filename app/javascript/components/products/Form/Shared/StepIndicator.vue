<template>
  <div ref="containerRef" class="flex items-center justify-center mx-8 py-4 border-b border-border max-[758px]:block max-[758px]:overflow-x-auto max-[758px]:whitespace-nowrap max-[758px]:scroll-smooth max-[758px]:pb-4 max-[758px]:pl-4 max-[758px]:mx-0 max-[758px]:overflow-y-hidden max-[758px]:scrollbar-none max-[758px]:snap-x max-[758px]:snap-mandatory">
    <div
      v-for="(step, index) in steps"
      :key="index"
      :ref="el => { if (el) stepRefs[index] = el }"
      class="flex items-center cursor-pointer max-[758px]:inline-flex max-[758px]:flex-none max-[758px]:min-w-[100vw] max-[758px]:justify-center max-[758px]:snap-center"
      :class="{ 'pointer-events-none': !canClickSteps[index] }"
      @click="() => canClickSteps[index] && $emit('update:step', index + 1)"
    >
      <div class="flex items-center gap-4 min-w-16 max-[758px]:flex-col max-[758px]:gap-2">
        <div
          class="rounded-full p-3 transition-all duration-300 flex items-center justify-center max-[758px]:p-4"
          :class="stepIconClasses(index)"
        >
          <Icon
            :icon="index + 1 < currentStep ? 'lucide:circle-check-big' : step.icon"
            class="w-6 h-6 max-[758px]:w-8 max-[758px]:h-8"
          />
        </div>
        <span
          class="text-base max-[758px]:text-xs max-[758px]:whitespace-nowrap max-[758px]:text-center"
          :class="stepLabelClasses(index)"
        >
          {{ step.label }}
        </span>
      </div>

      <div
        v-if="index < steps.length - 1"
        class="h-0.5 w-20 mx-4 max-[758px]:hidden"
        :class="index + 1 < currentStep ? 'bg-success' : 'bg-border'"
      ></div>
    </div>
  </div>
</template>

<script setup>
import { Icon } from '@iconify/vue'
import { ref, watch, nextTick } from 'vue'

const props = defineProps({
  steps: { type: Array, required: true },
  currentStep: { type: Number, default: 0 },
  canClickSteps: {
    type: Array,
    default: () => [true, true, true]
  }
})

const containerRef = ref(null)
const stepRefs = ref([])

function stepIconClasses(index) {
  if (index + 1 < props.currentStep) {
    return 'bg-success text-white'
  } else if (index + 1 === props.currentStep) {
    return 'bg-primary text-white animate-breathe'
  }
  return 'bg-border text-muted'
}

function stepLabelClasses(index) {
  if (index + 1 < props.currentStep) {
    return 'text-success font-medium'
  } else if (index + 1 === props.currentStep) {
    return 'text-primary font-bold'
  }
  return 'text-muted'
}

watch(
  () => props.currentStep,
  async () => {
    await nextTick()
    scrollToCurrentStep()
  },
  { immediate: true }
)

function scrollToCurrentStep() {
  if (window.matchMedia('(max-width: 758px)').matches) {
    const el = stepRefs.value[props.currentStep - 1];
    if (el) {
      el.scrollIntoView({
        behavior: 'smooth',
        block: 'nearest',
        inline: 'center'
      });
    }
  }
}
</script>
