<template>
  <button :class="['base-button', variant]" v-bind="$attrs">
    <slot />
  </button>
</template>

<script setup>
defineProps({
  variant: {
    type: String,
    default: 'primary',
  }
})
</script>

<style lang="scss" scoped>
.base-button {
  padding: 0.5rem 1.25rem;
  border-radius: 6px;
  font-size: 1rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
  border: none;

  &.primary {
    background-color: #b15615;
    color: #f5f5f5;

    &:hover {
      background-color: #ff8a3c;
    }
  }

  &.secondary {
    background-color: #2a2a2a;
    color: #f5f5f5;
    border: 1px solid #b1561580;

    &:hover {
      background-color: #3a3a3a;
      border-color: #ff8a3c;
    }
  }

  &.outlined {
    background: transparent;

    &.primary {
      background-color: #1a1a1a;
      color: #f5f5f5;
      border: 1px solid #b1561580;

      &:hover {
        background-color: #2a2a2a;
        border-color: #ff8a3c;
      }
    }

    &.secondary {
      background-color: transparent;
      color: #f5f5f5;
      border: 1px solid #b1561580;
      &:hover {
        background-color: #1a1a1a;
        border-color: #ff8a3c;
      }
    }
  }
}
</style>
