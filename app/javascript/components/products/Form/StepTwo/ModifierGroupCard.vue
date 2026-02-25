<template>
  <div class="border-2 border-[#cfd3d7] bg-background p-4 rounded-md mb-4 flex flex-col gap-4">
    <div class="flex flex-wrap justify-between items-start gap-2 relative min-h-14 mt-4">
      <InputGroup
        v-model="group.name"
        :externalError="groupErrors?.name"
        placeholder="Nome do Grupo"
        class="flex-1 min-w-[200px] [&_input]:p-2 [&_input]:rounded-[10px]"
        required
      />

      <AppButton
        @click="$emit('remove-group', index)"
        icon="streamline-ultimate:bin-1"
        variant="danger"
        class="!p-2.5 shrink-0"
      />
    </div>

    <div class="flex flex-col gap-4 bg-background p-4 rounded-lg max-[500px]:p-0 [&>*]:flex-1 [&>*]:min-w-[120px]">
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

      <div class="flex gap-4 flex-1 max-[500px]:[&_.error]:text-[0.6rem] max-[500px]:[&_.error]:text-center max-[500px]:[&_.label-text]:text-[0.7rem]">
        <InputNumber
          :id="'min-options' + index"
          class="[&_input]:border-2 [&_input]:border-[#cfe2ff] [&_input]:bg-[#eaf4ff]"
          :externalError="groupErrors?.min"
          label="Min de Opções"
          placeholder="Mínimo"
          v-model.number="group.min"
          :min="0"
          :max="1000"
          required
        />

        <InputNumber
          :id="'max-options' + index"
          class="[&_input]:border-2 [&_input]:border-[#ffe8c7] [&_input]:bg-[#fff7ec]"
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
          :id="'free-limit' + index"
          class="[&_input]:border-2 [&_input]:border-[#d1f7da] [&_input]:bg-[#eafff1]"
          label="Limite Grátis"
          placeholder="Quantidade"
          :modelValue="computedFreeLimit"
          @update:modelValue="computedFreeLimit = $event"
          :min="0"
          :max="1000"
          :disabled="group.input_type === 'single_choice' || group.input_type === 'multiple_choice'"
          :externalError="groupErrors?.free_limit"
          required
        />
      </div>
    </div>

    <ItemChip
      :item="`${group.modifiers.length} ${group.modifiers.length != 1 ? 'opções' : 'opção' }`"
      class="!bg-white !text-black !border !border-border shrink-0 block mx-auto w-fit"
    />

    <ModifierList
      :modifiers="group.modifiers"
      :index="index"
      @add-modifier="$emit('add-modifier', index)"
      @remove-modifier="$emit('remove-modifier', index, $event)"
    />
  </div>
</template>

<script setup>
import { computed, watch } from 'vue'
import AppButton from '../../../ui/AppButton.vue'
import InputDropdown from '../../../ui/InputDropdown.vue'
import InputGroup from '../../../ui/InputGroup.vue'
import InputNumber from '../../../ui/InputNumber.vue'
import ItemChip from '../../../ui/ItemChip.vue'
import ModifierList from './ModifierList.vue'
import { useGroupValidator } from '../../../../composables/useGroupValidator'

const props = defineProps({
  group: Object,
  index: Number,
})

const { errors: groupErrors } = useGroupValidator(props.group)

defineEmits(['remove-group', 'add-modifier', 'remove-modifier'])

const computedFreeLimit = computed({
  get() {
    if (props.group.input_type === 'single_choice') return 1
    if (props.group.input_type === 'multiple_choice') return props.group.max ?? 0
    return props.group.free_limit ?? 0
  },
  set(val) {
    if (props.group.input_type === 'quantity') {
      props.group.free_limit = val
    }
  }
})

watch(
  () => [props.group.input_type, props.group.max],
  ([type, max]) => {
    if (type === 'multiple_choice') {
      props.group.free_limit = max ?? 0
    }
    if (type === 'single_choice') {
      props.group.free_limit = max ?? 0
    }
  }
)
</script>
