<template>
  <div class="bg-white rounded-lg overflow-hidden transition-all duration-200 border border-border flex flex-col cursor-pointer hover:scale-[1.02] hover:shadow-md">
    <div class="relative flex-1 flex flex-col">
      <div class="relative">
        <img :src="product.image" :alt="product.name" class="w-full h-[200px] object-cover rounded-t-lg" />
        <span class="bg-primary absolute top-2.5 left-2.5 rounded-full text-xs font-semibold text-white py-1 px-5">
          {{ product.featured ?  'Destaque' : product?.category_name }}
        </span>
      </div>
      <div class="p-4 flex-1 flex flex-col justify-between">
        <div>
          <div class="flex justify-between">
            <h3 class="text-2xl m-0 text-text overflow-hidden text-ellipsis whitespace-nowrap max-w-[220px]">{{ product.name }}</h3>
            <div>
              <ToggleSwitch
                v-model:is-active="product.active"
                @update:is-active="$emit('toggle-product', product.id, product.active)"
              />
            </div>
          </div>
          <p class="text-base text-muted my-2 leading-relaxed overflow-hidden line-clamp-2">{{ product.description }}</p>
        </div>
        <div class="flex justify-between items-center mt-4">
          <strong class="text-3xl font-bold text-primary">{{ FloatToMoney(product.base_price) }}</strong>
          <DeliveryDuration :duration="product.duration" />
        </div>
      </div>
    </div>
    <div class="flex justify-between gap-4 p-4 border-t border-border">
      <AppButton
        class="w-full"
        text="Editar"
        iconLeft="lucide:pen-line"
        variant="secondary"
        @click="navigateTo(`/products/${product.id}/edit`)"
      />
      <AppButton
        class="[&_svg]:w-6 [&_svg]:h-6"
        iconLeft="lucide:trash-2"
        variant="danger"
      />
    </div>
  </div>
</template>

<script setup>
import AppButton from '../ui/AppButton.vue';
import ToggleSwitch from '../ui/ToggleSwitch.vue';
import { FloatToMoney } from '../../utils/modey';
import DeliveryDuration from '../ui/DeliveryDuration.vue';
import { navigateTo } from '../../utils/navigation';

defineProps({
  product: {
    type: Object,
    required: true,
  },
});

defineEmits(['toggle-product', 'edit-product', 'view-product', 'delete-product']);
</script>
