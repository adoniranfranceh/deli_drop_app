import { ref, computed, reactive } from 'vue'
import { useProductValidator } from './useProductValidator'
import { useGroupsValidator } from './useGroupsValidator'

export function useProductForm() {
  const product = reactive({
    name: null,
    category: null,
    price: null,
    duration: null,
    description: null,
    image_url: null,
    isActive: true,
    isFeatured: false,
    ingredients: [],
    modifiers_groups: []
  })

  const step = ref(1)
  const nextStep = ref(null)

  const { errors: productErrors, isValid: isProductValid } = useProductValidator(product)
  const { isValid: groupsValid } = useGroupsValidator(computed(() => product.modifiers_groups))

  const canContinueStep1 = computed(() => {
    return isProductValid.value && nextStep.value !== null
  })

  const isStep1Invalid = computed(() => step.value === 1 && !canContinueStep1.value)

  const isStep2Invalid = computed(() => {
    return step.value === 2 && (!groupsValid.value || (product.modifiers_groups.length > 0 && !groupsValid.value))
  })

  const isNextDisabled = computed(() => isStep1Invalid.value || isStep2Invalid.value)

  const allValid = computed(() => isProductValid.value && groupsValid.value)

  const canClickSteps = computed(() => [
    true,
    isProductValid.value,
    allValid.value && nextStep.value === 3
  ])

  return {
    product,
    step,
    nextStep,
    productErrors,
    isProductValid,
    isNextDisabled,
    canClickSteps
  }
}

export function useProductTemplate(product) {
  function fillProduct(template) {
    Object.assign(product, {
      name: null,
      category: null,
      price: null,
      duration: null,
      description: null,
      image_url: null,
      isActive: true,
      isFeatured: false,
      ingredients: [],
      modifiers_groups: [],
      ...template
    })
  }

  return { fillProduct }
}
