<template>
  <div ref="containerRef" class="step-indicator">
    <div
      v-for="(step, index) in steps"
      :key="index"
      class="step-wrapper"
      :ref="el => { if (el) stepRefs[index] = el }"
      @click="() => canClick(index) && $emit('update:step', index + 1)"
    >
      <div class="step">
        <div
          class="step-icon"
          :class="{
            active: index + 1 === currentStep,
            completed: index + 1 < currentStep
          }"
        >
          <Icon :icon="index + 1 < currentStep ? 'lucide:circle-check-big' : step.icon" />
        </div>
        <span
          class="step-label"
          :class="{
            active: index + 1 === currentStep,
            completed: index + 1 < currentStep
          }"
        >
          {{ step.label }}
        </span>
      </div>

      <div
        v-if="index < steps.length - 1"
        class="step-line"
        :class="{ completed: index + 1 < currentStep }"
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
  canClick: {
    type: Function,
    default: () => () => true
  }
})

const containerRef = ref(null)
const stepRefs = ref([])

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

<style scoped>
.step-indicator {
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 2rem;
  padding: 1rem 0;
  border-bottom: 1px solid var(--color-border);
}

.step-wrapper {
  display: flex;
  align-items: center;
  cursor: pointer;
}

.step {
  display: flex;
  align-items: center;
  gap: 1rem;
  min-width: 4rem;
}

.step-icon {
  background-color: var(--color-border);
  border-radius: 50%;
  padding: 0.7rem;
  color: var(--color-muted);
  transition: all 0.3s ease;
  width: 1.5rem;
  height: 1.5rem;
  display: flex;
  align-items: center;
  justify-content: center;
}

.step-icon > svg {
  width: 100%;
  height: 100%;
}

.step-icon.completed {
  background-color: var(--color-success);
  color: var(--color-white);
}

@keyframes breathe {
  0%, 100% { transform: scale(1); }
  50% { transform: scale(1.1); }
}

.step-icon.active {
  background-color: var(--color-primary);
  color: var(--color-white);
  animation: breathe 2.5s ease-in-out infinite;
}


.step-label {
  font-size: 1rem;
  color: var(--color-muted);
}

.step-label.active {
  font-weight: bold;
  color: var(--color-primary);
}

.step-label.completed {
  color: var(--color-success);
  font-weight: 500;
}

.step-line {
  height: 2px;
  width: 5rem;
  background-color: var(--color-border);
  margin: 0 1rem;
}

.step-line.completed {
  background-color: var(--color-success);
}

@media (max-width: 758px) {
  .step-indicator {
    display: block;
    overflow-x: auto;
    white-space: nowrap;
    scroll-behavior: smooth;
    padding-bottom: 1rem;
    padding-left: 1rem;
    margin: 0;
    overflow-y: hidden;
    scrollbar-width: none;

    scroll-snap-type: x mandatory;
    -webkit-overflow-scrolling: touch;
  }

  .step-indicator::-webkit-scrollbar {
    display: none;
  }

  .step-wrapper {
    display: inline-flex;
    align-items: center;
    flex: 0 0 auto;
    min-width: 100vw;
    justify-content: center;

    scroll-snap-align: center;
  }

  .step {
    flex-direction: column;
    gap: 0.5rem;
  }

  .step-label {
    font-size: 0.75rem;
    white-space: nowrap;
    text-align: center;
  }

  .step-icon {
    height: 3rem;
    width: 3rem;
    padding: 0.5rem;
  }

  .step-icon > svg {
    width: 2rem;
    height: 2rem;
  }

  .step-line {
    display: none;
  }
}
</style>
