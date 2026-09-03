<template>
  <section class="lg:col-span-1 text-white">
    <div class="space-y-3">
      <div v-for="(r, i) in ranks" :key="i" class="rounded-2xl glow-border p-4">
        <h4 class="mb-2 text-sm font-semibold uppercase tracking-wide">{{ r.queue_type }}</h4>
        <div class="flex items-start justify-between gap-3">
          <div>
            <div
              class="mt-1 inline-flex items-center gap-1 rounded-full text-white bg-gradient-to-br px-3 py-1 text-sm font-semibold mt-3"
              :class="tierColor(r.tier)"
            >
              <span>{{ r.tier }}</span>
              <span v-if="r.division" class="opacity-90">{{ r.division }}</span>
            </div>
          </div>
          <div class="flex gap-6 text-center">
            <div>
              <div class="text-sm text-white/70">LP</div>
              <div class="text-lg font-semibold">{{ r.league_points }}</div>
            </div>
            <div>
              <div class="text-sm text-white/70">W/L</div>
              <div class="text-lg font-semibold">{{ r.wins }}/{{ r.losses }}</div>
            </div>
            <div>
              <div class="text-sm text-white/70">WR</div>
              <div class="text-lg font-semibold">{{ winrate(r.wins, r.losses) }}%</div>
            </div>
          </div>
        </div>
      </div>
      <div v-if="!ranks || !ranks.length" class="rounded-2xl border border-slate-200 shadow-sm p-6 text-center text-white/80">No ranked data.</div>
    </div>
  </section>
</template>

<script setup>
import { tierColor, winrate } from '@/summonerUtils'

defineProps({
  ranks: {
    type: Array,
    default: () => [],
  },
})
</script>

<script>
export default { name: 'SummonerRanksModule' }
</script>

<style scoped>
.glow-border {
  border: 2px solid #b1561580;
  border-radius: 12px;
  overflow: visible;
  box-shadow: 0 0 20px rgba(255, 106, 0, .1);
}
</style>
