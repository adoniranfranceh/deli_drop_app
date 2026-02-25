<template>
  <div class="bg-white rounded-lg transition-all duration-200 border border-border flex flex-col justify-between cursor-pointer min-h-[300px] p-6 hover:shadow-md">
    <div>
      <div class="flex mb-4">
        <span class="text-xl font-bold flex justify-center w-full">{{ category.name }}</span>
        <div>
          <Icon icon="lucide:package" class="w-10 h-10 text-text-light" />
        </div>
      </div>
      <div class="flex flex-col gap-2">
        <div class="bg-background py-3 px-4 rounded flex justify-between">
          <span class="text-base font-medium">Produtos</span>
          <ItemChip :item="category.products_count" class="text-sm font-bold" />
        </div>
        <div class="bg-background py-3 px-4 rounded flex justify-between">
          <span class="text-base font-medium">Ativos</span>
          <ItemChip :item="category.actived_products_count" class="text-sm font-bold bg-success text-white" />
        </div>
        <div class="bg-background py-3 px-4 rounded flex justify-between">
          <span class="text-base font-medium">Preço Médio</span>
          <span>{{ FloatToMoney(category.average_price) }}</span>
        </div>
      </div>
    </div>
    <div class="flex gap-2">
      <AppButton
        text="Editar"
        iconLeft="lucide-pen-line"
        variant="secondary"
        class="w-full !py-2 !text-sm"
        @click="$emit('openCategoryForm', category)"
      />
      <AppButton iconLeft="lucide:trash-2" variant="danger" class="!py-2 !px-3 [&_svg]:w-5 [&_svg]:h-5" />
    </div>
  </div>
</template>

<script setup>
import { Icon } from '@iconify/vue';
import AppButton from '../ui/AppButton.vue';
import ItemChip from '../ui/ItemChip.vue'
import { FloatToMoney } from '../../utils/modey';

defineProps({
  category: {
    type: Object,
    required: true,
    default: () => ({
      name: '',
      productsCount: 0,
      activeProductsCount: 0,
    }),
  },
});
</script>
