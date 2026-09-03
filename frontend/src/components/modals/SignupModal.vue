<template>
  <BaseModal @close="$emit('close')">
    <template #title>Sign Up</template>
    <form @submit.prevent="handleSignup">
      <input v-model="username" placeholder="Username" required />
      <input v-model="password" type="password" placeholder="Password" required />
      <BaseButton type="submit">Sign Up</BaseButton>
    </form>
    <p v-if="error" class="error">{{ error }}</p>
  </BaseModal>
</template>

<script setup>
import { ref } from 'vue'
import { useAccountStore } from '@/stores/account'
import { useModalStore } from '@/stores/modal'
import BaseButton from '@/components/ui/BaseButton.vue'
import BaseModal from '@/components/modals/BaseModal.vue'

const accountStore = useAccountStore()
const modalStore = useModalStore()

const username = ref('')
const password = ref('')
const error = ref(null)

const handleSignup = async () => {
  error.value = null
  try {
    await accountStore.signup({ username: username.value, password: password.value })
    modalStore.close()
  } catch (e) {
    error.value = e.response?.data?.response?.error || 'Signup failed'
  }
}
</script>

<style scoped>
.error {
  color: red;
  margin-top: 0.5rem;
}
</style>
