<template>
  <div class="overflow-x-auto rounded-2xl border border-white/10 shadow-inner bg-black/40">
    <table class="w-full text-sm table-auto">
      <colgroup>
        <col style="width:40%" />
        <col style="width:14%" />
        <col style="width:14%" />
        <col style="width:12%" />
        <col style="width:8%" />
        <col style="width:12%" />
      </colgroup>

      <!-- Header -->
      <thead>
      <tr
        :class="[
            'text-white text-lg font-bold tracking-wide uppercase',
            isVictory
              ? 'bg-gradient-to-r from-orange-700/80 via-amber-600/70 to-orange-800/70 text-amber-200'
              : 'bg-gradient-to-r from-neutral-900/80 to-red-900/70 text-red-300'
          ]"
      >
        <th colspan="6" class="px-4 py-3 text-left">{{ label }}</th>
      </tr>
      <tr class="text-white/70 text-xs border-b border-white/10">
        <th class="px-4 py-2 text-left">Player</th>
        <th class="px-2 py-2">K/D/A</th>
        <th class="px-2 py-2">Damage</th>
        <th class="px-2 py-2">Gold</th>
        <th class="px-2 py-2">CS</th>
        <th class="px-2 py-2">Vision</th>
      </tr>
      </thead>

      <!-- Body -->
      <tbody>
      <tr
        v-for="(p, i) in players"
        :key="i"
        class="border-b border-white/5 hover:bg-white/5 transition-colors"
      >
        <!-- Player -->
        <td class="px-4 py-2">
          <div class="flex items-center gap-3">
            <div class="relative">
              <img
                :src="`${ICON_URL}${p.champion_name}.png`"
                class="h-10 w-10 rounded-md shadow-inner"
              />
              <span
                v-if="p?.champion_level != null"
                class="absolute -bottom-1 -left-1 px-1.5 py-0.5 text-[11px] font-bold bg-black/80 text-white rounded"
              >
                  {{ p.champion_level }}
                </span>
            </div>
            <RouterLink
              :to="summonerLink(p)"
              class="truncate text-base font-semibold max-w-[150px] md:max-w-[200px]
                     !text-amber-600 hover:!text-amber-500 transition no-underline"
            >
              {{ p.summoner_name }}
            </RouterLink>
          </div>
        </td>

        <!-- KDA -->
        <td class="px-2 py-2 text-left">
          <div
            :class="[
              'font-bold',
              kdaColor(p.kills, p.deaths, p.assists)
            ]"
          >
            {{ p.kills }}/{{ p.deaths }}/{{ p.assists }}
          </div>
          <div class="text-xs text-slate-400">{{ kda(p.kills, p.deaths, p.assists) }}</div>
        </td>

        <!-- Damage -->
        <td class="px-2 py-2 relative">
          <div class="w-full h-2 rounded bg-white/10 overflow-hidden">
            <div
              class="h-2 rounded bg-gradient-to-r from-orange-600/70 via-amber-500/70 to-orange-700/70"
              :style="{ width: `${((p.damage_to_champions / teamDamageTotal) * 100).toFixed(1)}%` }"
            ></div>
          </div>
          <span class="text-xs text-white/80 mt-1 block">{{ formatDmg(p.damage_to_champions) }}</span>
        </td>

        <!-- Gold -->
        <td class="px-2 py-2 text-white/80">{{ formatGold(p.gold_earned) }}</td>
        <!-- CS -->
        <td class="px-2 py-2 text-white/80">{{ p.creep_score }}</td>
        <!-- Vision -->
        <td class="px-2 py-2 text-white/80">{{ p.vision_score }}</td>
      </tr>
      </tbody>
    </table>
  </div>
</template>

<script setup>
import { kda, formatGold, formatDmg } from '@/summonerUtils'
import { computed } from 'vue'
import { RouterLink } from 'vue-router'

const ICON_URL = 'https://ddragon.leagueoflegends.com/cdn/15.16.1/img/champion/'

const props = defineProps({
  label: String,
  players: Array,
  isVictory: Boolean
})

const summonerLink = (player) => {
  const region = player?.region || 'na1'
  const name = encodeURIComponent(player.summoner_name)
  const tag = encodeURIComponent(player.summoner_tag)
  return `/summoners/${region}/${name}-${tag}`
}

// Compute max damage dynamically for the damage bar
const maxDamage = computed(() =>
  Math.max(...(props.players?.map(p => p.damage_to_champions) || [1]))
)

const kdaRatio = (kills, deaths, assists) => {
  return deaths === 0 ? kills + assists : (kills + assists) / deaths
}

const kdaColor = (kills, deaths, assists) => {
  const ratio = kdaRatio(kills, deaths, assists)

  if (deaths === 0 && kills + assists >= 10) return 'text-emerald-400'
  if (ratio >= 3.5 || (kills + assists >= deaths * 3)) return 'text-emerald-400'
  if (ratio >= 2.5) return 'text-amber-300'
  if (ratio >= 1.5) return 'text-yellow-300'
  return 'text-red-400'
}
const teamDamageTotal = computed(() => {
  return props.players.reduce((sum, p) => sum + p.damage_to_champions, 0)
})

</script>

<style lang="scss" scoped>
/* Hover and subtle glow */
tbody tr:hover {
  box-shadow: 0 0 15px rgba(245, 158, 11, 0.15);
  transition: all 0.2s ease-in-out;
}

/* Ember gradient damage bar */
td .bg-gradient-to-r {
  transition: width 0.3s ease;
}
</style>
