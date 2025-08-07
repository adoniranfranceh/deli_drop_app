import "./stylesheets/application.css";
import { createApp } from 'vue'
import App from './components/App.vue'
import Dashboard from './components/dashboard/Dashboard.vue'
import Menu from './components/menu/MenuCenter.vue'
import ProductForm from './components/products/ProductForm.vue'

document.addEventListener('DOMContentLoaded', () => {
  const appEl = document.getElementById('app-vue')
  if (appEl) {
    createApp(App).mount(appEl)
  }

  const dashboardEl = document.getElementById('dashboard-widget')
  if (dashboardEl) {
    createApp(Dashboard).mount(dashboardEl)
  }

  const menuEl = document.getElementById('menu-widget')
  if (menuEl) {
    createApp(Menu).mount(menuEl)
  }

  const newPro = document.getElementById('new-product')
  if (newPro) {
    createApp(ProductForm).mount(newPro)
  }
})
