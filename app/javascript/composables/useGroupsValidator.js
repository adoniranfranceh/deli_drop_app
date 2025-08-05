import { computed } from 'vue'
import { useGroupValidator } from './useGroupValidator'

export function useGroupsValidator(groups) {
  const validators = computed(() =>
    groups.map(group => useGroupValidator(group))
  )

  const isValid = computed(() =>
    validators.value.every(v => v.isValid.value)
  )

  const errors = computed(() =>
    validators.value.map(v => v.errors)
  )

  return {
    isValid,
    errors
  }
}
