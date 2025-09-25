<template>
  <ProductFormOverview :title="isEdition ? 'Editar Produto' : 'Novo Produto'" />
  <StepIndicator
    :steps="[
      { label: 'Informações Básicas', icon: 'lucide:package' },
      { label: 'Modificadores', icon: 'lucide:settings' },
      { label: 'Revisão', icon: 'lucide:circle-check-big' }
    ]"
    :currentStep="step"
    :canClickSteps="canClickSteps"
    @update:step="step = $event"
  />

  <div class="product-form">
    <div class="form-container">
      <QuickTemplate v-if="stepVisibility.quickTemplate" @update:product="fillProduct"/>
      <ProductBasicInputs
        v-if="stepVisibility.stepOne"
        :product="product"
        :errors="productErrors"
        :showCategoryError="forceCategoryError"
        :isActive="isActive"
      />
      <ModifierOptionsPrompt
        v-if="stepVisibility.modifierPrompt"
        @modifiers-decision="handleStepChange"
      />
      <ModifierGroup
        v-if="stepVisibility.stepTwo"
        v-model="product.modifier_groups"
      />
      <ProductViewer v-if="stepVisibility.stepThree" :product="product" />
      <div class="form-actions">
        <AppButton
          class="cancel"
          @click="step = step > 1 ? step - 1 : 1"
          text="Voltar"
          iconLeft="lucide-arrow-left"
          v-if="step > 1"
        />
        <AppButton
          class="save"
          text="Continuar"
          icon="lucide-arrow-right"
          @click="handleContinue"
          :disabled="isNextDisabled"
          v-if="step < 3"
        />
        <AppButton
          class="save"
          text="Salvar"
          icon="lucide-save"
          v-if="step === 3"
          @click="submit"
          :disabled="isNextDisabled"
        />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, watch, onMounted, onUnmounted } from 'vue';
import {
  useProductForm,
  useProductTemplate
} from '../../../composables/useProductForm';
import ProductFormOverview from './Shared/ProductFormOverview.vue';
import StepIndicator from './Shared/StepIndicator.vue';
import QuickTemplate from './StepOne/QuickTemplate.vue';
import ModifierGroup from './StepTwo/ModifierGroup.vue';
import ModifierOptionsPrompt from './StepOne/ModifierOptionsPrompt.vue';
import ProductBasicInputs from './StepOne/ProductBasicInputs.vue';
import AppButton from '../../ui/AppButton.vue';
import ProductViewer from './StepThree/ProductViewer.vue';
import { apiPost, apiPut } from '../../../utils/apiHelper';
import { isEqual } from 'lodash';
import { navigateTo } from '../../../utils/navigation';

const handleStepChange = (stepChoice) => {
  nextStep.value = stepChoice;
};

const props = defineProps({
  initialData: Object
});

const {
  product,
  step,
  nextStep,
  productErrors,
  stepVisibility,
  isNextDisabled,
  canClickSteps,
  isEdition,
  getPayload,
  getNormalizedInitial
} = useProductForm(props.initialData);

const isActive = ref(product.status == 'active')

function handleContinue() {
  console.log({ isEdition: isEdition.value, nextStep: nextStep.value, step: step.value })
  if (isEdition.value) {
    step.value = step.value + 1;
  } else {
    step.value = (step.value === 1 ? nextStep.value : 3)
  }
}

const forceCategoryError = ref(false);
const { fillProduct } = useProductTemplate(product, forceCategoryError);

const hasUnsavedChanges = ref(false);

watch(product, () => {
  hasUnsavedChanges.value = true;
}, { deep: true });

onMounted(() => {
  if (!isEdition.value) window.addEventListener('beforeunload', handleBeforeUnload);
});

onUnmounted(() => {
  window.removeEventListener('beforeunload', handleBeforeUnload);
});

const handleBeforeUnload = (event) => {
  if (hasUnsavedChanges.value) {
    event.preventDefault();
    event.returnValue = '';
  }
};

function submit() {
  const payload = getPayload();
  const initialPayload = getNormalizedInitial();

  if (isEqual(payload, initialPayload) && isEdition.value) {
    navigateTo('/menu')
    return
  }

  if (isEdition.value && props.initialData.id) {
    apiPut({
      endpoint: `/api/v1/products/${props.initialData.id}`,
      payload,
      successMessage: 'Produto atualizado com sucesso!',
      redirectPath: '/menu'
    })
  } else {
    apiPost({
      endpoint: '/api/v1/products',
      payload,
      successMessage: 'Produto criado com sucesso!',
      redirectPath: '/menu'
    })
  }

  hasUnsavedChanges.value = false
}
</script>

<style scoped>
.product-form {
  display: flex;
  justify-content: center;
}

.form-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 2rem;
  gap: 2rem;
  background-color: var(--color-background);
  margin: 0 2rem;
  width: 1820px;
}

.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: 1rem;
  margin-top: 1rem;
  padding-inline: 1rem;
}

button.cancel {
  background: var(--color-white);
  border: 1px solid var(--color-border);
  color: var(--color-black);
}

button.cancel,
button.save {
  min-width: 140px;
  display: flex;
  align-items: center;
  justify-content: center;
}

:deep(.cta-button) {
  svg {
    width: 1rem;
    height: 1rem;
  }
}

button.cancel:hover {
  background-color: var(--color-border);
}

@media (max-width: 758px) {
  .form-container {
    width: 100%;
    margin: 0;
    padding: 0.5rem;
  }
}
</style>
