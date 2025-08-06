import { computed, isRef } from 'vue'
import { useGroupValidator } from './useGroupValidator'

export function useGroupsValidator(groups) {
  const groupsValue = computed(() => (isRef(groups) ? groups.value : groups));

  const validators = computed(() =>
    groupsValue.value.map(group => useGroupValidator(group))
  )

  const isValid = computed(() => {
    return groupsValue.value.length > 0 && validators.value.every(v => v.isValid.value)
  })

  const errors = computed(() =>
    validators.value.map(v => v.errors)
  )

  return {
    isValid,
    errors
  }
}
