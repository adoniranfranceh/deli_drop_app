<template>
  <div>
    <ModifierHeader
      :name="modifier_group.name"
      :min="modifier_group.min"
      :max="modifier_group.max"
      :freeLimit="modifier_group.free_limit"
      :totalSelected="totalSelected"
      :isCheckbox="isCheckbox"
      :isRadio="isRadio"
    />

    <ul class="p-0 list-none">
      <li
        v-for="item in modifiers"
        :key="item.id"
        class="border border-border rounded-lg p-4 mb-2 cursor-pointer transition-all duration-200 flex items-center justify-start"
        :class="{
          'bg-primary/10 border-primary': isSelected(item),
          'opacity-40 pointer-events-none': faded(item),
        }"
      >
        <label class="flex items-center justify-between cursor-pointer w-full">
          <div class="flex items-center h-[50px]">
            <input
              type="checkbox"
              :checked="isSelected(item)"
              @change="() => toggle(item)"
              :name="`modifier-${modifier_group.id}`"
              class="absolute opacity-0 w-5 h-5 m-0 cursor-pointer peer"
            />
            <span
              class="w-4 h-4 rounded-full border-2 border-border mr-4 shrink-0 relative transition-all duration-200 peer-checked:bg-primary peer-checked:border-primary peer-checked:after:content-[''] peer-checked:after:absolute peer-checked:after:top-[1px] peer-checked:after:left-[5px] peer-checked:after:w-1 peer-checked:after:h-2 peer-checked:after:border-white peer-checked:after:border-r-2 peer-checked:after:border-b-2 peer-checked:after:rotate-45"
              :class="{ 'rounded-[25%]': multiple }"
            ></span>

            <img
              :src="item.image"
              alt="Product"
              class="w-10 h-10 rounded mr-4 object-cover"
            />

            <div class="flex flex-col justify-center">
              <strong>{{ item.name }}</strong>
              <span class="text-sm text-muted max-[758px]:text-[11px]" v-if="Array.isArray(item.ingredients)">
                {{ item.ingredients.join(', ') }}
              </span>
              <span class="text-sm text-muted max-[758px]:text-[11px]" v-else>
                {{ item.ingredients || item.description }}
              </span>
            </div>
          </div>

          <div class="flex flex-col justify-center items-end">
            <div class="text-success text-[0.85rem] font-semibold">Incluso</div>
            <div class="font-normal text-[0.775rem] text-muted line-through" v-if="getBasePrice(item) > 0">
              {{ FloatToMoney(getBasePrice(item)) }}
            </div>
          </div>
        </label>
      </li>
    </ul>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { FloatToMoney } from '../../../../utils/modey'
import ModifierHeader from './ModifierHeader.vue'

const props = defineProps({
  modifier_group: Object,
  totalSelected: Number,
  isSelected: Function,
  faded: Function,
  toggle: Function,
  getBasePrice: Function,
  multiple: {
    type: Boolean,
    default: false
  },
  isCheckbox: Boolean,
  isRadio: Boolean
})

const modifiers = computed(() => (props.modifier_group.modifiers || []).filter(m => !m._destroy))
</script>

