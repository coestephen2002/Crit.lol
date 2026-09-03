<template>
  <section class="lg:col-span-2">
    <div class="space-y-6 md:space-y-8">
      <!-- Match card -->
      <article
        v-for="m in matches"
        :key="m.match_id"
        class="rounded-2xl border shadow-md p-3 md:p-4 transition-all duration-300 backdrop-blur-md"
        :class="matchCardClass(m)"
      >
        <!-- Summary Row -->
        <button
          class="w-full px-4 py-3 text-left focus:outline-none group"
          :aria-expanded="isOpen(m.match_id)"
          :aria-controls="`match-${m.match_id}`"
          @click="toggle(m.match_id)"
          @keydown.enter.prevent="toggle(m.match_id)"
          @keydown.space.prevent="toggle(m.match_id)"
        >
          <div class="flex items-center justify-between w-full gap-4">
            <!-- Champion & Game info -->
            <div class="flex items-center gap-4">
              <div class="h-12 w-12 shrink-0 rounded-xl ring-2 ring-amber-500/30 bg-black/30 overflow-hidden shadow-inner">
                <img :src="champIcon(m)" alt="" class="h-full w-full object-contain" />
              </div>
              <div>
                <div class="text-base font-semibold tracking-wide text-white">
                  {{ m.queue_type }}
                </div>
                <div class="text-xs text-slate-300">
                  {{ humanWhen(m.game_creation) }} • {{ duration(m.game_duration) }}
                </div>
              </div>
            </div>

            <!-- Victory/Defeat + Dropdown arrow -->
            <div class="flex items-center gap-12">
              <div
                class="text-xl font-bold tracking-wide select-none"
                :class="isWin(m)
                ? 'text-amber-400 drop-shadow-[0_0_6px_rgba(245,158,11,0.7)]'
                : 'text-red-500 drop-shadow-[0_0_6px_rgba(239,68,68,0.7)]'"
              >
                {{ isWin(m) ? 'Victory' : 'Defeat' }}
              </div>

              <button
                class="h-7 w-7 flex items-center justify-center rounded-md bg-black/30 ring-1 ring-slate-600 text-slate-300 hover:text-amber-400 transition-colors"
                aria-hidden="true"
                @click.stop="toggle(m.match_id)"
              >
                <svg
                  :class="['h-4 w-4 transition-transform duration-300', isOpen(m.match_id) ? 'rotate-180' : 'rotate-0']"
                  viewBox="0 0 20 20"
                  fill="currentColor"
                >
                  <path d="M5.23 7.21a.75.75 0 011.06.02L10 10.94l3.71-3.71a.75.75 0 011.08 1.04l-4.25 4.25a.75.75 0 01-1.08 0L5.21 8.27a.75.75 0 01.02-1.06z" />
                </svg>
              </button>
            </div>
          </div>
        </button>

        <!-- Details -->
        <div
          :id="`match-${m.match_id}`"
          v-show="isOpen(m.match_id)"
          class="px-4 pb-5 text-white animate-fadeIn"
        >
          <div class="mt-4 grid grid-cols-1 gap-y-12">
            <!-- My team -->
            <MatchTeamTable
              :label="labelLeft(m)"
              :players="myTeamOf(m)"
              :isVictory="isWin(m)"
            />
            <!-- Enemy team -->
            <MatchTeamTable
              :label="labelRight(m)"
              :players="enemyTeamOf(m)"
              :isVictory="!isWin(m)"
            />
          </div>
        </div>
      </article>

      <!-- Empty state -->
      <div
        v-if="!matches.length"
        class="rounded-2xl border border-slate-700 bg-black/40 shadow-inner p-8 text-center text-slate-400"
      >
        No recent matches.
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref } from 'vue'
import { kda, duration, humanWhen, formatGold, sortByPosition } from '@/summonerUtils'
import MatchTeamTable from '@/components/modules/summoner/MatchTeamTable.vue'

const ICON_URL = 'https://ddragon.leagueoflegends.com/cdn/15.16.1/img/champion/'

// Props
const props = defineProps({
  matches: { type: Array, default: () => [] },
  summoner: { type: Object, default: () => ({}), required: true }
})

// --- Helpers ---
const myPerf = (m) => {
  const name = (props.summoner.name || '').toLowerCase()
  const tag = (props.summoner.tag || '').toLowerCase()
  return (m.match_participants || []).find(
    x => (x.summoner_name || '').toLowerCase() === name && (x.summoner_tag || '').toLowerCase() === tag
  ) || (m.match_participants ? m.match_participants[0] : null)
}

const isWin = (m) => !!(myPerf(m)?.win)
const my = (m, key, fb) => myPerf(m)?.[key] ?? fb
const roleOf = (m) => my(m, 'role', my(m, 'lane', ''))
const champIcon = (m) => `${ICON_URL}${my(m, 'champion_name', '')}.png`

const labelLeft = (m) => (isWin(m) ? 'Victory' : 'Defeat')
const labelRight = (m) => (isWin(m) ? 'Defeat' : 'Victory')

const myTeamOf = (m) => sortByPosition((m.match_participants || []).filter(p => !!p.win === !!myPerf(m)?.win))
const enemyTeamOf = (m) => sortByPosition((m.match_participants || []).filter(p => !!p.win !== !!myPerf(m)?.win))

// Open state
const open = ref(new Set())
const isOpen = (id) => open.value.has(id)
const toggle = (id) => {
  const next = new Set(open.value)
  next.has(id) ? next.delete(id) : next.add(id)
  open.value = next
}

// Dynamic card class
const matchCardClass = (m) =>
  isWin(m)
    ? 'border-amber-400/80 bg-gradient-to-br from-amber-900/40 via-orange-900/30 to-amber-800/40 hover:shadow-[0_0_25px_rgba(245,158,11,0.35)]'
    : 'border-red-900/70 bg-gradient-to-br from-zinc-900/60 via-neutral-900/50 to-red-950/60 hover:shadow-[0_0_20px_rgba(239,68,68,0.25)]'
</script>

<style lang="scss" scoped>
.animate-fadeIn {
  animation: fadeIn 0.25s ease-in-out;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(-4px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* Ember badge style */
.badge-ember {
  @apply rounded-full px-3 py-1 text-xs font-semibold text-white
  bg-gradient-to-r from-orange-700/80 via-amber-600/80 to-orange-800/80
  shadow-md backdrop-blur-sm;
}
</style>
