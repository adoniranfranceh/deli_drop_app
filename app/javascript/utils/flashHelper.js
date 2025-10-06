import { createApp } from 'vue'
import FlashMessage from '../components/ui/FlashMessage.vue'

export function showFlash({ type = 'success', message = '' }) {
  const flashEl = document.getElementById('flash')
  if (!flashEl || !message) return

  createApp(FlashMessage, { type, message }).mount(flashEl)
}
