import { watchEffect, reactive, computed } from 'vue'

export function useModifierValidator(modifiers) {
  const errors = reactive([])

  function validateName(modifier) {
    return !modifier.name?.trim() ? 'Nome é obrigatório' : null
  }

  function validatePrice(modifier) {
    const price = modifier.base_price
    const isBlank =
      price == null ||
      price === '' ||
      price === 0 ||
      (typeof price === 'string' && price.trim() === '')
    return isBlank ? 'Preço é obrigatório' : null
  }

  watchEffect(() => {
    errors.length = modifiers.length

    modifiers.forEach((modifier, index) => {
      if (!errors[index]) {
        errors[index] = { name: null, base_price: null }
      }

      errors[index].name = validateName(modifier)
      errors[index].base_price = validatePrice(modifier)
    })
  })

  const isValid = computed(() =>
    errors.every((e) => !e.name && !e.base_price)
  )

  return {
    errors,
    validate: () => isValid.value,
    isValid,
  }
}
