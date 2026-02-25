<template>
  <form @submit.prevent class="flex items-center flex-col gap-8">
    <div class="flex flex-col gap-5 w-4/5 p-8 bg-white border border-border rounded-lg max-[758px]:w-full max-[758px]:p-1.5 max-[758px]:m-0">
      <h2 class="flex gap-2 m-0 text-xl font-bold max-[758px]:justify-center">
        <Icon icon="lucide-utensils" class="text-primary" /> Informações Básicas
      </h2>
      <p class="flex justify-center text-muted m-0 max-[758px]:text-center">
        Preencha as informações básicas do seu restaurante
      </p>

      <div class="flex gap-6 flex-wrap max-[758px]:flex-col">
        <InputGroup
          id="restaurant-name"
          label="Nome"
          placeholder="Nome do Restaurante"
          v-model="restaurant.name"
          :externalError="restaurantErrors?.name"
          required
        />

        <InputDropdown
          v-model="restaurant.culinary_style"
          :options="[
            { label: 'Açaí', value: 'acai' },
            { label: 'Brasileira', value: 'brazilian' },
            { label: 'Italiana', value: 'italian' },
            { label: 'Japonesa', value: 'japanese' },
            { label: 'Mexicana', value: 'mexican' },
            { label: 'Hamburguers', value: 'burgers' },
            { label: 'Pizza', value: 'pizza' },
            { label: 'Saudável', value: 'healthy' },
            { label: 'Vegetariana', value: 'vegetarian' },
            { label: 'Doces', value: 'sweets' },
            { label: 'Lanches', value: 'snacks' },
            { label: 'Churrasco', value: 'barbecue' },
            { label: 'Frutos do Mar', value: 'seafood' },
            { label: 'Cafeteria', value: 'coffee_shop' },
            { label: 'Sorveteria', value: 'ice_cream' }
          ]"
          placeholder="Tipo de Culinária"
          label="Tipo de Culinária"
          :externalError="restaurantErrors?.culinary_style"
          required
        />
      </div>

      <InputGroup
        id="restaurant-description"
        label="Descrição"
        isTextarea
        placeholder="Descreva seu restaurante, especialidades, diferenciais..."
        v-model="restaurant.description"
        :externalError="restaurantErrors?.description"
        required
      />

      <InputGroup
        id="restaurant-image"
        label="Imagem"
        placeholder="Imagem"
        v-model="restaurant.image"
        required
        :externalError="restaurantErrors?.image"
      />

      <div class="w-[300px] max-w-[300px] h-auto rounded-lg mt-4 max-[758px]:w-full max-[758px]:max-w-full">
        <img
          v-if="restaurant.image"
          alt="Restaurant"
          :src="restaurant.image"
          class="w-full h-full object-cover rounded-lg"
        />
      </div>
    </div>

    <div class="flex flex-col gap-5 w-4/5 p-8 bg-white border border-border rounded-lg max-[758px]:w-full max-[758px]:p-1.5 max-[758px]:m-0">
      <h2 class="flex gap-2 m-0 text-xl font-bold max-[758px]:justify-center">
        <Icon icon="lucide-map-pin" class="text-primary" /> Contato e Localização
      </h2>
      <div class="flex gap-6 flex-wrap max-[758px]:flex-col">
        <InputGroup
          id="restaurant-phone"
          label="Telefone"
          placeholder="(11) 99999-9999"
          v-model="restaurant.phone"
          :externalError="restaurantErrors?.phone"
          required
        />
        <InputGroup
          id="restaurant-email"
          label="Email"
          placeholder="restaurante@email.com"
          v-model="restaurant.email"
          :externalError="restaurantErrors?.email"
          required
          disabled
        />
      </div>

      <InputGroup
        id="restaurant-address"
        label="Endereço Completo"
        placeholder="Endereço do Restaurante"
        v-model="restaurant.address"
      />
    </div>
  </form>
</template>

<script setup>
import { Icon } from '@iconify/vue'
import InputGroup from '../ui/InputGroup.vue'
import InputDropdown from '../ui/InputDropdown.vue'

const props = defineProps({
  restaurant: Object,
  restaurantErrors: Object,
})

const emit = defineEmits(['update:restaurant'])
</script>

