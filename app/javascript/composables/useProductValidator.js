import { reactive, watchEffect, computed } from 'vue'

export function useProductValidator(product) {
  const errors = reactive({
    name: null,
    category_id: null,
    base_price: null,
    duration: null,
    description: null,
  })

  function validateName() {
    return !product.name?.trim() ? 'Nome do produto é obrigatório' : null
  }

  function validateCategory() {
    return !product.category_id ? 'Categoria é obrigatória' : null
  }

  function validatePrice() {
    return Number(product.base_price) <= 0.00 ? 'Preço é obrigatório' : null
  }

  function validateDuration() {
    return Number(product.duration) <= 0
      ? 'Tempo de preparo é obrigatório'
      : null
  }

  function validateDescription() {
    return !product.description?.trim()
      ? 'Descrição é obrigatória'
      : null
  }

  watchEffect(() => {
    errors.name = validateName()
    errors.category_id = validateCategory()
    errors.base_price = validatePrice()
    errors.duration = validateDuration()
    errors.description = validateDescription()
  })

  const isValid = computed(() =>
    Object.values(errors).every((err) => err === null)
  )

  return {
    errors,
    isValid,
  }
}
