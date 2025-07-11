import { createApp } from 'vue'
import App from './components/App.vue'
import Dashboard from './components/dashboard/Dashboard.vue'

document.addEventListener('DOMContentLoaded', () => {
  const appEl = document.getElementById('app-vue')
  if (appEl) {
    createApp(App).mount(appEl)
  }

  const dashboardEl = document.getElementById('dashboard-widget')
  if (dashboardEl) {
    createApp(Dashboard).mount(dashboardEl)
  }
})
