<template>
  <BaseModal @close="$emit('close')">
    <div class="[&_label]:justify-start">
      <div class="flex justify-between items-center">
        <h2 class="font-bold text-[1.4rem] m-0 max-[768px]:text-[1.1rem]">Nova Categoria</h2>
        <button
          class="text-2xl p-0 bg-transparent cursor-pointer text-black transition-colors duration-200"
          aria-label="Fechar modal"
          @click="$emit('close')"
        >×</button>
      </div>

      <p class="my-2 mb-6 text-muted max-[768px]:text-center">
        Adicione uma nova categoria para organizar seus produtos
      </p>

      <form @submit.prevent class="flex flex-col gap-4">
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

        <div class="flex justify-end gap-4">
          <AppButton
            variant="secondary"
            @click="$emit('close')"
            text="Cancelar"
          />
          <AppButton
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
import { apiPostLocal, apiPutLocal } from '../../utils/apiHelper';

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

const emit = defineEmits(['close', 'saved']);

async function submit() {
  const payload = { name: category.name, description: category.description }

   if (categoryExists &&
      category.name === categoryData.name &&
      category.description === categoryData.description) {
    emit('close')
    return
  }

  try {
    let response = categoryExists ?
      await apiPutLocal({ endpoint: `/api/v1/categories/${categoryData.id}`, payload })
      : await apiPostLocal({ endpoint: '/api/v1/categories', payload })

    emit('close')
    emit('saved', response.category)
  } catch (error) {
    console.error(error)
  }
}
</script>
