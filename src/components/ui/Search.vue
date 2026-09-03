<template>
  <div class="search-container">
    <!-- Region Selector -->
    <div class="region-selector" @click="toggleDropdown">
      <span>{{ selectedRegion.display }}</span>
      <svg class="chevron" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" d="M19 9l-7 7-7-7" />
      </svg>
      <div v-if="dropdownOpen" class="region-slider">
        <ul class="region-list">
          <li
            v-for="region in regions"
            :key="region.value"
            @click.stop="selectRegion(region)"
          >
            {{ region.display }}
          </li>
        </ul>
      </div>
    </div>

    <!-- Search Input -->
    <div class="search-input-wrapper">
      <input
        type="text"
        v-model="searchTerm"
        placeholder="Search for a Summoner..."
        @keyup.enter="handleSearch"
      />
      <button class="search-button" @click="handleSearch">
        <Icon icon="magnifying-glass" class="icon" />
      </button>
    </div>

    <!-- Search Results -->
    <ul v-if="combinedResults.length || loading" class="search-results">
      <li v-if="loading">
        <Spinner/>
      </li>
      <li
        v-else
        v-for="result in combinedResults"
        :key="`${result.type}-${result.id}`"
        @click="result.type === 'summoner' ? selectSummoner(result) : selectChampion(result)"
        class="search-result-item"
      >
        <img
          v-if="result.type === 'summoner'"
          :src="`https://ddragon.leagueoflegends.com/cdn/15.16.1/img/profileicon/${result.profile_icon_id}.png`"
          alt="Icon"
          class="summoner-icon"
        />
        <img
          v-else
          :src="result.icon_url"
          alt="Icon"
          class="summoner-icon"
        />

        <span>
        {{ result.name }}
        <small v-if="result.type === 'summoner'">#{{ result.tag }}</small>
      </span>
        <small v-if="result.type === 'summoner'" class="region">{{ result.region }}</small>
      </li>
    </ul>
  </div>
</template>

<script setup>
import { computed, ref, watch } from 'vue'
import { useRouter } from 'vue-router'
import { useSummonerStore } from '@/stores/summoner'
import { useChampionStore } from '@/stores/champion'
import Spinner from '@/components/ui/Spinner.vue'

const summonerStore = useSummonerStore()
const championStore = useChampionStore()

const router = useRouter()

const searchTerm = ref('')
const dropdownOpen = ref(false)
const typingTimeout = ref(null)
const loading = ref(false)

const regions = [
  { display: 'NA', value: 'na1' },
  { display: 'EUW', value: 'euw1' },
  { display: 'EUNE', value: 'eun1' },
  { display: 'KR', value: 'kr' },
  { display: 'OCE', value: 'oc1' },
  { display: 'BR', value: 'br1' },
  { display: 'LAN', value: 'la1' },
  { display: 'LAS', value: 'la2' },
  { display: 'RU', value: 'ru' },
  { display: 'TR', value: 'tr1' },
  { display: 'JP', value: 'jp1' },
  { display: 'ME', value: 'me1' }
]

const selectedRegion = ref(regions[0])

function toggleDropdown() {
  dropdownOpen.value = !dropdownOpen.value
}

function selectRegion(region) {
  selectedRegion.value = region
  dropdownOpen.value = false
}

const combinedResults = computed(() => {
  const allResults = [
    ...championStore.championResults.map(c => ({
      ...c,
      type: 'champion',
      matchType: c.name.startsWith(searchTerm.value.toLowerCase()) ? 'exact' : 'fuzzy'
    })),
    ...summonerStore.summonerResults.map(s => ({
      ...s,
      type: 'summoner',
      matchType: s.name.startsWith(searchTerm.value.toLowerCase()) ? 'exact' : 'fuzzy'
    }))
  ]

  return allResults.sort((a, b) => {
    if (a.matchType === b.matchType) {
      return a.type === b.type ? 0 : a.type === 'champion' ? -1 : 1
    }
    return a.matchType === 'exact' ? -1 : 1
  })
})

watch(searchTerm, (newVal) => {
  if (typingTimeout.value) clearTimeout(typingTimeout.value)

  if (newVal.length < 2) {
    summonerStore.summonerResults = []
    championStore.championResults = []
    return
  }

  typingTimeout.value = setTimeout(async () => {
    loading.value = true
    await summonerStore.searchSummoners(newVal, selectedRegion.value.value)
    await championStore.searchChampions(newVal)
    loading.value = false
  }, 300)
})

watch(selectedRegion, async (newVal) => {
  if (!searchTerm.value.trim()) return
  summonerStore.summonerResults = []

  loading.value = true
  await summonerStore.searchSummoners(searchTerm.value.trim(), selectedRegion.value.value)
  loading.value = false
})

async function handleSearch() {
  const term = searchTerm.value.trim()
  if (!term) return

  if (term.includes('#')) {
    const slug = summonerStore.buildSlugFromSearch(term)
    router.push( { name: 'summoner', params: { slug: slug, region: selectedRegion.value.value } } )
  }

  /*if (term.includes('#')) {
    await summonerStore.fetchSummoner(term, selectedRegion.value.value)
    return
  }*/

  const exactChampion = championStore.championResults.find(
    champ => champ.name.toLowerCase() === term.toLowerCase()
  )
  if (exactChampion) {
    await championStore.fetchChampion(exactChampion.id)
    return
  }

  //await summonerStore.fetchSummoner(term, selectedRegion.value.value)
}

async function selectSummoner(summoner) {
  const slug = summonerStore.buildSlugFromSearch(`${summoner.name}#${summoner.tag}`)
  summonerStore.clear()
  summonerStore.clearSearchResults()
  championStore.clearSearchResults()
  router.push( { name: 'summoner', params: { slug: slug, region: selectedRegion.value.value } } )
}

async function selectChampion(champion) {
  await championStore.fetchChampion(champion.id)
}
</script>

<style lang="scss" scoped>
.search-container {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  background: #1a1a1a;
  padding: 0.5rem;
  border-radius: 8px;
  width: 100%;
  max-width: 600px;
  box-sizing: border-box;
  position: relative;
}

.region-selector {
  position: relative;
  padding: 0.5rem 1rem;
  background: #1a1a1a;
  border: 1px solid #b1561580;
  border-radius: 6px;
  color: #f5f5f5;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  cursor: pointer;
  font-weight: 500;
  min-width: 80px;
  transition: border-color 0.3s ease;

  .chevron {
    width: 1rem;
    height: 1rem;
    color: #b15615;
    transition: transform 0.2s ease;
    flex-shrink: 0;
  }

  &[aria-expanded="true"] .chevron {
    transform: rotate(180deg);
  }
}

.region-selector:hover {
  border-color: #b15615;
}

.region-slider {
  z-index: 999;
  position: absolute;
  top: 100%;
  left: 0;
  background: #1f1f1f;
  border: 1px solid #b1561580;
  border-radius: 6px;
  margin: 0.25rem 0 0;
  min-width: 100%;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.2);
  max-height: 200px; /* Fixed height for slider */
  overflow-y: auto; /* Enable vertical scrolling */
  scrollbar-width: none; /* Hide scrollbar for Firefox */
  -ms-overflow-style: none; /* Hide scrollbar for IE/Edge */

  &::-webkit-scrollbar {
    display: none; /* Hide scrollbar for Chrome/Safari */
  }
}

.region-list {
  list-style: none;
  padding: 0.25rem 0;
  margin: 0;

  li {
    padding: 0.5rem 1rem;
    color: #f5f5f5;
    cursor: pointer;
    transition: background 0.2s ease, color 0.2s ease;

    &:hover {
      background: #2a2a2a;
      color: #ff8a3c;
    }
  }
}

.search-input-wrapper {
  flex: 1;
  display: flex;
  align-items: center;
  background: #1a1a1a;
  border: 1px solid #333;
  border-radius: 6px;
  overflow: hidden;

  input {
    flex: 1;
    background: transparent;
    border: none;
    padding: 0.5rem 0.75rem;
    color: #fff;
    font-size: 1rem;
    min-width: 0;

    &::placeholder {
      color: #777;
    }

    &:focus {
      outline: none;
      border-color: #b15615;
    }
  }

  .search-button {
    background: #b15615;
    border: none;
    padding: 0.5rem 1rem;
    align-items: center;
    cursor: pointer;
    transition: background 0.3s ease;
    flex-shrink: 0;

    &:hover {
      background: #ff8a3c;
    }

    .icon {
      color: #fff;
    }
  }
}

.search-results {
  position: absolute;
  top: 100%;
  left: 0;
  width: 100%;
  background: #1e1e1e;
  margin-top: 0.25rem;
  padding: 0;
  list-style: none;
  border-radius: 6px;
  overflow: hidden;
  z-index: 20;
}

.search-result-item {
  display: flex;
  align-items: center;
  padding: 0.5rem;
  cursor: pointer;
}

.search-result-item:hover {
  background: #2a2a2a;
}

.summoner-icon {
  width: 24px;
  height: 24px;
  border-radius: 4px;
  margin-right: 0.5rem;
}

.region {
  margin-left: auto;
  color: #aaa;
  font-size: 0.75rem;
}

/* Responsive adjustments */
@media (max-width: 768px) {
  .search-container {
    gap: 0.3rem;
    padding: 0.4rem;
  }

  .region-selector {
    padding: 0.4rem 0.75rem;
    min-width: 70px;
    font-size: 0.9rem;

    .chevron {
      width: 0.9rem;
      height: 0.9rem;
    }
  }

  .region-slider {
    max-height: 150px; /* Smaller height for tablet screens */
  }

  .search-input-wrapper {
    input {
      padding: 0.4rem 0.6rem;
      font-size: 0.9rem;
    }

    .search-button {
      padding: 0.4rem;
      width: 36px;
    }

    .icon {
      width: 1.1rem;
      height: 1.1rem;
    }
  }
}

@media (max-width: 480px) {
  .search-container {
    flex-direction: column;
    align-items: stretch;
    gap: 0.5rem;
  }

  .region-selector {
    min-width: 100%;
    justify-content: space-between;
  }

  .region-slider {
    max-height: 120px; /* Smaller height for mobile screens */
  }

  .search-input-wrapper {
    width: 100%;
  }
}
</style>
