<template>
  <div class="!pt-32">
    <div v-if="loading" class="loading">
      <Spinner />
    </div>
    <div v-else-if="summoner" class="mx-auto py-4 max-w-7xl min-h-screen">
      <SummonerHeaderModule :summoner="summoner" />
      <div class="mt-4 grid grid-cols-1 gap-6 lg:grid-cols-3">
        <!-- Left side: mastery + ranks stacked -->
        <div class="space-y-6 lg:col-span-1">
          <SummonerMasteryModule />
          <SummonerRanksModule :ranks="ranks" />
        </div>

        <!-- Right side: matches -->
        <div class="lg:col-span-2">
          <SummonerMatchesModule :matches="matches" :summoner="summoner" />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { onMounted, watch, computed } from 'vue'
import { useRoute } from 'vue-router'
import { storeToRefs } from 'pinia'
import { useSummonerStore } from '@/stores/summoner'
import Spinner from '@/components/ui/Spinner.vue'
import SummonerHeaderModule from '@/components/modules/summoner/SummonerHeaderModule.vue'
import SummonerRanksModule from '@/components/modules/summoner/SummonerRanksModule.vue'
import SummonerMatchesModule from '@/components/modules/summoner/SummonerMatchesModule.vue'
import SummonerMasteryModule from '@/components/modules/summoner/SummonerMasteryModule.vue'

const route = useRoute()
const summonerStore = useSummonerStore()
const { summoner, ranks, matches, loading } = storeToRefs(summonerStore)

const slug = computed(() => route.params.slug)
const region = computed(() => route.params.region || null)

async function load() {
  loading.value = true
  await summonerStore.fetchSummoner(slug.value, region.value)

  if (summonerStore.summoner?.id) {
    // Always fetch fresh data for new summoner
    await Promise.all([
      summonerStore.fetchSummonerRanks(summonerStore.summoner.id),
      summonerStore.fetchSummonerMatches(summonerStore.summoner.id, 10),
      summonerStore.fetchChampionMasteries(summonerStore.summoner.id)
    ])
  }

  loading.value = false
}

onMounted(load)
watch([slug, region], () => {
  load()
})
</script>

<script>
export default { name: 'SummonerHero' }
</script>

<style scoped>
.glow-border {
  border: 2px solid #b1561580;
  border-radius: 12px;
  overflow: visible;
  box-shadow: 0 0 20px rgba(255, 106, 0, .1);
}
</style>
