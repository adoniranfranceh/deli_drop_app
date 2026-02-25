<template>
  <form @submit.prevent class="flex flex-col gap-5 w-4/5 p-8 bg-white border border-border rounded-lg max-[758px]:w-full max-[758px]:p-1.5 max-[758px]:m-0">
    <h2 class="flex gap-2 m-0 text-xl font-bold max-[758px]:justify-center">
      <Icon icon="lucide:package" width="24" height="24" class="text-primary" /> Informações Básicas
    </h2>
    <p class="flex justify-center text-muted m-0 max-[758px]:text-center">
      Preencha as informações básicas do seu produto
    </p>

    <div class="flex gap-6 flex-wrap max-[758px]:flex-col">
      <InputGroup
        id="product-name"
        label="Nome"
        placeholder="Nome do Produto"
        v-model="product.name"
        :externalError="errors?.name"
        required
      />

      <InputDropdown
        v-model="product.category_id"
        :options="categoryOptions"
        placeholder="Todas as categorias"
        :externalError="errors?.category_id"
        label="Categoria"
        :forceShowError="showCategoryError"
        required
      />
    </div>

    <div class="flex gap-6 flex-wrap max-[758px]:flex-col">
      <CurrencyInput
        id="product-price"
        label="Preço"
        v-model="product.base_price"
        :externalError="errors?.base_price"
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
      v-model="product.image"
    />

    <IngredientsInput v-model="localProduct.ingredients" />

    <div class="flex gap-6 items-center max-[758px]:items-start max-[758px]:gap-4">
      <ToggleSwitch v-model="product.status" label="Produto ativo" />
      <ToggleSwitch v-model="product.featured" label="Produto em destaque" />
    </div>
  </form>
</template>

<script setup>
import { Icon } from '@iconify/vue'
import InputGroup from '../../../ui/InputGroup.vue'
import InputDropdown from '../../../ui/InputDropdown.vue'
import CurrencyInput from '../../../ui/CurrencyInput.vue'
import InputNumber from '../../../ui/InputNumber.vue'
import ToggleSwitch from '../../../ui/ToggleSwitch.vue'
import IngredientsInput from './IngredientsInput.vue'
import { toRefs, ref, onMounted } from 'vue'
import axios from 'axios'

const props = defineProps({
  product: Object,
  errors: Object,
  showCategoryError: Boolean,
  isActive: Boolean
})

props.product.status = props.isActive

const emit = defineEmits(['update:product'])

const localProduct = toRefs(props.product)

const categoryOptions = ref([])

onMounted(async () => {
  try {
    const response = await axios.get('/api/v1/categories')
    categoryOptions.value = response.data.map(cat => ({
      label: cat.name,
      value: cat.id
    }))
  } catch (err) {
    console.error('Erro ao carregar categorias', err)
  }
})
</script>
