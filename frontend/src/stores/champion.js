import { defineStore } from 'pinia'
import api from '@/api.js'

export const useChampionStore = defineStore('champion', {
  state: () => ({
    champion: null,
    championResults: [],
    champions: [],
  }),

  actions: {
    async fetchChampions() {
      try {
        const { data } = await api.get('/api/champions')
        this.champions = data.response
      } catch (err) {
        console.error('Error fetching champions:', err)
      }
    },
    async fetchChampion(championId) {
      const { data } = await api.get(`/api/champions/${championId}`)
      this.champion = data.response
    },

    async searchChampions(search) {
      const { data } = await api.post('/api/champions/search', { search_prompt: search })
      this.championResults = data.response
    },

    clearSearchResults() {
      this.championResults = []
    },
  }
})
