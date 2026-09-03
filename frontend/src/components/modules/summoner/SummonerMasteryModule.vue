<template>
  <section class="lg:col-span-1 text-white">
    <div class="rounded-2xl glow-border mastery-content">
      <Spinner v-if="isLoading" class="mx-auto h-12 w-12 text-[#b15615]" />
      <div
        v-else-if="error"
        class="rounded-xl border border-slate-700/50 bg-slate-800/30 p-6 text-center text-white/70 text-sm"
      >
        {{ error }}
      </div>
      <div
        v-else-if="!championMasteries.length"
        class="rounded-xl border border-slate-700/50 bg-slate-800/30 p-6 text-center text-white/70 text-sm"
      >
        No mastery data available.
      </div>
      <div v-else class="flex flex-col gap-6">
        <!-- Mastery Overview (Top) -->
        <div>
          <h3 class="text-lg font-semibold text-white mb-3">Mastery Overview</h3>
          <div class="flex flex-wrap gap-2">
            <span
              v-for="tag in allTags"
              :key="tag.text"
              class="inline-flex items-center rounded-full px-3 py-1 text-xs font-medium transition-colors duration-200"
              :class="tag.class"
            >
              {{ tag.text }}
            </span>
            <span
              v-if="primaryTag"
              class="inline-flex items-center rounded-full px-3 py-1 text-xs font-medium bg-gray-500/20 text-amber-300 ring-1 ring-amber-400/40 hover:bg-gray-500/30 transition-colors duration-200"
            >
              {{ primaryTag }} Experienced
            </span>
          </div>
        </div>
        <!-- Champion Masteries (Side by Side) -->
        <div class="flex justify-between items-start gap-6">
          <!-- Second Highest (Left, Silver) -->
          <div v-if="championMasteries[1]" class="flex-1 group">
            <div class="flex flex-col items-center gap-2 transition-transform duration-300 group-hover:scale-105">
              <div class="relative">
                <img
                  :src="getChampionIcon(championMasteries[1].champion_id)"
                  :alt="getChampionName(championMasteries[1].champion_id)"
                  class="h-16 w-16 object-cover rounded-xl ring-1 ring-gray-300 transition-shadow duration-300 group-hover:ring-[#b15615]/50"
                />
                <span
                  class="absolute -bottom-1 -right-1 px-1.5 py-0.5 text-xs font-bold bg-black/80 text-white rounded-full"
                >
                  {{ championMasteries[1].level }}
                </span>
              </div>
              <h4 class="text-base font-semibold text-white">
                {{ getChampionName(championMasteries[1].champion_id) }}
              </h4>
              <p class="text-sm font-medium text-[#b15615]">
                {{ formatPoints(championMasteries[1].points) }} Points
              </p>
            </div>
          </div>
          <!-- Highest (Center, Gold, Best Champion) -->
          <div v-if="championMasteries[0]" class="flex-1 group">
            <div class="flex flex-col items-center gap-3 transition-transform duration-300 group-hover:scale-105">
              <div class="relative">
                <img
                  :src="getChampionIcon(championMasteries[0].champion_id)"
                  :alt="getChampionName(championMasteries[0].champion_id)"
                  class="h-20 w-20 object-cover rounded-xl ring-2 ring-amber-400 shadow-[0_0_15px_rgba(255,165,0,0.5)] transition-shadow duration-300 group-hover:shadow-[0_0_20px_rgba(255,165,0,0.7)]"
                />
                <span
                  class="absolute -bottom-1 -right-1 px-2 py-0.5 text-sm font-bold bg-amber-400 text-black rounded-full"
                >
                  {{ championMasteries[0].level }}
                </span>
              </div>
              <h4 class="text-xl font-bold text-amber-400">
                {{ getChampionName(championMasteries[0].champion_id) }}
              </h4>
              <p class="text-base font-semibold text-[#b15615]">
                {{ formatPoints(championMasteries[0].points) }} Points
              </p>
            </div>
          </div>
          <!-- Third Highest (Right, Bronze) -->
          <div v-if="championMasteries[2]" class="flex-1 group">
            <div class="flex flex-col items-center gap-2 transition-transform duration-300 group-hover:scale-105">
              <div class="relative">
                <img
                  :src="getChampionIcon(championMasteries[2].champion_id)"
                  :alt="getChampionName(championMasteries[2].champion_id)"
                  class="h-16 w-16 object-cover rounded-xl ring-1 ring-orange-600 transition-shadow duration-300 group-hover:ring-[#b15615]/50"
                />
                <span
                  class="absolute -bottom-1 -right-1 px-1.5 py-0.5 text-xs font-bold bg-black/80 text-white rounded-full"
                >
                  {{ championMasteries[2].level }}
                </span>
              </div>
              <h4 class="text-base font-semibold text-white">
                {{ getChampionName(championMasteries[2].champion_id) }}
              </h4>
              <p class="text-sm font-medium text-[#b15615]">
                {{ formatPoints(championMasteries[2].points) }} Points
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue';
import { useSummonerStore } from '@/stores/summoner';
import { useChampionStore } from '@/stores/champion';
import Spinner from '@/components/ui/Spinner.vue';

// Access stores
const summonerStore = useSummonerStore();
const championsStore = useChampionStore();

// Reactive loading and error states
const isLoading = ref(true);
const error = ref(null);

onMounted(async () => {
  isLoading.value = true;
  error.value = null;
  try {
    if (!championsStore.champions.length) {
      await championsStore.fetchChampions();
    }
  } catch (err) {
    error.value = 'Failed to load champions';
    console.error('Error fetching champions:', err);
  } finally {
    isLoading.value = false;
  }
});

// Sort masteries by points and reorder: [highest, second, third]
const championMasteries = computed(() => {
  const masteries = summonerStore.championMasteries || [];
  const sorted = [...masteries]
    .sort((a, b) => b.points - a.points)
    .slice(0, 3);
  return [sorted[0] || null, sorted[1] || null, sorted[2] || null];
});

// Helper functions to get champion details
const getChampion = (championId) => {
  return championsStore.champions.find((champ) => champ.id === championId) || {};
};

const getChampionName = (championId) => {
  return getChampion(championId).name || 'Unknown Champion';
};

const getChampionIcon = (championId) => {
  return getChampion(championId).icon_url || '';
};

// Format mastery points with commas
const formatPoints = (points) => {
  return points != null ? points.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',') : '0';
};

// Generate mastery level tags with ember-themed colors
const getMasteryLevelTag = (points, championName) => {
  if (points >= 2000000)
    return {
      text: `Eternal ${championName}`,
      class: 'bg-gradient-to-r from-amber-600/40 to-yellow-400/30 text-yellow-100 ring-2 ring-amber-400/60 shadow-lg shadow-amber-600/30 hover:from-amber-500/50 hover:to-yellow-300/40'
    }
  if (points >= 1000000)
    return {
      text: `Iconic ${championName}`,
      class: 'bg-gradient-to-r from-amber-700/40 to-orange-500/30 text-amber-100 ring-2 ring-amber-500/50 shadow-md shadow-amber-700/30 hover:from-amber-600/50 hover:to-orange-400/40'
    }
  if (points >= 500000)
    return {
      text: `Legend ${championName}`,
      class: 'bg-amber-800/40 text-amber-200 ring-1 ring-amber-600/50 shadow shadow-amber-800/30 hover:bg-amber-700/50'
    }
  if (points >= 400000)
    return {
      text: `Fabled ${championName}`,
      class: 'bg-orange-800/40 text-orange-200 ring-1 ring-orange-600/50 shadow hover:bg-orange-700/50'
    }
  if (points >= 350000)
    return {
      text: `Renowned ${championName}`,
      class: 'bg-amber-900/40 text-amber-300 ring-1 ring-amber-700/40 hover:bg-amber-800/50'
    }
  if (points >= 300000)
    return {
      text: `Master ${championName}`,
      class: 'bg-orange-900/40 text-orange-300 ring-1 ring-orange-700/40 hover:bg-orange-800/50'
    }
  if (points >= 250000)
    return {
      text: `Expert ${championName}`,
      class: 'bg-gradient-to-r from-orange-950/40 to-amber-900/30 text-orange-200 ring-1 ring-orange-800/50 hover:from-orange-900/50 hover:to-amber-800/40'
    }
  if (points >= 200000)
    return {
      text: `Battle-Tested ${championName}`,
      class: 'bg-amber-950/40 text-amber-400 ring-1 ring-amber-800/40 hover:bg-amber-900/50'
    }
  if (points >= 150000)
    return {
      text: `Proficient ${championName}`,
      class: 'bg-orange-950/40 text-orange-400 ring-1 ring-orange-800/40 hover:bg-orange-900/50'
    }
  if (points >= 75000)
    return {
      text: `Competent ${championName}`,
      class: 'bg-stone-900/50 text-amber-500 ring-1 ring-stone-700/40 hover:bg-stone-800/60'
    }
  if (points >= 50000)
    return {
      text: `Novice ${championName}`,
      class: 'bg-stone-950/50 text-orange-400 ring-1 ring-stone-800/40 hover:bg-stone-900/60'
    }
  return {
    text: `Beginner ${championName}`,
    class: 'bg-slate-900/50 text-slate-400 ring-1 ring-slate-700/40 hover:bg-slate-800/60'
  }
};

// Generate mastery tags for each champion
const masteryTags = computed(() => {
  return championMasteries.value
    .filter(mastery => mastery)
    .map(mastery => getMasteryLevelTag(mastery.points, getChampionName(mastery.champion_id)));
});

// One-Trick Detection (Performance Insight Tag)
const oneTrickTag = computed(() => {
  const masteries = championMasteries.value.filter(m => m);
  if (masteries.length < 2) return null; // Need at least 2 for comparison

  const totalPoints = masteries.reduce((sum, m) => sum + m.points, 0);
  const bestPoints = masteries[0].points;
  const secondPoints = masteries[1].points;

  const majorityCheck = bestPoints > (totalPoints / 2);
  const gapCheck = bestPoints > (secondPoints * 2);

  if (majorityCheck || gapCheck) {
    const bestChamp = getChampionName(masteries[0].champion_id);
    return {
      text: `One-Trick ${bestChamp}`,
      class: 'bg-amber-900/40 text-amber-200 ring-1 ring-amber-400/50 hover:bg-amber-900/50'
    };
  }
  return null;
});

// Primary Tag (most frequent champion tag, e.g., "Fighter")
const primaryTag = computed(() => {
  const tags = championMasteries.value
    .filter(mastery => mastery)
    .flatMap(mastery => getChampion(mastery.champion_id).tags || []);
  if (!tags.length) return null;
  const tagCounts = tags.reduce((acc, tag) => {
    acc[tag] = (acc[tag] || 0) + 1;
    return acc;
  }, {});
  return Object.entries(tagCounts).reduce((a, b) => (b[1] > a[1] ? b : a))[0];
});

// Combined Tags (mastery + one-trick)
const allTags = computed(() => {
  let tags = [...masteryTags.value];
  if (oneTrickTag.value) tags.push(oneTrickTag.value);
  return tags;
});
</script>

<script>
export default { name: 'SummonerMasteryModule' };
</script>

<style scoped>
.glow-border {
  border: 2px solid #b1561580;
  border-radius: 16px;
  box-shadow: 0 0 20px rgba(255, 106, 0, 0.1);
  background: linear-gradient(180deg, rgba(20, 20, 20, 0.95) 0%, rgba(10, 10, 10, 0.98) 100%);
  backdrop-filter: blur(4px);
}

.mastery-content {
  padding: 20px !important;
}
</style>
