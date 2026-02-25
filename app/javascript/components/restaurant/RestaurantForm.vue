<template>
  <RestaurantFormOverview :restaurantExists="restaurantExists" />

  <div class="flex justify-center">
    <div class="flex flex-col p-8 gap-8 bg-background mx-8 max-w-[1820px] w-full max-[758px]:w-full max-[758px]:m-0 max-[758px]:p-2">
      <RestaurantBasicInputs
        :restaurant="restaurant"
        :restaurantErrors="restaurantErrors"
      />

      <div class="flex justify-end gap-4 m-0 w-[91%] px-4 max-[758px]:w-auto">
        <AppButton
          v-if="initialData.length > 0"
          text="Cancelar"
          variant="secondary"
          @click="navigateTo('/')"
          class="min-w-[140px] flex items-center justify-center"
        />

        <AppButton
          text="Salvar"
          icon="lucide-save"
          @click="submit"
          :disabled="!isRestaurantValid"
          class="min-w-[140px] flex items-center justify-center [&_svg]:w-4 [&_svg]:h-4"
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

  if (restaurantExists) {
    return apiPut({
      endpoint: `/api/v1/restaurants/${initialData.id}`,
      payload,
      successMessage: 'Restaurante atualizado com sucesso!'
    });
  } else {
    return apiPost({
      endpoint: '/api/v1/restaurants',
      payload,
      successMessage: 'Restaurante criado com sucesso!'
    });
  }
}
</script>

