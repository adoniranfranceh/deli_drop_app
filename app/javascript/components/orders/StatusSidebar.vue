<template>
  <div class="status-sidebar">
    <div class="status-sidebar__desktop">
      <div class="status-sidebar__header">
        <Icon icon="tabler:filter" width="16" height="16" />
        <span>Filtrar pedidos</span>
      </div>

      <div class="status-sidebar__list">
        <div
          v-for="tab in tabs"
          :key="tab.key"
          class="status-sidebar__item"
          :class="{ 'status-sidebar__item--active': modelValue === tab.key }"
          @click="$emit('update:modelValue', tab.key)"
        >
          <Icon :icon="tab.icon" width="18" height="18" class="status-sidebar__icon" />
          <span class="status-sidebar__label">{{ tab.label }}</span>
          <span
            v-if="tab.key === 'pending' && pendingCount > 0"
            class="status-sidebar__badge"
          >
            {{ pendingCount }}
          </span>
        </div>
      </div>
    </div>

    <div class="status-sidebar__mobile">
      <div
        v-for="tab in tabs"
        :key="tab.key"
        class="status-sidebar__pill"
        :class="{ 'status-sidebar__pill--active': modelValue === tab.key }"
        @click="$emit('update:modelValue', tab.key)"
      >
        <Icon :icon="tab.icon" width="16" height="16" />
        <span>{{ tab.label }}</span>
        <span
          v-if="tab.key === 'pending' && pendingCount > 0"
          class="status-sidebar__pill-badge"
          :class="{ 'status-sidebar__pill-badge--active': modelValue === tab.key }"
        >
          {{ pendingCount }}
        </span>
      </div>
    </div>
  </div>
</template>

<script setup>
import { Icon } from '@iconify/vue'

defineProps({
  tabs: {
    type: Array,
    required: true,
  },
  modelValue: {
    type: String,
    default: 'all',
  },
  pendingCount: {
    type: Number,
    default: 0,
  },
})

defineEmits(['update:modelValue'])
</script>

<style scoped>
.status-sidebar {
  flex-shrink: 0;
}

/* ── Desktop ── */
.status-sidebar__desktop {
  display: flex;
  flex-direction: column;
  width: 230px;
  background: #ffffff;
  border-right: 1px solid var(--color-border);
  padding: 1.25rem 0;
  height: 100%;
}

.status-sidebar__header {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0 1.25rem 0.875rem;
  font-size: 0.75rem;
  font-weight: 600;
  color: var(--color-muted);
  text-transform: uppercase;
  letter-spacing: 0.05em;
  border-bottom: 1px solid var(--color-border);
  margin-bottom: 0.5rem;
}

.status-sidebar__list {
  display: flex;
  flex-direction: column;
  padding: 0.25rem 0.5rem;
  gap: 2px;
}

.status-sidebar__item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.625rem 0.875rem;
  border-radius: 0.5rem;
  font-size: 0.875rem;
  font-weight: 500;
  color: var(--color-muted);
  cursor: pointer;
  transition: background-color 0.15s, color 0.15s;
  user-select: none;
}

.status-sidebar__item:hover {
  background-color: var(--color-background);
  color: var(--color-text);
}

.status-sidebar__item--active {
  background-color: var(--color-background);
  color: var(--color-text);
  font-weight: 600;
}

.status-sidebar__icon {
  flex-shrink: 0;
  color: inherit;
}

.status-sidebar__item--active .status-sidebar__icon {
  color: var(--color-primary);
}

.status-sidebar__label {
  flex: 1;
  min-width: 0;
}

.status-sidebar__badge {
  margin-left: auto;
  min-width: 20px;
  height: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0 6px;
  border-radius: 9999px;
  font-size: 0.6875rem;
  font-weight: 700;
  background-color: var(--color-primary);
  color: #ffffff;
  line-height: 1;
}

/* ── Mobile ── */
.status-sidebar__mobile {
  display: none;
}

@media (max-width: 758px) {
  .status-sidebar {
    width: 100%;
  }

  .status-sidebar__desktop {
    display: none;
  }

  .status-sidebar__mobile {
    display: flex;
    gap: 0.5rem;
    padding: 0.75rem 1rem;
    overflow-x: auto;
    border-bottom: 1px solid var(--color-border);
    background: #ffffff;
    -webkit-overflow-scrolling: touch;
  }

  .status-sidebar__mobile::-webkit-scrollbar {
    display: none;
  }

  .status-sidebar__pill {
    display: flex;
    align-items: center;
    gap: 0.375rem;
    flex-shrink: 0;
    white-space: nowrap;
    padding: 0.5rem 0.875rem;
    border-radius: 9999px;
    font-size: 0.8125rem;
    font-weight: 500;
    color: var(--color-muted);
    background: #ffffff;
    border: 1px solid var(--color-border);
    cursor: pointer;
    transition: all 0.15s;
    user-select: none;
  }

  .status-sidebar__pill:hover {
    background-color: var(--color-background);
    border-color: var(--color-border);
  }

  .status-sidebar__pill--active {
    background-color: var(--color-primary);
    color: #ffffff;
    border-color: var(--color-primary);
    font-weight: 600;
  }

  .status-sidebar__pill--active:hover {
    background-color: var(--color-primary-hover);
    border-color: var(--color-primary-hover);
  }

  .status-sidebar__pill-badge {
    min-width: 18px;
    height: 18px;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 0 4px;
    border-radius: 9999px;
    font-size: 0.625rem;
    font-weight: 700;
    background-color: var(--color-primary);
    color: #ffffff;
    line-height: 1;
  }

  .status-sidebar__pill-badge--active {
    background-color: #ffffff;
    color: var(--color-primary);
  }
}
</style>
