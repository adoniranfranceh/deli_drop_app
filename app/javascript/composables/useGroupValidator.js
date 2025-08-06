import { reactive, watchEffect, computed } from 'vue'

export function useGroupValidator(group) {
  const errors = reactive({
    name: null,
    input_type: null,
    min: null,
    max: null,
    free_limit: null,
    modifiers: null
  })

  function validateName() {
    return !group.name?.trim() ? 'Nome é obrigatório' : null
  }

  function validateInputType() {
    return !group.input_type ? 'Tipo é obrigatório' : null
  }

  function validateMin() {
    if (group.min == null || group.min === '') return 'Min é obrigatório'
    if (group.min < 0) return 'Mínimo inválido'
    if (group.max != null && group.min > group.max) return 'Min deve ser menor que o max'
    return null
  }

  function validateMax() {
    if (group.max == null || group.max === '') return 'Max é obrigatório'
    if (group.min != null && group.max < group.min) return 'Max deve ser maior que o min'
    return null
  }

  function validateFreeLimit() {
    if (group.free_limit == null || group.free_limit === '') return 'Limite grátis é obrigatório'
    if (group.free_limit < 0) return 'Limite grátis inválido'
    if (group.max != null && group.free_limit > group.max) return 'Limite grátis não pode ser maior que max'
    return null
  }

  function validateModifiers() {
    const modifiers = group.modifiers
    if (!modifiers || modifiers.length === 0) return 'Pelo menos um modificador é obrigatório'
    for (const mod of modifiers) {
      if (!mod.name?.trim()) {
        return 'Todos os modificadores devem ter nome e preço válidos'
      }
    }
    return null
  }

  watchEffect(() => {
    errors.name = validateName()
    errors.input_type = validateInputType()
    errors.min = validateMin()
    errors.max = validateMax()
    errors.free_limit = validateFreeLimit()
    errors.modifiers = validateModifiers()
  })

  const isValid = computed(() =>
    Object.values(errors).every(err => err === null)
  )

  return {
    errors,
    isValid
  }
}
