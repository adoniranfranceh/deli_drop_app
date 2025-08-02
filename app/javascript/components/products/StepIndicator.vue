<template>
  <div class="step-indicator">
    <div
      v-for="(step, index) in steps"
      :key="index"
      class="step-wrapper"
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

defineProps({
  steps: {
    type: Array,
    required: true,
  },
  currentStep: {
    type: Number,
    default: 0,
  },
})
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
}

.step {
  display: flex;
  /* flex-direction: column; */
  align-items: center;
  gap: 1rem;
  min-width: 4rem;
}

.step-icon {
  background-color: #e0e0e0;
  border-radius: 50%;
  padding: 0.7rem;
  color: #999;
  transition: all 0.3s ease;
  width: 1.5rem;
  height: 1.5rem;
  display: flex;
  align-items: center;

  svg {
    width: 100%;
    height: 100%;
  }
}

.step-icon.completed {
  background-color: var(--color-success);
  color: white;
}

.step-label.completed {
  color: var(--color-success);
  font-weight: 500;
}

.step-line.completed {
  background-color: var(--color-success);
}

.step-icon.active {
  background-color: var(--color-primary);
  color: white;
}

.step-label {
  font-size: 1rem;
  color: #999;
}

.step-label.active {
  font-weight: bold;
  color: var(--color-primary);
}

.step-line {
  height: 2px;
  width: 5rem;
  background-color: #ddd;
  margin: 0 1rem;
}

@media (max-width: 758px) {
  .step-indicator {
    margin: 0;
  }

  .step {
    gap: 0.3rem;
  }

  .step-label {
    font-size: 0.5rem;
    white-space: nowrap;
  }

  .step-icon {
    
      height: 0.8rem;
      width: 0.8rem;
      padding: 0.5rem;
    
  }

  .step-line {
    width: 2rem;
    margin: 0 0.5rem;
  }
}
</style>
