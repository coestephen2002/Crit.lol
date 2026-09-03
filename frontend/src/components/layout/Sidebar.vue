<template>
  <aside
    class="sidebar"
    :class="{ expanded: isHovered }"
    @mouseenter="isHovered = true"
    @mouseleave="isHovered = false"
  >
    <ul class="menu-list">
      <li
        v-for="item in menuItems"
        :key="item.label"
        class="menu-item"
        @click="selectItem(item)"
      >
        <component :is="item.icon" class="menu-icon" />
        <span class="menu-label">{{ item.label }}</span>
      </li>
    </ul>
  </aside>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'

import Example1 from '@/assets/icons/Example1.vue'
import Example2 from '@/assets/icons/Example2.vue'
import Example3 from '@/assets/icons/Example3.vue'
import Example4 from '@/assets/icons/Example4.vue'
import Example5 from '@/assets/icons/Example5.vue'

const isHovered = ref(false)
const router = useRouter()

// Each item references the imported SVG component
const menuItems = [
  { label: 'Tier List', icon: Example1, route: '/tier-list' },
  { label: 'Leaderboard', icon: Example2, route: '/leaderboard' },
  { label: 'Champions', icon: Example3, route: '/champions' },
  { label: 'Skins', icon: Example4, route: '/skins' },
  { label: 'Matchups', icon: Example5, route: '/matchups' },
]

function selectItem(item) {
  if (item.route) {
    router.push(item.route)
  }
}
</script>

<style scoped lang="scss">
.sidebar {
  position: fixed;
  top: 50%;
  left: 0;
  transform: translateY(-50%);
  background-color: rgba(0, 0, 0, 0.4196078431);
  border-left: 2px solid #b15615;
  border-radius: 0 12px 12px 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 0.75rem 0;
  transition: width 0.3s ease, box-shadow 0.3s ease;
  width: 60px;
  z-index: 1000;
  box-shadow: 2px 2px 12px rgba(0, 0, 0, 0.3);

  &.expanded {
    width: 180px;
    box-shadow: 4px 4px 20px rgba(0, 0, 0, 0.4);
  }
}

.menu-list {
  list-style: none;
  padding: 0;
  margin: auto 0;
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
  align-items: center;
}

.menu-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  color: #e1701d;
  cursor: pointer;
  position: relative;
  transition: transform 0.2s ease, color 0.2s ease, filter 0.2s ease;

  &:hover {
    transform: scale(1.15);
    color: #ff9e5a;
    filter: drop-shadow(0 0 8px rgba(255, 138, 60, 0.8));
  }

  .menu-icon {
    stroke-width: 1.25;
    width: 30px;
    height: 30px;
    transition: transform 0.2s ease;
  }

  &:hover .menu-icon {
    transform: scale(1.1);
  }

  .menu-label {
    font-size: 0.8rem;
    margin-top: 0.25rem;
    white-space: nowrap;
    opacity: 0;
    transition: opacity 0.3s ease, transform 0.3s ease;
    transform: translateX(-10px);
    color: #ff7b33;
    font-weight: 500;
  }
}

.sidebar.expanded .menu-item .menu-label {
  opacity: 1;
  transform: translateX(0);
}
</style>
