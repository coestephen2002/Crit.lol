<template>
  <div class="app-layout flex h-screen">
    <Sidebar />
    <div class="flex-1 flex flex-col">
      <AppHeader :show-search="showSearch"/>
      <main class="flex-1 overflow-auto">
        <slot /> <!-- Page-specific content goes here -->
      </main>
    </div>
  </div>
</template>

<script setup>
import AppHeader from '@/components/layout/AppHeader.vue'
import Sidebar from '@/components/layout/Sidebar.vue'

defineProps({
  showSearch: { type: Boolean, default: false }
})
</script>

<style scoped>
/* Layout styling if needed */
</style>
