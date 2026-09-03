<script setup>
import { computed, defineAsyncComponent } from 'vue'
import { useModalStore } from '@/stores/modal'

const modalStore = useModalStore()

const modalComponents = {
  LoginModal: defineAsyncComponent(() => import('@/components/modals/LoginModal.vue')),
  SignupModal: defineAsyncComponent(() => import('@/components/modals/SignupModal.vue')),
}

const currentModal = computed(() => modalStore.currentModal)
const modalProps = computed(() => modalStore.modalProps)
const ModalComponent = computed(() => currentModal.value ? modalComponents[currentModal.value] : null)
</script>

<template>
  <component
    v-if="ModalComponent"
    :is="ModalComponent"
    v-bind="modalProps"
    @close="modalStore.close"
  />
</template>
