<template>
  <div class="modifier-options">
    <h2 class="title">
      <Icon icon="lucide-lightbulb" class="light-icon" />
      Seu produto tem opções?
    </h2>
    <p class="subtitle">
      <strong>Modificadores</strong> permitem que seus clientes personalizem o produto. Por exemplo:
    </p>

    <div class="examples">
      <div v-for="example in examples" :key="example.label" class="example-box">
        <div class="example-header">
          <span class="emoji"><Icon :icon="example.icon" /></span>
          <span class="label">{{ example.label }}</span>
        </div>
        <span class="description">{{ example.description }}</span>
      </div>
    </div>

    <div class="actions">
      <AppButton
        class="yes"
        text="Sim, adicionar opções"
        iconLeft="lucide-settings"
        @click="emit('modifiers-decision', 2)"
      />
      <AppButton
        class="no"
        text="Não, produto simples"
        iconLeft="lucide:target"
        @click="emit('modifiers-decision', 3)"
      />
    </div>
  </div>
</template>

<script setup>
import { Icon } from '@iconify/vue'
import AppButton from '../ui/AppButton.vue'

const emit = defineEmits(['modifiers-decision'])

const examples = [
  { icon: 'noto:pizza', label: 'Pizza', description: 'Tamanhos, sabores, bordas' },
  { icon: 'noto:hamburger', label: 'Hambúrguer', description: 'Adicionais, molhos, ponto da carne' },
  { icon: 'noto:ice-cream', label: 'Açaí', description: 'Complementos, frutas, coberturas' },
  { icon: 'noto:tropical-drink', label: 'Bebidas', description: 'Tamanhos, temperaturas' },
]
</script>

<style scoped>
.modifier-options {
  background-color: #fff7f0;
  border: 1px solid #ffd8af;
  padding: 2rem;
  border-radius: 8px;
  display: flex;
  flex-direction: column;
  gap: 1.2rem;
  margin-top: 2rem;
  width: 80%;
}

.title {
  display: flex;
  align-items: center;
  color: rgb(154 52 18) ;
  font-weight: 600;
  gap: 0.5rem;
  margin: 0;
}

.subtitle {
  color: var(--color-muted);
  font-size: 1rem;
  margin: 0;
}

.examples {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 1rem;
}

.emoji {
  svg {
    height: 1.5rem;
    width: 1.5rem;
  }
}

.example-box {
  flex: 1 1 200px;
  background-color: var(--color-white);
  padding: 0.8rem;
  border-radius: 6px;
  text-align: left;
  display: flex;
  flex-direction: column;
  gap: 0.3rem;
}

.example-header {
  display: flex;
  align-items: center;
  gap: 0.3rem;
  color: #d35400;
  font-weight: bold;
}

.description {
  color: var(--color-muted);
  font-size: 0.9rem;
}

.actions {
  display: flex;
  gap: 1rem;
  
  button {
    flex: 1;
    display: flex;
    justify-content: center;
  }
}

.yes {
  border: none;
}

.no {
  background-color: var(--color-white);
  color: var(--color-black);
  border: 1px solid var(--color-border);
  height: 100%;
}

.no:hover {
  background-color: var(--color-border);
}

@media (max-width: 600px) {
  .examples {
    grid-template-columns: 1fr;
  }

  .actions {
    flex-direction: column;
  }
}
</style>
