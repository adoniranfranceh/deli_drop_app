import { reactive, watchEffect, computed } from 'vue'

export function useCategoryValidator(product) {
  const errors = reactive({
    name: null,
    description: null,
  })

  function validateName() {
    return !product.name?.trim() ? 'Nome da categoria é obrigatório' : null
  }

  watchEffect(() => {
    errors.name = validateName()
  })

  const isValid = computed(() =>
    Object.values(errors).every((err) => err === null)
  )

  return {
    errors,
    isValid,
  }
}
