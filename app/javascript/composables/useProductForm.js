import { ref, computed, reactive } from 'vue'
import { useProductValidator } from './useProductValidator'
import { useGroupsValidator } from './useGroupsValidator'
import { cloneDeep } from 'lodash';

export function useProductForm(initialData = null) {
  const product = reactive(
    initialData ? cloneDeep(initialData) : {
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
    }
  );

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
    if (step.value === 1) return !canProceedFromStep1.value;
    if (step.value === 2) return !canProceedFromStep2.value;
    return false;
  });

  const stepVisibility = computed(() => ({
    stepOne: step.value === 1,
    quickTemplate: step.value === 1 && !isEdition.value,
    modifierPrompt: isProductValid.value && step.value === 1 && !isEdition.value,
    stepTwo: step.value === 2,
    stepThree: step.value === 3
  }));

  const canClickSteps = computed(() => [
    true,
    isStep1Complete.value,
    isFormValid.value
  ]);

  function buildModifier(modifier) {
    return {
      id: modifier.id,
      name: modifier.name,
      base_price: Number(modifier.base_price),
      image: modifier.image,
      _destroy: modifier._destroy || false,
    }
  }

  function buildModifierGroup(group) {
    return {
      id: group.id,
      name: group.name,
      input_type: group.input_type,
      min: group.min,
      max: group.max,
      free_limit: group.free_limit,
      _destroy: group._destroy || false,
      modifiers_attributes: group.modifiers.map(buildModifier)
    }
  }

  function buildPayload(product) {
    return {
      name: product.name,
      category_id: product.category_id,
      base_price: Number(product.base_price),
      duration: Number(product.duration),
      description: product.description,
      ingredients: product.ingredients,
      image: product.image,
      featured: product.featured,
      status: product.status ? 'active' : 'inactive',
      modifier_groups_attributes: product.modifier_groups.map(buildModifierGroup)
    }
  }

  function normalizeProduct(product) {
    return buildPayload({
      ...product,
      modifier_groups: product?.modifier_groups || product?.modifier_groups_attributes || []
    });
  }

  function getPayload() {
    return buildPayload(product);
  }

  function getNormalizedInitial() {
    return normalizeProduct(initialData);
  }


  return {
    product,
    step,
    nextStep,
    productErrors,
    stepVisibility,
    isNextDisabled: isNextButtonDisabled,
    canClickSteps,
    isFormValid,
    isEdition,
    getPayload,
    getNormalizedInitial
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
