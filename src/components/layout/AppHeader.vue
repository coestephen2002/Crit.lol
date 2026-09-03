<template>
  <header class="header">
    <div class="header-logo">
      <RouterLink class="flex items-center gap-2" to="/">
        <img src="../../assets/logoBig.png" width="80" height="80" alt="Logo" />
        <img src="../../assets/textBig.png" width="80" height="80" alt="Text Logo" />
      </RouterLink>
    </div>

    <Search v-if="showSearch" class="header-search"/>

    <div class="header-right-actions">
      <div v-if="accountStore.account" class="account-name">
        Logged in as: {{ accountStore.account.username }}
      </div>
      <div class="actions">
        <div class="divider"></div>
        <BaseButton v-if="accountStore.account" variant="outlined secondary" @click="logout">
          <Icon icon="right-from-bracket" class="icon" /> Log Out
        </BaseButton>
        <template v-else>
          <BaseButton variant="outlined primary" @click="showLoginModal">Log In</BaseButton>
          <BaseButton variant="outlined secondary" @click="showSignupModal">
            <Icon class="icon" icon="user" /> Sign Up
          </BaseButton>
        </template>
      </div>
      <div class="mobile-actions">
        <button class="hamburger" @click="toggleMobileMenu">
          <font-awesome-icon :icon="['fas', 'bars']" class="hamburger-icon" />
        </button>
        <div v-if="mobileMenuOpen" class="mobile-menu">
          <ul class="mobile-menu-list">
            <li v-if="accountStore.account" @click="logout">
              <font-awesome-icon :icon="['fas', 'right-from-bracket']" class="menu-icon" /> Log Out
            </li>
            <template v-else>
              <li @click="showLoginModal">Log In</li>
              <li @click="showSignupModal">
                <font-awesome-icon :icon="['fas', 'user']" class="menu-icon" /> Sign Up
              </li>
            </template>
          </ul>
        </div>
      </div>
    </div>
  </header>
</template>

<script setup>
import { RouterLink } from 'vue-router'
import BaseButton from '@/components/ui/BaseButton.vue'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import { useModalStore } from '@/stores/modal'
import { useAccountStore } from '@/stores/account'
import Search from '@/components/ui/Search.vue'
import { ref } from 'vue'

const modalStore = useModalStore()
const accountStore = useAccountStore()
const mobileMenuOpen = ref(false)

defineProps({
  showSearch: { type: Boolean, default: false }
})
const showLoginModal = () => {
  modalStore.open('LoginModal')
  mobileMenuOpen.value = false
}
const showSignupModal = () => {
  modalStore.open('SignupModal')
  mobileMenuOpen.value = false
}
const logout = () => {
  accountStore.logout()
  mobileMenuOpen.value = false
}
const toggleMobileMenu = () => {
  mobileMenuOpen.value = !mobileMenuOpen.value
}
</script>

<style lang="scss" scoped>
.header {
  position: absolute;
  top: 0;
  right: 0;
  display: flex;
  justify-content: space-between;
  align-items: center;
  width: 100%;
  padding: 1rem 2rem;
  z-index: 10;
  background-color: #0000006b;
  border-bottom: 2px solid #b1561580;
}

.header-logo {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.header-search {

}
.account-name {
  align-self: center;
  color: #f5f5f5;
  font-size: 1rem;
}

.header-right-actions {
  display: flex;
  align-items: center;
}

.actions {
  display: flex;
  align-items: center;

  > * {
    margin-left: 1rem;
  }
}

.divider {
  height: 2rem;
  width: 1px;
  background-color: #6e6e6e;
  margin-right: 1rem;
}

.icon {
  margin-right: 0.5rem;
}

.mobile-actions {
  display: none; /* Hidden by default */
}

.hamburger {
  background: transparent;
  border: none;
  padding: 0.5rem;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
}

.hamburger-icon {
  width: 1.5rem;
  height: 1.5rem;
  color: #f5f5f5; /* Matches light text from search/buttons */
}

.mobile-menu {
  position: absolute;
  top: 100%;
  right: 0;
  background: #1a1a1a; /* Matches search container background */
  border: 1px solid #b1561580; /* Matches search border */
  border-radius: 6px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.2);
  min-width: 150px;
  max-height: 200px; /* Fixed height for scrollable menu */
  overflow-y: auto; /* Enable scrolling */
  scrollbar-width: none; /* Hide scrollbar for Firefox */
  -ms-overflow-style: none; /* Hide scrollbar for IE/Edge */
  z-index: 20;

  &::-webkit-scrollbar {
    display: none; /* Hide scrollbar for Chrome/Safari */
  }
}

.mobile-menu-list {
  list-style: none;
  padding: 0.25rem 0;
  margin: 0;

  li {
    padding: 0.5rem 1rem;
    color: #f5f5f5; /* Matches search text */
    cursor: pointer;
    transition: background 0.2s ease, color 0.2s ease;
    display: flex;
    align-items: center;
    gap: 0.5rem;

    &:hover {
      background: #2a2a2a; /* Matches search dropdown hover */
      color: #ff8a3c; /* Matches search hover color */
    }
  }
}

.menu-icon {
  width: 1.25rem;
  height: 1.25rem;
  color: #f5f5f5; /* Matches button icon color */
}

/* Responsive adjustments */
@media (max-width: 768px) {
  .header {
    padding: 1rem;
  }

  .actions {
    display: none; /* Hide desktop buttons on mobile */
  }

  .mobile-actions {
    display: flex; /* Show hamburger menu */
    align-items: center;
  }

  .account-name {
    font-size: 0.9rem;
    margin-right: 1rem;
  }

  .header-logo {
    img {
      width: 60px;
      height: 60px; /* Smaller logo on mobile */
    }
  }
}

@media (max-width: 480px) {
  .header {
    padding: 0.75rem;
  }

  .account-name {
    font-size: 0.8rem;
  }

  .mobile-menu {
    max-height: 150px; /* Smaller height for mobile */
  }
}
</style>
