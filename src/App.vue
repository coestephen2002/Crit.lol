<script setup>
import { RouterLink, RouterView } from 'vue-router'
import ModalRenderer from '@/components/ui/ModalRenderer.vue'
</script>

<template>
  <div class="app">
    <RouterView />
    <ModalRenderer />
  </div>
</template>

<style scoped>
/* Ensure the app takes full height */
.app {
  height: 100vh;
  width: 100vw;
  overflow: auto;
  position: relative;
  font-family: system-ui, sans-serif;
  background-color: #000; /* Fallback color */
}
</style>
