<template>
  <div class="flex flex-col gap-5 w-4/5 p-8 bg-white border border-border rounded-lg max-[758px]:w-full max-[758px]:p-1.5 max-[758px]:m-0">
    <h2 class="flex gap-2 m-0 text-xl font-bold max-[758px]:justify-center">
      <Icon icon="lucide-zap" class="text-primary" width="24" height="24" /> Ações rápidas
    </h2>
    <p class="flex justify-center text-muted m-0 max-[758px]:text-center">Escolha um template para preencher automaticamente</p>
    <div class="flex gap-6 max-[758px]:gap-2">
      <div
        v-for="action in actions"
        :key="action.label"
        class="w-[23%] rounded-md py-6 px-4 text-center cursor-pointer transition-all duration-200 hover:saturate-[2.9] max-[758px]:py-4 max-[758px]:px-2"
        @click="selectTemplate(action.label)"
        :style="{ background: action.background }"
      >
        <div class="flex justify-center mb-2 max-[758px]:m-0"><Icon :icon="action.icon" width="26" height="26" class="max-[758px]:!w-4 max-[758px]:!h-4" /></div>
        <span class="font-semibold text-black max-[758px]:text-[0.5rem]">{{ action.label }}</span>
      </div>
    </div>
  </div>
</template>

<script setup>
import { Icon } from '@iconify/vue';

const actions = [
  { label: 'Pizza', icon: 'lucide:pizza', background: '#fee2e1' },
  { label: 'Hambúrguer', icon: 'lucide:hamburger', background: '#ffedd5'},
  { label: 'Açaí', icon: 'lucide:ice-cream-bowl', background: '#f4e8ff' },
  { label: 'Bebida', icon: 'lucide-coffee', background: '#dbeaff' }
]

const emit = defineEmits(['update:product'])

function selectTemplate(label) {
  const templates = {
    Pizza: {
      name: 'Pizza Margherita',
      base_price: 3590,
      duration: 25,
      description: 'Deliciosa pizza de queijo e tomate.',
      image: 'https://static.itdg.com.br/images/1200-630/47d6583c93d77edac5244cab67ba660b/253447-378226756-original.jpg',
      status: 'active',
      featured: false,
      ingredients: ['Queijo', 'Tomate', 'Manjericão'],
      modifier_groups: [],
    },
    Hambúrguer: {
      name: 'Hambúrguer Clássico',
      base_price: 2850,
      duration: 20,
      description: 'Pão, carne, queijo e molho especial.',
      status: 'active',
      featured: false,
      ingredients: ['Pão', 'Carne', 'Queijo'],
      image: 'https://www.minhareceita.com.br/app/uploads/2023/08/x-bacon-portal-minha-receita.jpg',
      modifier_groups: [],
    },
    Açaí: {
      name: 'Tigela de Açaí',
      base_price: 1800,
      duration: 15,
      description: 'Açaí com banana, granola e mel.',
      status: 'active',
      featured: false,
      image: 'https://flordejambu.com/wp-content/uploads/2022/05/acai.png',
      modifier_groups: [],
    },
    Bebida: {
      name: 'Suco Natural',
      base_price: 750,
      duration: 5,
      description: 'Suco natural de frutas frescas.',
      status: 'active',
      featured: false,
      ingredients: ['Fruta'],
      image: 'https://s3-sa-east-1.amazonaws.com/deliveryon-uploads/products/imperio/38_5c58b562c06f5.jpg',
      modifier_groups: [],
    }
  }

  const selected = templates[label] || {}
  emit('update:product', selected)
}
</script>
