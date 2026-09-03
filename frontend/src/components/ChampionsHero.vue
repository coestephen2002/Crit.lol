<template>
  <div class="champions-hero-container">
    <div class="champions-hero-wrapper">
      <!-- Left Grid -->
      <div class="left-grid ui-card flex flex-col p-4 border-amber-500/50" ref="leftGrid">
        <!-- Filters + Search -->
        <div class="flex items-center gap-3 mb-4">
          <SearchIcon class="text-amber-500" />
          <input
            v-model="search"
            @input="scrollToFirstMatch"
            class="flex-1 bg-[#1a1a1a] p-2 rounded text-white focus:outline-none focus:ring-2 focus:ring-amber-500"
            placeholder="Search champion..."
          />

          <!-- Tag Filter Buttons -->
          <div class="flex gap-2 ml-4">
            <button
              v-for="tag in tags"
              :key="tag"
              @click="toggleTag(tag)"
              :class="[
                'px-2 py-1 rounded-full text-sm font-medium transition',
                selectedTags.includes(tag)
                  ? 'bg-amber-500 text-black shadow-[0_0_8px_#ff6a00]'
                  : 'bg-[#1a1a1a] text-white hover:bg-amber-600'
              ]"
            >
              {{ tag }}
            </button>
          </div>
        </div>

        <!-- Champ Grid -->
        <Spinner v-if="loading"/>
        <div v-else class="grid grid-cols-8 gap-2 overflow-y-auto h-full p-1" ref="champGrid">
          <div
            v-for="champ in filteredChamps"
            :key="champ.id"
            class="relative rounded-lg overflow-hidden cursor-pointer border-2 transition-all duration-200 transform champion-card"
            :class="[
              champ.matches ? 'border-amber-500' : 'border-[#1a1a1a] opacity-40',
              selectedChampion?.id === champ.id ? 'shadow-[0_0_12px_#ff6a00]' : ''
            ]"
            @click="champ.matches && selectChampion(champ)"
          >
            <!-- Use champion.icon_url from backend instead of DDragon -->
            <img
              :src="champ.icon_url"
              :alt="champ.name"
              class="w-full h-full object-cover"
            />
          </div>
        </div>
      </div>

      <!-- Right Sidebar -->
      <div class="ui-card right-sidebar p-4 flex flex-col">
        <template v-if="selectedChampion">
          <!-- Champ Splash + Info -->
          <div class="champ-content flex-1 flex flex-col items-center mt-4">
            <img
              :key="selectedChampion.id"
              :src="`${SPLASH_URL}${selectedChampion.riot_id}_0.jpg`"
              :alt="selectedChampion.name"
              class="splash-img w-full h-64 object-cover rounded-xl border-2 border-amber-500/50 transition-opacity duration-500 opacity-0 object-top"
              :class="selectedChampion ? 'opacity-100' : 'opacity-0'"
            />
            <p class="mt-4 text-3xl fw-semibold text-amber-500 leading-tight">
              {{ selectedChampion.name }}
            </p>
            <p class="text-sm text-gray-400">{{ selectedChampion.title }}</p>
            <!-- Show tags/roles -->
            <p class="text-xs text-gray-500 mt-1">
              {{ selectedChampion.tags.join(' / ') }}
            </p>
            <div v-if="abilities.length" class="flex gap-4 mt-4 justify-center items-center flex-wrap">
              <div v-for="(ability, idx) in abilities" :key="idx" class="relative inline-block">
                <img
                  :src="ability.icon"
                  :alt="ability.name"
                  class="w-12 h-12 rounded-md border-2 border-amber-500 shadow-[0_0_10px_#ff6a00] hover:scale-110 transition-transform duration-200 cursor-pointer peer"
                />
                <div
                  class="absolute bottom-full left-1/2 -translate-x-1/2 mb-2 px-3 py-2 rounded-md bg-black/90 text-xs text-white whitespace-normal w-80 [opacity:0!important] peer-hover:[opacity:1!important] transition-opacity duration-200 z-99 pointer-events-none"
                >
                  <strong class="text-amber-400 block mb-1">{{ ability.name }}</strong>
                  <span v-html="ability.description"></span>
                </div>
              </div>
            </div>
          </div>
          <!-- Action Buttons -->
          <div class="sidebar-buttons flex flex-row align-self-center gap-4 p-3 bg-[#0f0f0f]/90 border-2 border-amber-500/50">
            <button
              v-for="(action, i) in ['Overview', 'Matchups', 'Builds', 'Skins']"
              :key="i"
              class="p-2 rounded-full bg-[#1a1a1a] hover:bg-amber-600 hover:shadow-[0_0_10px_#ff6a00] transition"
            >
              {{ action }}
            </button>
          </div>
        </template>

        <template v-else>
          <div class="flex flex-1 items-center justify-center text-gray-500">
            Select a Champion
          </div>
        </template>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, nextTick, onMounted } from 'vue'
import { useChampionStore } from '@/stores/champion'
import { SearchIcon } from 'lucide-vue-next'
import Spinner from '@/components/ui/Spinner.vue'

const SPLASH_URL =
  'https://ddragon.leagueoflegends.com/cdn/img/champion/splash/'
const tags = ['Assassin', 'Fighter', 'Mage', 'Marksman', 'Support', 'Tank']

const championStore = useChampionStore()
const champions = ref([])
const selectedChampion = ref(null)
const search = ref('')
const leftGrid = ref(null)
const champGrid = ref(null)
const loading = ref(false)
const selectedTags = ref([])
const abilities = ref([])
const PATCH = '15.16.1'

const filteredChamps = computed(() =>
  champions.value.map(champ => {
    const matchesSearch = champ.name.toLowerCase().includes(search.value.toLowerCase())
    const matchesTags =
      selectedTags.value.length === 0 ||
      selectedTags.value.every(tag => champ.tags.includes(tag))
    return { ...champ, matches: matchesSearch && matchesTags }
  })
)

const toggleTag = tag => {
  if (selectedTags.value.includes(tag)) {
    selectedTags.value = selectedTags.value.filter(t => t !== tag)
  } else {
    selectedTags.value.push(tag)
  }
}

const selectChampion = async champ => {
  selectedChampion.value = champ
  const nameKey = champ.riot_id
  try {
    const res = await fetch(
      `https://ddragon.leagueoflegends.com/cdn/${PATCH}/data/en_US/champion/${nameKey}.json`
    )
    const data = await res.json()
    const champData = data.data[nameKey]

    abilities.value = [
      {
        name: champData.passive.name || 'Passive',
        description: champData.passive.description,
        icon: `https://ddragon.leagueoflegends.com/cdn/${PATCH}/img/passive/${champData.passive.image?.full || ''}`
      },
      ...champData.spells.map(spell => ({
        name: spell.name || 'Spell',
        description: spell.description,
        icon: `https://ddragon.leagueoflegends.com/cdn/${PATCH}/img/spell/${spell.image?.full || ''}`
      }))
    ]
  } catch (err) {
    console.error('Failed to fetch champion abilities:', err)
    abilities.value = []
  }
}

// Scroll to first matching champion
const scrollToFirstMatch = () => {
  nextTick(() => {
    const firstMatch = champGrid.value.querySelector('.champion-card.border-amber-500')
    if (firstMatch) firstMatch.scrollIntoView({ behavior: 'smooth', block: 'center' })
  })
}

onMounted(async () => {
  if (!championStore.champions.length) {
    loading.value = true
    await championStore.fetchChampions()
  }
  champions.value = championStore.champions
  loading.value = false
})
</script>

<style scoped>
.champions-hero-container {
  position: relative;
  z-index: 1;
  height: 100vh;
  width: 100vw;
  display: flex;
  justify-content: center;
  align-items: center;
}

.champions-hero-wrapper {
  display: flex;
  width: 90vw;
  height: 75vh;
  overflow: visible;
  margin-top: 10vh;
  margin-left: 18vh;
  gap: 6vh;
}

.ui-card {
  background-color: rgba(12, 12, 12, 0.65);
  border: 2px solid #612d0d;
  border-radius: 12px;
  box-shadow: 0 0 10px rgba(255, 106, 0, 0.5);
}

.left-grid {
  width: 60%;
  height: 100%;
  overflow-y: auto;
  overflow-x: hidden;
  padding-bottom: 0 !important;
}

.right-sidebar {
  width: 30%;
  height: 100%;
  display: flex;
  flex-direction: column;
  overflow: visible;
}

/* Optional: keep scrollbars clean */
::-webkit-scrollbar {
  width: 6px;
}
::-webkit-scrollbar-thumb {
  background-color: rgba(255, 106, 0, 0.4);
  border-radius: 3px;
}

.champion-card {
  height: 40px;
}

/* Make hovered champion pop */
.champion-card:hover {
  transform: scale(1.05);
  z-index: 100;
}

/* Sidebar buttons inside right sidebar */
.sidebar-buttons {
  flex: 0 0 auto;
}

/* Champ splash + info content */
.champ-content {
  flex: 1;
  width: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
}
</style>
