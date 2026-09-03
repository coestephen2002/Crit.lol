<template>
  <div class="champions-page">
    <!-- Background -->
    <img
      src="@/assets/yasuo.jpg"
      alt=""
      class="absolute inset-0 w-full h-full object-cover filter brightness-50 contrast-110 saturate-110 blur-sm"
    />
    <div class=" overlay absolute inset-0 [background-color:oklch(0.13_0.01_0/_0.77)] pointer-events-none"/>

    <!-- Layout wrapper -->
    <AppLayout :show-search="true">
      <ChampionsHero />
    </AppLayout>
  </div>
</template>

<script setup>
import AppLayout from '@/AppLayout.vue'
import ChampionsHero from '@/components/ChampionsHero.vue'
</script>

<style scoped>
.champions-page {
  position: relative;
  height: 100vh;
  overflow: hidden;
  background: linear-gradient(180deg, #1c0f00 0%, #121212 100%);
}

.background-image {
  position: absolute;
  width: 100%;
  height: 100%;
  object-fit: cover;
  z-index: 0;
  filter: brightness(0.8) contrast(1.1) saturate(1.2);
  animation: gentle-pulse 15s ease-in-out infinite alternate;
  will-change: transform, filter;
}

@keyframes gentle-pulse {
  0% {
    transform: scale(1) translateY(0);
    filter: brightness(0.8) contrast(1.1) saturate(1.2);
  }
  100% {
    transform: scale(1.03) translateY(-5px);
    filter: brightness(0.82) contrast(1.12) saturate(1.22);
  }
}

.overlay {
  position: absolute;
  inset: 0;
  z-index: 0;
  background: linear-gradient(
    135deg,
    rgba(20, 12, 0, 0.5) 0%,
    rgba(25, 15, 0, 0.4) 50%,
    rgba(12, 12, 12, 0.6) 100%
  );
  mix-blend-mode: overlay;
  pointer-events: none;
}

.ember-glow {
  position: absolute;
  inset: 0;
  z-index: 0;
  background: radial-gradient(
    circle at 50% 30%,
    rgba(255, 100, 0, 0.2) 0%,
    transparent 60%
  );
  animation: soft-flicker 8s ease-in-out infinite;
  pointer-events: none;
}

.ember-glow::before {
  content: '';
  position: absolute;
  inset: 0;
  background: radial-gradient(
    circle at 20% 80%,
    rgba(255, 160, 0, 0.25) 0%,
    transparent 50%
  );
  animation: soft-drift 10s ease-in-out infinite;
  mix-blend-mode: screen;
}

@keyframes soft-flicker {
  0%, 100% { opacity: 0.8; transform: scale(1); }
  50% { opacity: 1; transform: scale(1.015); }
}

@keyframes soft-drift {
  0% { transform: translate(0, 0); opacity: 0.7; }
  50% { transform: translate(10px, -10px); opacity: 0.9; }
  100% { transform: translate(0, 0); opacity: 0.7; }
}
</style>
