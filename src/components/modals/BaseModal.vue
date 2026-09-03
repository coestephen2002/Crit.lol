<!-- src/components/ui/BaseModal.vue -->
<template>
  <div class="modal-overlay" @click.self="close">
    <div class="modal">
      <header class="modal-header">
        <h2 class="modal-title">
          <slot name="title">Modal Title</slot>
        </h2>
        <button class="modal-close" @click="close">
          <Icon icon="xmark" />
        </button>
      </header>

      <section class="modal-body">
        <slot />
      </section>

      <footer class="modal-footer">
        <slot name="footer" />
      </footer>
    </div>
  </div>
</template>

<script setup>
import Icon from '@/components/ui/Icon.vue'

const emit = defineEmits(['close'])

const close = () => {
  emit('close')
}
</script>

<style scoped lang="scss">
.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.6);
  z-index: 1000;
  display: flex;
  align-items: center;
  justify-content: center;
}

.modal {
  display: block;
  position: relative;
  background: #111;
  border: 2px solid #1d4ed8;
  border-radius: 0.5rem;
  padding: 2rem;
  width: 100%;
  height: 50%;
  max-width: 500px;
  min-height: 100px;
  color: white;
  box-shadow: 0 0 20px rgba(0, 0, 0, 0.5);
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.modal-title {
  font-size: 1.25rem;
  font-weight: bold;
}

.modal-close {
  background: none;
  border: none;
  color: white;
  font-size: 1.2rem;
  cursor: pointer;
}

.modal-body {
  margin-top: 1rem;
}

.modal-footer {
  margin-top: 2rem;
  text-align: right;
}
</style>
