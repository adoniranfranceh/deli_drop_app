<template>
  <div class="dashboard-filters">
    <SearchInput class="input" />
    <div class="categories">
      <CategoryDropdown
        class="category-dropdown"
        label="Todas as categorias"
        :options="[
          { label: 'Bebidas', value: 'bebidas' },
          { label: 'Comidas', value: 'comidas' },
          { label: 'Sobremesas', value: 'sobremesas' }
        ]"
      />
      <div class="view-buttons">
        <button
          class="btn-icon"
          :class="{ active: activeView === 'grid' }"
          @click="setView('grid')"
        >
          <Icon icon="ic:round-grid-on" class="icon"/>
          <span>Grade</span>
        </button>
        <button
          class="btn-icon"
          :class="{ active: activeView === 'list' }"
          @click="setView('list')"
        >
          <Icon icon="material-symbols:list-rounded" class="icon"/>
          <span>Lista</span>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { Icon } from '@iconify/vue'
import SearchInput from '../ui/SearchInput.vue';
import CategoryDropdown from '../ui/CategoryDropdown.vue';

const emit = defineEmits(['changeView'])
const activeView = ref('grid')

function setView(view) {
  activeView.value = view
  emit('changeView', view)
}
</script>

<style scoped>
.dashboard-filters {
  display: flex;
  justify-content: space-between;
  background: var(--color-white);
  border-radius: 8px;
  padding: 1rem;
  border: 1px solid var(--color-border);
  gap: 1rem;
}

.input {
  flex: 1;
}

.categories {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.view-buttons {
  display: flex;
  gap: 0.5rem;
  justify-content: flex-end;
}

.btn-icon {
  background: var(--color-white);
  border: 1px solid var(--color-border);
  border-radius: 6px;
  padding: 0.4rem 1.2rem 0.4rem 0.7rem;
  cursor: pointer;
  color: var(--color-black);
  display: flex;

  span {
    display: none;
  }
}

.btn-icon.active {
  background: var(--color-primary);
  color: var(--color-white);
  border-color: var(--color-primary);
}

.icon {
  width: 1.3rem;
  height: 1.3rem;
}

@media (max-width: 758px) {
  .dashboard-filters {
    flex-direction: column;
    align-items: stretch;
  }

  .input {
    padding: 0;
  }

  .category-dropdown {
    padding: 0;
    width: 100%;
  }

  .btn-icon {
    width: 100%;
    justify-content: center;
    align-items: center;
    gap: 1rem;

    span {
      display: block;
    }
  }
}
</style>
