<template>
  <BaseModal @close="$emit('close')">
    <div class="modal-container">
      <div class="modal-header">
        <h2>Nova Categoria</h2>
        <button
          class="close-btn"
          aria-label="Fechar modal"
          @click="$emit('close')"
        >×</button>
      </div>

      <p class="subtitle">
        Adicione uma nova categoria para organizar seus produtos
      </p>

      <form @submit.prevent class="form-grid">
        <InputGroup
          id="name"
          label="Nome"
          placeholder="Nome da categoria"
          v-model="category.name"
          :externalError="categoryErrors?.name"
          required
        />

        <InputGroup
          id="description"
          label="Descrição"
          placeholder="Descrição da categoria (opcional)"
          v-model="category.description"
          isTextarea
        />

        <div class="actions">
          <AppButton
            class="cancel"
            @click="$emit('close')"
            text="Cancelar"
          />
          <AppButton
            class="save"
            text="Salvar"
            icon="lucide-save"
            @click="submit"
            :disabled="!isValidCategory"
          />
        </div>
      </form>
    </div>
  </BaseModal>
</template>

<script setup>
import { reactive } from 'vue';
import BaseModal from '../ui/BaseModal.vue';
import InputGroup from '../ui/InputGroup.vue';
import { useCategoryValidator } from '../../composables/useCategoryValidator';
import AppButton from '../ui/AppButton.vue';
import { apiPost, apiPut } from '../../utils/apiHelper';

const props = defineProps({
  categoryData: {
    type: Object,
    default: null,
  },
});

const categoryData = props.categoryData;

const category = reactive({
  name: categoryData?.name || null,
  description: categoryData?.description || null
});

const categoryExists = categoryData !== '' && categoryData !== null && categoryData !== undefined

const { errors: categoryErrors, isValid: isValidCategory } = useCategoryValidator(category);

function submit() {
  const payload = {
    name: category.name,
    description: category.description,
  };

  if (categoryExists) {
    return apiPut({
      endpoint: `/api/v1/categories/${categoryData.id}`,
      payload,
      successMessage: 'Categoria atualizada com sucesso!',
      redirectPath: '/menu'
    });
  } else {
    return apiPost({
      endpoint: '/api/v1/categories',
      payload,
      successMessage: 'Categoria criada com sucesso!',
      redirectPath: '/menu'
    });
  }
}
</script>

<style scoped>
.modal-container :deep(.input-group) {
  label {
    justify-content: flex-start;
  }
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.modal-header h2 {
  font-weight: 700;
  font-size: 1.4rem;
  margin: 0;
}

.close-btn {
  font-size: 1.5rem;
  padding: 0;
  background: transparent;
  cursor: pointer;
  color: var(--color-black);
  transition: color 0.2s;
}

.subtitle {
  margin: 0.5rem 0 1.5rem 0;
  color: var(--color-muted);
}

.form-grid {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.actions {
  display: flex;
  justify-content: flex-end;
  gap: 1rem;
}

button.cancel {
  background: var(--color-white);
  border: 1px solid var(--color-border);
  color: var(--color-black);
}

button.cancel:hover {
  background-color: var(--color-border);
}

@media (max-width: 768px) {
  .modal-header h2 {
    font-size: 1.1rem;
  }

  .subtitle {
    text-align: center;
  }
}
</style>
