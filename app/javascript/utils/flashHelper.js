import { createApp } from 'vue'
import FlashMessage from '../components/ui/FlashMessage.vue'
import axios from 'axios'

export async function updateFlash(params) {
  const query = new URLSearchParams(params).toString()
  const response = await axios.get(`/flash/show?${query}`)
  const html = response.data

  const parser = new DOMParser()
  const doc = parser.parseFromString(html, 'text/html')
  const flashEl = doc.querySelector('#flash-messages')
  const target = document.getElementById('flash')

  if (flashEl && target) {
    target.innerHTML = ''
    target.appendChild(flashEl)

    const { type, message } = flashEl.dataset
    createApp(FlashMessage, { type, message }).mount(flashEl)
  }
}
