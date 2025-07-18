<template>
  <div class="empty-box">
    <Icon icon="tabler:package" class="empty-icon" />
    <p class="empty-text">Nenhum {{ product ? 'produtos' : 'categorias' }} encontrado</p>
    <p class="empty-subtext">Comece adicionando {{ product ? 'seu primeiro produto' : 'sua primeira categoria' }}</p>
    <AppButton iconLeft="tabler:plus" :text="`Adicionar ${product ? 'Produtos' : 'Categorias'}`"/>
  </div>
</template>

<script setup>
import { Icon } from '@iconify/vue'
import AppButton from '../ui/AppButton.vue';

defineProps({
  product: {
    type: Boolean,
    default: false,
  }
})
</script>

<style scoped>
.empty-box {
  background-color: var(--color-white);
  border: 1px solid var(--color-border);
  border-radius: 8px;
  padding: 3rem;
  text-align: center;
  color: var(--color-muted);
  margin-top: 2rem;
}

.empty-box p {
  color: var(--color-muted);
}

.empty-icon {
  width: 4.5rem;
  height: 4.5rem;
  margin-bottom: 1rem;
  color: var(--color-border);
}

.empty-text {
  font-weight: 600;
  font-size: 1.2rem;
  margin: 0;
}

.empty-subtext {
  font-size: 1rem;
  margin-bottom: 1rem;
}

.btn-primary {
  background: var(--color-primary);
  color: var(--color-white);
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 6px;
  cursor: pointer;
  font-weight: 500;
}
</style>
