<template>
  <RestaurantFormOverview :restaurantExists="restaurantExists" />

  <div class="restaurant-form">
    <div class="form-container">
      <RestaurantBasicInputs
        :restaurant="restaurant"
        :restaurantErrors="restaurantErrors"
      />

      <div class="form-actions">
        <AppButton
          v-if="initialData.length > 0"
          class="cancel"
          text="Cancelar"
          @click="navigateTo('/')"
        />

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
import { navigateTo } from '../../utils/navigation';
import { apiPost, apiPut } from '../../utils/apiHelper';

const props = defineProps ({
  initialData: Object,
  currentEmail: String
})

const initialData = props.initialData
const currentEmail = props.currentEmail
const restaurantExists = initialData !== '' && initialData !== null && initialData !== undefined

const restaurant = reactive({
  name: initialData?.name || null,
  culinary_style: initialData?.culinary_style || null,
  description: initialData?.description || null,
  image: initialData?.image || null,
  phone: initialData?.phone || null,
  email: currentEmail || null,
  address: initialData?.address || null,
});

const { errors: restaurantErrors, isValid: isRestaurantValid } = useRestaurantValidator(restaurant);

function submit() {
  const payload = {
    name: restaurant.name,
    culinary_style: restaurant.culinary_style,
    description: restaurant.description,
    image: restaurant.image,
    phone: restaurant.phone,
    address: restaurant.address,
  };

  console.log('JSON Final para envio:', JSON.stringify(payload, null, 2));

  if (restaurantExists) {
    return apiPut(`/api/v1/restaurants/${initialData.id}`, payload, 'Restaurante atualizado com sucesso!');
  } else {
    return apiPost({
      endpoint: '/api/v1/restaurants',
      payload,
      successMessage: 'Restaurante criado com sucesso!'
    });
  }
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
