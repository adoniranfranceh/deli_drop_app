<template>
  <div class="flex flex-col gap-4">
    <div class="flex flex-col items-center">
      <h3 class="font-medium text-lg mb-2 text-muted">Opções disponíveis</h3>
    </div>

    <div
      v-if="modifiers.length === 0"
      class="flex flex-col items-center justify-center mb-2 text-muted border-2 border-dashed border-border p-9 rounded-md gap-2 h-24"
    >
      <h3 class="m-0 text-base text-muted font-medium max-[758px]:text-sm">Nenhuma opção adicionada</h3>
      <p class="m-0 text-sm text-muted max-[758px]:text-center max-[758px]:text-xs">Toque em "Adicionar Opção" para começar</p>
    </div>

    <div
      v-else
      v-for="(modifier, idx) in modifiers.filter(m => !m._destroy)"
      :key="modifier.id"
      class="flex items-start gap-2 p-4 mb-2 bg-white border border-border rounded-md w-full box-border h-[174px]"
    >
      <div class="flex flex-col flex-1 gap-2 min-w-0">
        <div class="flex items-start justify-between gap-2 w-full">
          <InputGroup
            v-model="modifier.name"
            placeholder="Nome da Opção"
            :externalError="modifierErrors[idx]?.name"
            class="flex-1 min-w-[100px] [&_input]:p-2 [&_input]:rounded-[10px]"
            required
          />

          <AppButton
            @click="$emit('remove-modifier', idx)"
            variant="danger"
            class="!p-2.5"
            icon="lucide-x"
          />
        </div>

        <div class="flex flex-wrap gap-2 w-full box-border">
          <div class="flex flex-1 min-w-0 gap-2">
            <label
              for="product-price"
              class="font-medium text-muted flex items-center gap-1.5 h-[43px] max-[758px]:hidden"
            >
              Preço:
            </label>
            <CurrencyInput
              id="product-price"
              class="[&_.input-group]:h-[43px] [&_.input-group]:w-[150px]"
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
        variant="secondary"
        @click="$emit('add-modifier')"
      />
    </div>
  </div>
</template>

<script setup>
import AppButton from '../../../ui/AppButton.vue'
import CurrencyInput from '../../../ui/CurrencyInput.vue'
import InputGroup from '../../../ui/InputGroup.vue'
import { useModifierValidator } from '../../../../composables/useModifierValidator'

const props = defineProps({
  modifiers: Array,
  index: Number,
})

const emit = defineEmits(['add-modifier', 'remove-modifier'])

const { errors: modifierErrors, validate } = useModifierValidator(props.modifiers)
</script>
