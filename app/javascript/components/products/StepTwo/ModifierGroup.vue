<template>
  <div class="group-section">
    <div class="group-header">
      <div>
        <h2 class="group-title"><Icon icon="lucide:settings"/> Grupos de Modificadores</h2>
        <p class="group-subtitle">Configure opções de personalização para este produto</p>
      </div>
    </div>

    <div v-if="groups.length === 0" class="empty-groups">
      <Icon icon="lucide:settings" class="settings-icon" />
      <h3 class="first-title">Crie seu primeiro grupo</h3>
      <p class="empty-text">
        Grupos organizam as opções. Por exemplo: "Tamanhos", "Adicionais", "Sabores"
      </p>

      <div class="group-type-options">
        <button class="group-type" @click="addGroup('single_choice')">
          <strong>Escolha Única</strong>
          <span>Cliente escolhe 1</span>
        </button>

        <button class="group-type" @click="addGroup('multiple_choice')">
          <strong>Múltipla Escolha</strong>
          <span>Cliente escolhe vários</span>
        </button>

        <button class="group-type" @click="addGroup('quantity')">
          <strong>Quantidade</strong>
          <span>Cliente define quantos</span>
        </button>
      </div>
    </div>

    <div v-else>
      <ModifierGroupCard
        v-for="(group, index) in groups"
        :key="group.id"
        :group="group"
        :index="index"
        @remove-group="removeGroup"
        @add-modifier="addModifier"
        @remove-modifier="removeModifier"
      />
      <AppButton
        text="Adicionar Grupo"
        iconLeft="ic:round-plus"
        @click="addGroup('')"
        class="add-group-btn"
      />
    </div>
  </div>
</template>

<script setup>
import { toRef, watch} from 'vue'
import { Icon } from '@iconify/vue'
import AppButton from '../../ui/AppButton.vue'
import ModifierGroupCard from './ModifierGroupCard.vue'

const props = defineProps({
  modelValue: {
    type: Array,
    default: () => []
  }
})
const emit = defineEmits(['update:modelValue'])

const groups = toRef(props, 'modelValue')

watch(groups, () => {
  emit('update:modelValue', groups)
}, { deep: true })

function addGroup(type = '') {
  let max = null
  let free_limit = null

  if (type === 'single_choice') {
    max = 1
    free_limit = 1
  }

  groups.value.push({
    name: null,
    input_type: type,
    min: null,
    max: max,
    free_limit: free_limit,
    modifiers_attributes: []
  })
}

function removeGroup(index) {
  groups.value.splice(index, 1)
}

function addModifier(index) {
  groups.value[index].modifiers_attributes.push({
    name: null,
    base_price: null,
    image: null,
  })
}

function removeModifier(groupIndex, modifierIndex) {
  groups.value[groupIndex].modifiers_attributes.splice(modifierIndex, 1)
}
</script>

<style scoped>
.group-section {
  display: flex;
  flex-direction: column;
  gap: 1.2rem;
  width: 80%;
  padding: 2rem;
  background: var(--color-white);
  border: 1px solid var(--color-border);
  border-radius: 8px;
}

.group-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 0.5rem;
}

.group-title {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-weight: bold;
  margin: 0;
}

.group-subtitle {
  font-size: 0.9rem;
  color: var(--color-muted);
  margin: 0;
}

.add-group-btn {
  background-color: var(--color-white);
  border: 1px solid var(--color-border);
  color: var(--color-black);
}

.add-group-btn:hover {
  background-color: var(--color-border);
}

.empty-groups {
  text-align: center;
  border: 2px dashed var(--color-border);
  padding: 1.5rem;
  border-radius: 0.5rem;
  margin-top: 1rem;
}

.empty-groups :deep(.cta-button) {
  background-color: var(--color-white);
  color: var(--color-black);
  border: 1px solid var(--color-border);
}

.settings-icon {
  height: 3.5rem;
  width: 3.5rem;
  color: var(--color-border);
}

.first-title {
  margin-top: 1rem;
  color: var(--color-muted-blue);
  font-weight: 500;
}

.empty-text {
  margin-top: 0.5rem;
  color: var(--color-muted);
}

.group-type-options {
  display: flex;
  gap: 1rem;
  justify-content: center;
  flex-wrap: wrap;
  margin-top: 1rem;
}

.group-type {
  background-color: var(--color-white);
  border: 1px solid var(--color-border);
  padding: 1rem;
  border-radius: 6px;
  width: 200px;
  text-align: center;
  cursor: pointer;
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
  transition: border 0.2s, background 0.2s;
}

.group-type:hover {
  border-color: var(--color-primary);
  background-color: var(--color-primary-light);
}

.group-type strong {
  color: var(--color-primary-hover);
  font-size: 1rem;
}

.group-type span {
  font-size: 0.85rem;
  color: var(--color-muted);
}

@media (max-width: 758px) {
  .group-section {
    width: 100%;
    padding: 0.4rem;
    margin: 0;
  }

  .group-header {
    flex-direction: column;
  }

  .group-title {
    font-size: 1.2rem;
  }

  .group-subtitle {
    font-size: 0.8rem;
  }
}
</style>
