<template>
  <section class="hero">
    <div class="search-container">
      <Search @search="handleSearch" />
    </div>
  </section>
</template>

<script setup>
import Search from '@/components/ui/Search.vue'

function handleSearch({ region, name }) {
  console.log('Searching for:', name, 'in region:', region)
}
</script>

<style scoped>
.hero {
  position: relative;
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh; /* Full viewport height */
  width: 100%;
  padding: 1rem;
}

.search-container {
  width: min(90vw, 600px); /* Responsive width: 90% of viewport or 600px max */
  max-width: 600px;
  display: flex;
  justify-content: center;
  align-items: center;
}
</style>
