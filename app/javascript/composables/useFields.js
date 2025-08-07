import { ref } from 'vue'

export function useField() {
  const touched = ref(false)

  const onBlur = () => {
    touched.value = true
  }

  return {
    touched,
    onBlur
  }
}
