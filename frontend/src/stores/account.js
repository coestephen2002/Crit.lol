import { defineStore } from 'pinia'
import api from '@/api.js'

export const useAccountStore = defineStore('account', {
  state: () => ({
    account: null,
    token: localStorage.getItem('token') || null,
  }),

  actions: {
    async login(credentials) {
      const { data } = await api.post('/api/accounts/login', credentials)
      this.account = data.response.account
      this.token = data.response.token
      localStorage.setItem('token', this.token)
    },

    async signup(credentials) {
      const { data } = await api.post('/api/accounts', credentials)
      this.account = data.response.account
      this.token = data.response.token
      localStorage.setItem('token', this.token)
    },

    async view(account_id) {
      try {
        const { data } = await api.get(`/api/accounts/${account_id}`)
        this.account = data.response.account
      } catch (error) {
        console.error('Failed to fetch account info:', error)
      }
    },

    async logout() {
      try {
        await api.post('/accounts/logout')
      } catch (error) {
        console.error('Backend logout failed:', error)
      } finally {
        this.account = null
        this.token = null
        localStorage.removeItem('token')
      }
    },
  }
})
