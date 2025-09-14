import "./stylesheets/application.css";
import { createApp } from 'vue'
import App from './components/App.vue'
import Dashboard from './components/dashboard/Dashboard.vue'
import Menu from './components/menu/MenuCenter.vue'
import ProductForm from './components/products/ProductForm.vue'
import RestaurantForm from "./components/restaurant/RestaurantForm.vue";
import FlashMessage from './components/ui/FlashMessage.vue'

document.addEventListener('DOMContentLoaded', () => {
  const appEl = document.getElementById('app-vue')
  if (appEl) {
    createApp(App).mount(appEl)
  }

  const flashEl = document.getElementById('flash-messages')
  if (flashEl) {
    const type = flashEl.dataset.type
    const message = flashEl.dataset.message
    createApp(FlashMessage, { type, message }).mount(flashEl)
  }

  const dashboardEl = document.getElementById('dashboard-widget')
  if (dashboardEl) {
    const restaurantData = JSON.parse(dashboardEl.dataset.restaurant);

    createApp(Dashboard, { restaurantData: restaurantData }).mount(dashboardEl)
  }

  const menuEl = document.getElementById('menu-widget')
  if (menuEl) {
    const categoriesData = JSON.parse(menuEl.dataset.categories);

    createApp(Menu, { categories: categoriesData }).mount(menuEl)
  }

  const newPro = document.getElementById('new-product')
  if (newPro) {
    createApp(ProductForm).mount(newPro)
  }

  const editRestaurant = document.getElementById('edit-restaurant')
  if (editRestaurant) {
    const restaurantData = JSON.parse(editRestaurant.dataset.restaurant);
    const dataEmail = editRestaurant.dataset.email;

    createApp(RestaurantForm, { initialData: restaurantData, currentEmail: dataEmail}).mount(editRestaurant)
  }

  const newRestaurant = document.getElementById('new-restaurant')
  if (newRestaurant) {
    const restaurantData = ''
    const dataEmail = newRestaurant.dataset.email;

    createApp(RestaurantForm, { initialData: restaurantData, currentEmail: dataEmail}).mount(newRestaurant)
  }
})
