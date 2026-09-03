<template>
  <header class="rounded-2xl glow-border p-4 text-white">
    <div class="flex flex-wrap items-center gap-4">
      <div class="relative inline-block">
        <img
          v-if="summoner?.profile_icon_id"
          :src="`https://ddragon.leagueoflegends.com/cdn/15.16.1/img/profileicon/${summoner?.profile_icon_id}.png`"
          alt="icon"
          class="h-16 w-16 rounded-2xl ring-1 ring-slate-200/30"
        />
        <span
          v-if="summoner?.summoner_level != null"
          class="absolute -bottom-1 -left-1 px-1.5 py-0.5 text-[14px] font-bold leading-none bg-black/70 text-white"
        >
          {{ summoner?.summoner_level }}
        </span>
      </div>
      <div class="min-w-0">
        <div class="items-center gap-2 text-xl font-bold tracking-tight">
          <span class="truncate text-4xl">{{ summoner?.name }}</span>
          <span class="truncate text-3xl text-white/70"> #{{ summoner?.tag }}</span>
        </div>
        <div class="my-2 flex flex-wrap items-center gap-2 text-sm">
          <span
            class="inline-flex items-center rounded-full px-2.5 py-1 text-xs font-medium bg-white/10 text-white ring-1 ring-inset ring-white/15"
          >
            {{ (summoner?.region || '').toUpperCase() }}
          </span>
          <span
            v-if="summoner.name === 'Ginjyyy' && summoner.tag === 'WHITE'"
            class="inline-flex items-center rounded-full px-2.5 py-1 text-xs font-medium bg-white/10 text-white ring-1 ring-inset ring-white/15"
          >
            Gigachad
          </span>
          <span
            v-if="summoner.name === 'Ginjyyy' && summoner.tag === 'WHITE'"
            class="inline-flex items-center rounded-full px-2.5 py-1 text-xs font-medium bg-white/10 text-white ring-1 ring-inset ring-white/15"
          >
            WHITE DRAGON
          </span>
        </div>
      </div>
    </div>
  </header>
</template>

<script setup>
defineProps({
  summoner: {
    type: Object,
    default: () => ({}),
  },
})
</script>

<script>
export default { name: 'SummonerHeaderModule' }
</script>

<style scoped>
.glow-border {
  border: 2px solid #b1561580;
  border-radius: 12px;
  overflow: visible;
  box-shadow: 0 0 20px rgba(255, 106, 0, .1);
}
</style>
