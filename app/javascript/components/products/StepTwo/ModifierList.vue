<template>
  <div class="modifiers-section">
    <div class="modifiers-header">
      <h3 class="modifiers-title">Opções disponíveis</h3>
    </div>

    <div class="empty-modifier-text" v-if="modifiers.length === 0">
      <h3>Nenhuma opção adicionada</h3>
      <p>Toque em "Adicionar Opção" para começar</p>
    </div>

    <div
      v-else
      v-for="(modifier, idx) in modifiers"
      :key="modifier.id"
      class="modifier-row"
    >
      <div class="form-row-modifier">
        <div class="form-header">
          <InputGroup
            v-model="modifier.name"
            placeholder="Nome da Opção"
            :externalError="modifierErrors[idx]?.name"
            class="group-name-input"
            required
          />
  
          <AppButton
            @click="$emit('remove-modifier', idx)"
            class="close-btn"
            icon="lucide-x"
          />
        </div>

        <div class="row-options">
          <div class="currency-input-wrapper">
            <label
              for="product-price"
              class="input-label"
            >
              Preço:
            </label>
            <CurrencyInput
              id="product-price"
              class="input-price"
              placeholder="Preço da Opção"
              :externalError="modifierErrors[idx]?.base_price"
              v-model="modifier.base_price"
              required
            />
          </div>

          <InputGroup
            v-model="modifier.image"
            placeholder="URL da Imagem"
          />
        </div>
      </div>
    </div>
    <div>
      <AppButton
        text="Adicionar Opção"
        iconLeft="ic:round-plus"
        @click="$emit('add-modifier')"
        class="add-option-btn"
      />
    </div>
  </div>
</template>

<script setup>
import AppButton from '../../ui/AppButton.vue'
import CurrencyInput from '../../ui/CurrencyInput.vue'
import InputGroup from '../../ui/InputGroup.vue'
import { useModifierValidator } from '../../../composables/useModifierValidator'

const props = defineProps({
  modifiers: Array,
  index: Number,
})

const emit = defineEmits(['add-modifier', 'remove-modifier'])

const { errors: modifierErrors, validate } = useModifierValidator(props.modifiers)
</script>

<style scoped>
.modifiers-section {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.modifiers-header {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.modifiers-title {
  font-weight: 500;
  font-size: 1.1rem;
  margin-bottom: 0.5rem;
  color: var(--color-muted);
}

.add-option-btn {
  background-color: var(--color-white);
  border: 1px solid var(--color-border);
  color: var(--color-black);
}

.add-option-btn:hover {
  background-color: var(--color-border);
}

.empty-modifier-text {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  margin: 0 0 0.5rem 0;
  color: var(--color-muted);
  border: 2px dashed var(--color-border);
  padding: 37px;
  border-radius: 6px;
  gap: 0.5rem;

  height: 96px;

  h3 {
    margin: 0;
    font-size: 1rem;
    color: var(--color-muted);
    font-weight: 500;
  }

  p {
    margin: 0;
    font-size: 0.9rem;
    color: var(--color-muted);
  }
}

.modifier-row {
  display: flex;
  align-items: flex-start;
  gap: 0.5rem;
  padding: 1rem;
  margin-bottom: 0.5rem;
  background-color: var(--color-white);
  border: 1px solid var(--color-border);
  border-radius: 6px;
  width: 100%;
  box-sizing: border-box;
  height: 174px;
}

.form-row-modifier {
  display: flex;
  flex-direction: column;
  flex: 1;
  gap: 0.5rem;
  min-width: 0;
}

.form-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 0.5rem;
  width: 100%;
}

.row-options {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
  width: 100%;
  box-sizing: border-box;
}

.currency-input-wrapper {
  display: flex;
  flex: 1;
  min-width: 0;
  gap: 0.5rem;
}

.group-name-input {
  flex: 1;
  min-width: 100px;
}

.group-name-input :deep(input) {
  padding: 0.5rem;
  border-radius: 10px;
}

.close-btn {
  background-color: var(--color-white);
  border: 1px solid var(--color-border);
  color: var(--color-primary);
  padding: 0.6rem;
}

.close-btn:hover {
  background-color: var(--color-border);
}

.input-label {
  font-weight: 500;
  color: var(--color-muted);
  display: flex;
  align-items: center;
  gap: 0.4rem;
  height: 43px;
}

.input-price :deep(.input-group) {
  height: 43px;
  width: 150px;
}

@media (max-width: 758px) {
  .input-label {
    display: none;
  }

  .empty-modifier-text {
    h3 {
      font-size: 0.9rem;
    }

    p {
      text-align: center;
      font-size: 0.8rem;
    }
  }
}

</style>
