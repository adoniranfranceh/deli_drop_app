import { reactive, watchEffect, computed } from 'vue'

export function useRestaurantValidator(restaurant) {
  const errors = reactive({
    name: null,
    culinary_style: null,
    description: null,
    image_url: null,
    phone: null,
    email: null,
    address: null,
  })

  function validateName() {
    return !restaurant.name?.trim() ? 'Nome do restaurante é obrigatório' : null
  }

  function validateCulinaryStyle() {
    return !restaurant.culinary_style ? 'Estilo culinário é obrigatório' : null
  }

  function validateDescription() {
    return !restaurant.description?.trim() ? 'Descrição é obrigatória' : null
  }

  function validateImageUrl() {
    return !restaurant.image_url?.trim() ? 'URL da imagem é obrigatória' : null
  }

  function validatePhone() {
    return !restaurant.phone?.trim() ? 'Telefone é obrigatório' : null
  }

  function validateEmail() {
    return !restaurant.email?.trim() ? 'Email é obrigatório' : null
  }

  watchEffect(() => {
    errors.name = validateName()
    errors.culinary_style = validateCulinaryStyle()
    errors.description = validateDescription()
    errors.image_url = validateImageUrl()
    errors.phone = validatePhone()
    errors.email = validateEmail()
  })

  const isValid = computed(() =>
    Object.values(errors).every((err) => err === null)
  )

  return {
    errors,
    isValid,
  }
}
