<template>
  <RestaurantFormOverview />

  <div class="restaurant-form">
    <div class="form-container">
      <RestaurantBasicInputs
        :restaurant="restaurant"
        :restaurantErrors="restaurantErrors"
      />

      <div class="form-actions">
        <AppButton
          class="save"
          text="Salvar"
          icon="lucide-save"
          @click="submit"
          :disabled="!isRestaurantValid"
        />
      </div>
    </div>
  </div>
</template>

<script setup>
import { reactive } from 'vue';
import RestaurantFormOverview from './RestaurantFormOverview.vue';
import RestaurantBasicInputs from './RestaurantBasicInputs.vue';
import AppButton from '../ui/AppButton.vue';
import { useRestaurantValidator } from '../../composables/useRestaurantValidator';

const restaurant = reactive({
  name: null,
  culinary_style: null,
  description: null,
  image_url: null,
  phone: null,
  email: "email@email.com",
  address: null,
});

const { errors: restaurantErrors, isValid: isRestaurantValid } = useRestaurantValidator(restaurant);

function submit() {
  const payload = {
    name: restaurant.name,
    culinary_style: restaurant.culinary_style,
    description: null,
    image_url: null,
    phone: null,
    email: "email@email.com",
    address: null,
  };

  console.log('JSON Final para envio:', JSON.stringify(payload, null, 2));
}
</script>

<style scoped>
.restaurant-form {
  display: flex;
  justify-content: center;
}

.form-container {
  display: flex;
  flex-direction: column;
  padding: 2rem;
  gap: 2rem;
  background-color: var(--color-background);
  margin: 0 2rem;
  width: 1820px;
}

.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: 1rem;
  margin: 0;
  width: 91%;
  padding-inline: 1rem;
}

button.cancel {
  background: var(--color-white);
  border: 1px solid var(--color-border);
  color: var(--color-black);
}

button.cancel,
button.save {
  min-width: 140px;
  display: flex;
  align-items: center;
  justify-content: center;
}

:deep(.cta-button) {
  svg {
    width: 1rem;
    height: 1rem;
  }
}

button.cancel:hover {
  background-color: var(--color-border);
}

@media (max-width: 758px) {
  .form-container {
    width: 100%;
    margin: 0;
    padding: 0.5rem;
  }

  .form-actions {
    width: auto;
  }
}
</style>
