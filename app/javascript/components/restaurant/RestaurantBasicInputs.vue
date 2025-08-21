<template>
  <form @submit.prevent>
    <div class="form-grid">
      <h2 class="restaurant-form-title">
        <Icon icon="lucide-utensils" /> Informações Básicas
      </h2>
      <p class="restaurant-form-subtitle">
        Preencha as informações básicas do seu restaurante
      </p>
  
      <div class="form-row">
        <InputGroup
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
            { label: 'Cafeteria', value: 'coffee-shop' },
            { label: 'Sorveteria', value: 'ice-cream' }
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
        label="Imagem"
        placeholder="Imagem"
        v-model="restaurant.image_url"
        required
        :externalError="restaurantErrors?.image_url"
      />

      <div class="restaurant-image">
        <img
          v-if="restaurant.image_url"
          alt="Restaurant"
          :src="restaurant.image_url"
        />
      </div>
    </div>

    <div class="form-grid">
      <h2 class="restaurant-form-title">
        <Icon icon="lucide-map-pin" /> Contato e Localização
      </h2>
      <div class="form-row">
        <InputGroup
          label="Telefone"
          placeholder="(11) 99999-9999"
          v-model="restaurant.phone"
          :externalError="restaurantErrors?.phone"
          required
        />
        <InputGroup
          label="Email"
          placeholder="restaurante@email.com"
          v-model="restaurant.email"
          :externalError="restaurantErrors?.email"
          required
          disabled
        />
      </div>

      <InputGroup
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

<style scoped>
form {
  display: flex;
  align-items: center;
  flex-direction: column;
  gap: 2rem;
}

.form-grid {
  display: flex;
  flex-direction: column;
  gap: 1.2rem;
  width: 80%;
  padding: 2rem;
  background: var(--color-white);
  border: 1px solid var(--color-border);
  border-radius: 8px;
}

.restaurant-form-title {
  display: flex;
  gap: 0.5rem;
  margin: 0;
}

.restaurant-form-subtitle {
  display: flex;
  justify-content: center;
  color: var(--color-muted);
  margin: 0;
}

.form-row {
  display: flex;
  gap: 1.5rem;
  flex-wrap: wrap;
}

.restaurant-image {
  width: 300px;
  max-width: 300px;
  height: auto;
  border-radius: 8px;
  margin-top: 1rem;

  img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    border-radius: 8px;
  }
}

.switch-wrapper {
  display: flex;
  gap: 1.5rem;
  align-items: center;
}

@media (max-width: 758px) {
  .form-grid {
    width: 100%;
    padding: 0.4rem;
    margin: 0;
  }

  .restaurant-form-title {
    justify-content: center
  }

  .restaurant-form-subtitle {
    text-align: center;
  }

  .switch-wrapper {
    align-items: flex-start;
    gap: 1rem;
  }

  .form-row {
    flex-direction: column;
  }

  .restaurant-image {
    width: 100%;
    max-width: 100%;
  }
}
</style>
