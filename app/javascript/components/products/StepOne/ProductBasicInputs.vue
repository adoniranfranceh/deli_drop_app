<template>
  <form @submit.prevent class="form-grid">
    <h2 class="product-form-title">
      <Icon icon="lucide:package" /> Informações Básicas
    </h2>
    <p class="product-form-subtitle">
      Preencha as informações básicas do seu produto
    </p>

    <div class="form-row">
      <InputGroup
        id="product-name"
        label="Nome"
        placeholder="Nome do Produto"
        v-model="product.name"
        :externalError="errors?.name"
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
        :externalError="errors?.category"
        label="Categoria"
        :forceShowError="showCategoryError"
        required
      />
    </div>

    <div class="form-row">
      <CurrencyInput
        id="product-price"
        label="Preço"
        v-model="product.price"
        :externalError="errors?.price"
        required
      />

      <InputNumber
        id="product-duration"
        label="Tempo de preparo"
        placeholder="Tempo de preparo (minutos)"
        v-model="product.duration"
        :min="1"
        :max="1000"
        :externalError="errors?.duration"
        required
      />
    </div>

    <InputGroup
      id="product-description"
      label="Descrição"
      isTextarea
      placeholder="Descreva o produto..."
      v-model="product.description"
      :externalError="errors?.description"
      required
    />

    <InputGroup
      id="product-image"
      label="Imagem"
      placeholder="Imagem"
      v-model="product.image_url"
    />

    <IngredientsInput v-model="localProduct.ingredients" />

    <div class="switch-wrapper">
      <ToggleSwitch v-model="product.isActive" label="Produto ativo" />
      <ToggleSwitch v-model="product.isFeatured" label="Produto em destaque" />
    </div>
  </form>
</template>

<script setup>
import { Icon } from '@iconify/vue'
import InputGroup from '../../ui/InputGroup.vue'
import InputDropdown from '../../ui/InputDropdown.vue'
import CurrencyInput from '../../ui/CurrencyInput.vue'
import InputNumber from '../../ui/InputNumber.vue'
import ToggleSwitch from '../../ui/ToggleSwitch.vue'
import IngredientsInput from './IngredientsInput.vue'
import { toRefs } from 'vue'

const props = defineProps({
  product: Object,
  errors: Object,
  showCategoryError: Boolean,
})

const emit = defineEmits(['update:product'])

const localProduct = toRefs(props.product)
</script>

<style scoped>
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

.product-form-title {
  display: flex;
  gap: 0.5rem;
  margin: 0;
}

.product-form-subtitle {
  display: flex;
  justify-content: center;
  color: var(--color-muted);
  margin: 0;
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

@media (max-width: 758px) {
  .form-grid {
    width: 100%;
    padding: 0.4rem;
    margin: 0;
  }

  .product-form-title {
    justify-content: center
  }

  .product-form-subtitle {
    text-align: center;
  }

  .switch-wrapper {
    align-items: flex-start;
    gap: 1rem;
  }

  .form-row {
    flex-direction: column;
  }
}
</style>
