<template>
  <div
    class="modifier-group-card"
  >
    <div class="header-row">
      <InputGroup
        v-model="group.name"
        :externalError="groupErrors?.name"
        placeholder="Nome do Grupo"
        class="group-name-input"
        required
      />

      <AppButton
        @click="$emit('remove-group', index)"
        icon="streamline-ultimate:bin-1"
        class="bin-btn"
      />
    </div>

    <div class="form-row">
      <InputDropdown
        v-model="group.input_type"
        :externalError="groupErrors?.input_type"
        required
        @update:modelValue="val => {
          group.input_type = val
          if (val === 'single_choice') group.max = 1
        }"
        :options="[
          { label: 'Escolha Única', value: 'single_choice' },
          { label: 'Múltipla Escolha', value: 'multiple_choice' },
          { label: 'Quantidade', value: 'quantity' }
        ]"
        label="Tipo de Escolha"
        placeholder="Selecionar Tipo de escolha"
      />

      <div class="form-row-options">
        <InputNumber
          id="min-options"
          class="input-min"
          :externalError="groupErrors?.min"
          label="Min de Opções"
          placeholder="Mínimo"
          v-model.number="group.min"
          :min="0"
          :max="1000"
          required
        />

        <InputNumber
          id="max-options"
          class="input-max"
          :externalError="groupErrors?.max"
          label="Max de Opções"
          placeholder="Máximo"
          v-model.number="group.max"
          :min="0"
          :max="1000"
          :disabled="group.input_type === 'single_choice'"
          @update:modelValue="val => group.max = val"
          required
        />

        <InputNumber
          id="free-limit"
          class="input-free"
          label="Limite Grátis"
          placeholder="Quantidade"
          v-model.number="group.free_limit"
          :min="0"
          :max="1000"
          :externalError="groupErrors?.free_limit"
          required
        />
      </div>
    </div>

    <ItemChip :item="`${group.modifiers.length} opções`" class="options-chip" />

    <ModifierList
      :modifiers="group.modifiers"
      :index="index"
      @add-modifier="$emit('add-modifier', index)"
      @remove-modifier="$emit('remove-modifier', index, $event)"
    />
  </div>
</template>

<script setup>
import AppButton from '../ui/AppButton.vue'
import InputDropdown from '../ui/InputDropdown.vue'
import InputGroup from '../ui/InputGroup.vue'
import InputNumber from '../ui/InputNumber.vue'
import ItemChip from '../ui/ItemChip.vue'
import ModifierList from './ModifierList.vue'
import { useGroupValidator } from '../../composables/useGroupValidator'

const props = defineProps({
  group: Object,
  index: Number,
})

const { errors: groupErrors } = useGroupValidator(props.group)

defineEmits(['remove-group', 'add-modifier', 'remove-modifier'])
</script>

<style scoped>
.modifier-group-card {
  border: 2px solid #cfd3d7;
  background-color: var(--color-light-background);
  padding: 1rem;
  border-radius: 6px;
  margin-bottom: 1rem;
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.invalid-group {
  border: 2px solid red;
}

.bin-btn {
  color: var(--color-primary);
  background-color: var(--color-white);
  border: 1px solid var(--color-border);
  padding: 0.6rem;
  flex-shrink: 0;
}

.bin-btn:hover {
  background-color: var(--color-border);
}

.header-row {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
  align-items: flex-start;
  gap: 0.5rem;
  position: relative;
  min-height: 3.5rem;
  margin-top: 1rem;
}

.group-name-input {
  flex: 1;
  min-width: 200px;
}

.group-name-input :deep(input) {
  padding: 0.5rem;
  border-radius: 10px;
}

.options-chip {
  background-color: var(--color-white);
  color: var(--color-black);
  border: 1px solid var(--color-border);
  flex-shrink: 0;
  display: block;
  margin-left: auto;
  margin-right: auto;
  width: fit-content;
}

.form-row {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  background-color: var(--color-background);
  padding: 1rem;
  border-radius: 8px;
}

.form-row > * {
  flex: 1;
  min-width: 120px;
}

.form-row-options {
  display: flex;
  gap: 1rem;
  flex: 1;
}

.input-min :deep(input) {
  border: 2px solid #cfe2ff;
  background-color: #eaf4ff;
}

.input-max :deep(input) {
  border: 2px solid #ffe8c7;
  background-color: #fff7ec;
}

.input-free :deep(input) {
  border: 2px solid #d1f7da;
  background-color: #eafff1;
}

.group-error {
  color: red;
  font-size: 0.85rem;
  margin-top: -0.5rem;
}

@media (max-width: 500px) {
  .form-row {
    padding: 0rem;
  }

  .form-row-options :deep(.error) {
    font-size: 0.6rem;
    text-align: center;
  }

  .form-row-options :deep(.label-text) {
    font-size: 0.7rem;
  }
}
</style>
