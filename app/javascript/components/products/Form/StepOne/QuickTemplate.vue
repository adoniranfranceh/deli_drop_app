<template>
  <div class="quick-container">
    <h2 class="quick-title">
      <Icon icon="lucide-zap" class="zap-icon" /> Ações rápidas
    </h2>
    <p class="quick-subtitle">Escolha um template para preencher automaticamente</p>
    <div class="quick-actions">
      <div
        v-for="action in actions"
        :key="action.label"
        class="quick-action-card"
        @click="selectTemplate(action.label)"
        :style="{ background: action.background }"
      >
        <div class="quick-action-icon"><Icon :icon="action.icon" /></div>
        <span class="quick-action-label">{{ action.label }}</span>
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
      price: 3590,
      duration: 25,
      description: 'Deliciosa pizza de queijo e tomate.',
      image_url: 'https://static.itdg.com.br/images/1200-630/47d6583c93d77edac5244cab67ba660b/253447-378226756-original.jpg',
      isActive: true,
      isFeatured: false,
      ingredients: ['Queijo', 'Tomate', 'Manjericão'],
      modifier_groups: [],
    },
    Hambúrguer: {
      name: 'Hambúrguer Clássico',
      price: 2850,
      duration: 20,
      description: 'Pão, carne, queijo e molho especial.',
      isActive: true,
      isFeatured: false,
      ingredients: ['Pão', 'Carne', 'Queijo'],
      image_url: 'https://www.minhareceita.com.br/app/uploads/2023/08/x-bacon-portal-minha-receita.jpg',
      modifier_groups: [],
    },
    Açaí: {
      name: 'Tigela de Açaí',
      price: 1800,
      duration: 15,
      description: 'Açaí com banana, granola e mel.',
      isActive: true,
      isFeatured: false,
      image_url: 'https://flordejambu.com/wp-content/uploads/2022/05/acai.png',
      modifier_groups: [],
    },
    Bebida: {
      name: 'Suco Natural',
      price: 750,
      duration: 5,
      description: 'Suco natural de frutas frescas.',
      isActive: true,
      isFeatured: false,
      ingredients: ['Fruta'],
      image_url: 'https://s3-sa-east-1.amazonaws.com/deliveryon-uploads/products/imperio/38_5c58b562c06f5.jpg',
      modifier_groups: [],
    }
  }

  const selected = templates[label] || {}
  emit('update:product', selected)
}
</script>

<style scoped>
.quick-container {
  display: flex;
  flex-direction: column;
  gap: 1.2rem;
  width: 80%;
  padding: 2rem;
  background: var(--color-white);
  border: 1px solid var(--color-border);
  border-radius: 8px;
}

.quick-title {
  display: flex;
  gap: 0.5rem;
  margin: 0;
}

.zap-icon {
  color: var(--color-primary);
}

.quick-subtitle {
  display: flex;
  justify-content: center;
  color: var(--color-muted);
  margin: 0;
}

.quick-actions {
  display: flex;
  gap: 1.5rem;
}

.quick-action-card {
  width: 23%;
  height: 54px;
  background: var(--color-white);
  border-radius: 6px;
  padding: 1.5rem 1rem;
  text-align: center;
  cursor: pointer;
  transition: filter 0.2s ease;
}

.quick-action-card:hover {
  filter: saturate(2.9);
}

.quick-action-icon {
  font-size: 1.6rem;
  margin-bottom: 0.5rem;
}

.quick-action-label {
  font-weight: 600;
  color: var(--color-black);
  justify-content: center
}

@media (max-width: 758px) {
  .quick-container {
    width: 100%;
    padding: 0.4rem;
    margin: 0;
  }

  .quick-title {
    justify-content: center
  }

  .quick-subtitle {
    text-align: center;
  }

  .quick-actions {
    gap: 0.5rem;
  }

  .quick-action-card {
    padding: 1rem;
    height: 37px;
  }

  .quick-action-icon {
    font-size: 1rem;
    margin: 0;
  }

  .quick-action-label {
    color: var(--color-black);
    font-size: 0.5rem;
  }
}
</style>
