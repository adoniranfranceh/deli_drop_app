<template>
  <div class="flex flex-col w-[800px] max-[758px]:w-full max-[758px]:h-full max-[758px]:rounded-none">
    <div class="w-full h-[400px] overflow-hidden bg-background max-[758px]:h-[270px]">
      <img :src="product.image" :alt="product.name" class="w-full h-full rounded-t-[10px] block object-cover" />
    </div>

    <div class="p-6 bg-white rounded-b-[10px] shadow-sm max-[758px]:px-4 max-[758px]:py-8">
      <div class="flex justify-between items-center max-[758px]:flex-col max-[758px]:items-start max-[758px]:gap-2">
        <h2 class="text-primary text-2xl mb-0">{{ product.name }}</h2>
        <div class="text-[1.6rem] font-bold text-black">{{ FloatToMoney(finalPrice) }}</div>
      </div>

      <div class="mt-4 text-[#555] leading-relaxed max-[758px]:text-center">
        <p>{{ product.description }}</p>
        <DeliveryDuration :duration="product.duration" />
      </div>

      <hr class="my-8 border-t border-border" />

      <ModifierGroup
        v-if="modifier_groups?.length > 0"
        v-for="group in modifier_groups"
        :key="group.id"
        :modifier_group="group"
        @update:selected="handleUpdateSelected"
      />

      <ProductIngredients
        v-if="product.ingredients?.length"
        :ingredients="product.ingredients"
      />

      <div class="flex flex-col items-start my-8">
        <label for="comment" class="font-bold">Algum comentário?</label>
        <textarea
          id="comment"
          rows="5"
          placeholder="Ex: sem cebola, sem maionese..."
          v-model="comment"
          class="w-full border border-border rounded-lg mt-4 resize-none max-[758px]:w-[97%]"
        />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { FloatToMoney } from '../../../../utils/modey'
import DeliveryDuration from '../../../ui/DeliveryDuration.vue'
import ModifierGroup from './ModifierGroup.vue'
import ProductIngredients from '../../../ui/ProductIngredients.vue'

const props = defineProps({
  product: {
    type: Object,
    required: true
  }
})

const modifier_groups = computed(() => (props.product.modifier_groups || []).filter(m => !m._destroy))

const comment = ref('')
const selectedByGroup = ref({}); 

function handleUpdateSelected({ group_id, items, extra_price }) {
  selectedByGroup.value[group_id] = { items, extra_price }; 
}

const additionalTotal = computed(() => {
  return Object.values(selectedByGroup.value).reduce(
    (total, group) => total + (group.extra_price || 0),
    0
  );
});

const finalPrice = computed(() => {
  return (props.product.base_price || 0) + additionalTotal.value
});
</script>

