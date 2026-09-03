import { defineStore } from 'pinia'

export const useModalStore = defineStore('modal', {
  state: () => ({
    currentModal: null,
    modalProps: {}
  }),

  actions: {
    open(modalName, props = {}) {
      this.currentModal = modalName
      this.modalProps = props
    },

    close() {
      this.currentModal = null
      this.modalProps = {}
    }
  }
})
