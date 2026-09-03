import { defineStore } from 'pinia'
import api from '@/api.js'

export const useSummonerStore = defineStore('summoner', {
  state: () => ({
    loading: false,
    error: null,
    lastSlug: null,
    summoner: null,
    ranks: [],
    matches: [],
    summonerResults: [],
    championMasteries: [],
  }),

  actions: {
    async fetchSummoner(slug, region) {
      try {
        const i = slug.lastIndexOf('-')
        const name = decodeURIComponent(slug.slice(0, i)).toLowerCase()
        const tag  = decodeURIComponent(slug.slice(i+1)).toLowerCase()

        const { data } = await api.get('/api/summoners/show', {
          params: {
            search_prompt: `${name}#${tag}`,
            region: region
          }
        })

        const payload = data.response || data
        this.summoner = payload
      } catch (err) {
        console.error(err)
        this.error = err?.response?.data?.message || err.message || 'Failed to load summoner'
        this.summoner = null,
        this.ranks = []
        this.matches = []
        this.loading = false
      }

    },

    async fetchSummonerRanks(summonerId) {
      try {
        const { data } = await api.get(`/api/summoners/${summonerId}/ranks`)

        const payload = data.response || data
        this.ranks = Array.isArray(payload) ? payload : []
      } catch (err) {
        console.error(err)
        this.error = err?.response?.data?.message || err.message || 'Failed to load summoner'
        this.summoner = null,
        this.ranks = []
        this.matches = []
        this.loading = false
      }
    },

    async fetchSummonerMatches(summonerId, count) {
      try {
        const { data } = await api.get(`/api/summoners/${summonerId}/matches`, {
          params: {
            count: count
          }
        })

        const payload = data.response || data
        this.matches = Array.isArray(payload) ? payload : []
      } catch (err) {
        console.error(err)
        this.error = err?.response?.data?.message || err.message || 'Failed to load summoner'
        this.summoner = null,
        this.ranks = []
        this.matches = []
        this.loading = false
      }
    },

    async fetchChampionMasteries(summonerId) {
      try {
        const response = await api.get(`/api/summoners/${summonerId}/champion_masteries`)
        this.championMasteries = response.data.response
      } catch (err) {
        console.error(err)
        this.error = err?.response?.data?.message || err.message || 'Failed to load summoner'
        this.summoner = null,
        this.ranks = []
        this.matches = []
        this.loading = false
      }
    },

    async searchSummoners(search, region) {
      const { data } = await api.post('/api/summoners/search', { search_prompt: search, region: region })
      this.summonerResults = data.response
    },

    buildSlugFromSearch(input) {
      let [name, tag] = input.split(/\s*#\s*/, 2).map(s => (s || '').trim())
      name = name.toLowerCase().trim()
      tag = tag.toLowerCase().trim()

      return `${encodeURIComponent(name)}-${encodeURIComponent(tag)}`
    },

    clearSearchResults() {
      this.summonerResults = []
    },

    clear() {
      this.loading = false
      this.error = null
      this.summoner = null
      this.ranks = []
      this.matches = []
    }
  }
})
