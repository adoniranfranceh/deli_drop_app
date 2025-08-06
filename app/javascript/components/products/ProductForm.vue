<template>
  <ProductFormOverview />
  <StepIndicator
    :steps="[
      { label: 'Informações Básicas', icon: 'lucide:package' },
      { label: 'Modificadores', icon: 'lucide:settings' },
      { label: 'Revisão', icon: 'lucide:circle-check-big' }
    ]"
    :currentStep="step"
    :canClick="canNavigateToStep"
    @update:step="step = $event"
  />

  <div class="product-form">
    <div class="form-container">
      <form v-if="step === 1" @submit.prevent="submit" class="form-grid">
        <h2 class="product-form-title">
          <Icon icon="lucide:settings" /> Informações Básicas
        </h2>

        <div class="form-row">
          <InputGroup
            label="Nome"
            placeholder="Nome do Produto"
            v-model="product.name"
            :externalError="productErrors?.name"
            required
          />
          <InputDropdown
            v-model="product.category"
            :options="[
              { label: 'Bebidas', value: 'bebidas' },
              { label: 'Comidas', value: 'comidas' },
              { label: 'Sobremesas', value: 'sobremesas' }
            ]"
            placeholder="Todas as categorias"
            :externalError="productErrors?.category"
            label="Categoria"
            required
          />
        </div>

        <div class="form-row">
          <CurrencyInput
            id="product-price"
            label="Preço"
            v-model="product.price"
            :externalError="productErrors?.price"
          />

          <InputNumber
            id="product-duration"
            label="Tempo de preparo"
            placeholder="Tempo de preparo (minutos)"
            v-model="product.duration"
            :min="1"
            :max="1000"
            :externalError="productErrors?.duration"
            required
          />
        </div>

        <InputGroup
          id="product-description"
          label="Descrição"
          isTextarea
          placeholder="Descreva o produto..."
          v-model="product.description"
          required
        />

        <IngredientsInput v-model="product.ingredients" />

        <div class="switch-wrapper">
          <ToggleSwitch
            v-model="product.isActive"
            label="Produto ativo"
          />
          <ToggleSwitch
            v-model="product.isFeatured"
            label="Produto em destaque"
          />
        </div>
      </form>
      <ModifierOptionsPrompt
        v-if="isProductValid && step === 1"
        @modifiers-decision="handleStepChange"
      />
      <ModifierGroup
        v-if="step === 2"
        v-model="product.modifiers_groups"
        @next="step = 3"
        @validation-state="isGroupsValid = $event"
      />
      <div class="form-actions">
        <AppButton class="cancel" @click="navigateTo('/menu')" text="Cancelar" iconLeft="ic:round-close" v-if="step === 1"/>
        <AppButton
          class="cancel"
          @click="step = step > 1 ? step - 1 : 1"
          text="Voltar"
          iconLeft="lucide-arrow-left"
          v-else
        />
        <AppButton
          class="save"
          text="Continuar"
          icon="lucide-arrow-right"
          @click="step = (step === 1 ? nextStep : 3)"
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
import {
  useProductForm,
  useProductTemplate
} from '../../composables/useProductForm'
import ProductFormOverview from './ProductFormOverview.vue'
import StepIndicator from './StepIndicator.vue'
import QuickTemplate from './QuickTemplate.vue'
import ModifierGroup from './ModifierGroup.vue'
import ModifierOptionsPrompt from './ModifierOptionsPrompt.vue'
import FormStepOne from './FormStepOne.vue'
import AppButton from '../ui/AppButton.vue'

const handleStepChange = (stepChoice) => {
  nextStep.value = stepChoice
}

const {
  product,
  step,
  nextStep,
  productErrors,
  isProductValid,
  isNextDisabled,
  canClickSteps
} = useProductForm()


const { fillProduct } = useProductTemplate(product)
</script>

<style scoped>
.product-form {
  display: flex;
  justify-content: center;
}

.product-form-title {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-weight: bold;
  margin: 0;
  justify-content: center;
  margin-bottom: 1.5rem;
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

.form-grid {
  display: flex;
  flex-direction: column;
  gap: 1.2rem;
  width: 80%;
  padding: 2rem;
  background: var(--color-white);
  border: 1px solid var(--color-border);
  border-radius: 8px;
}

.form-row {
  display: flex;
  gap: 1.5rem;
  flex-wrap: wrap;
}

.switch-wrapper {
  display: flex;
  gap: 1.5rem;
  align-items: center;
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

  .form-row {
    flex-direction: column;
  }

  .form-grid {
    width: 100%;
    padding: 0.4rem;
    margin: 0;
  }

  .switch-wrapper {
    align-items: flex-start;
    gap: 1rem;
  }

  .form-actions {
    flex-direction: column-reverse;
  }
}
</style>
