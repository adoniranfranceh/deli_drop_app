<template>
  <div class="category-header">
    <h2>Gerenciar Categorias</h2>
    <AppButton text="Nova Categoria" class="btn-add" iconLeft="tabler:plus" />
  </div>
  <div class="dashboard-filters">
    <SearchInput class="input" />
  </div>
</template>

<script setup>
import AppButton from '../ui/AppButton.vue';
import SearchInput from '../ui/SearchInput.vue';
</script>

<style scoped>
.category-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.input {
  flex: 1;
}

.dashboard-filters {
  display: flex;
  justify-content: space-between;
  background: var(--color-white);
  border-radius: 8px;
  padding: 1rem;
  border: 1px solid var(--color-border);
  gap: 1rem;
}

@media (max-width: 758px) {
  .category-header {
    flex-direction: column;
    align-items: flex-start
  }

  .btn-add {
    width: 100%;
    display: flex;
    justify-content: center;
    margin-bottom: 1rem;
  }

  .input {
    padding: 0;
  }
}
</style>
