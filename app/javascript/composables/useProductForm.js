import { ref, computed, reactive } from 'vue'
import { useProductValidator } from './useProductValidator'
import { useGroupsValidator } from './useGroupsValidator'

export function useProductForm(initialData = null) {
  const product = reactive({
    name: null,
    category: null,
    base_price: null,
    duration: null,
    description: null,
    image: null,
    status: 'active',
    featured: false,
    ingredients: [],
    modifier_groups: []
  });

  const step = ref(1);
  const nextStep = ref(null);

  const { errors: productErrors, isValid: isProductValid } = useProductValidator(product);
  const { isValid: areGroupsValid } = useGroupsValidator(computed(() => product.modifier_groups));
  const isEdition = ref(!!initialData);

  const hasMadeStep1Decision = computed(() => nextStep.value !== null || isEdition.value);
  const canProceedFromStep1 = computed(() => isProductValid.value && hasMadeStep1Decision.value);
  const isStep1Complete = computed(() => isProductValid.value);

  const hasModifiers = computed(() => product.modifier_groups.length > 0);
  const canProceedFromStep2 = computed(() => !hasModifiers.value || areGroupsValid.value);

  const isFormValid = computed(() => isProductValid.value && canProceedFromStep2.value);

  const isNextButtonDisabled = computed(() => {
    if (step.value === 1) {
      return !canProceedFromStep1.value
    }
    if (step.value === 2) {
      return !canProceedFromStep2.value;
    }
    return false;
  });

  const canClickSteps = computed(() => [
    true,
    isStep1Complete.value,
    isFormValid.value
  ]);

  return {
    product,
    step,
    nextStep,
    productErrors,
    isProductValid,
    isNextDisabled: isNextButtonDisabled,
    canClickSteps,
    isFormValid,
    isEdition
  };
}

export function useProductTemplate(product, forceCategoryError) {
  function fillProduct(template) {
    product.ingredients.length = 0;

    if (template.ingredients) {
      product.ingredients.push(...template.ingredients);
    }

    Object.assign(product, {
      ...template
    });

    forceCategoryError.value = true
  }

  return { fillProduct }
}
