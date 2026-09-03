import { createRouter, createWebHistory } from 'vue-router'
import LandingView from '@/views/LandingView.vue'
import SummonerView from '@/views/SummonerView.vue'

import ChampionsView from '@/views/ChampionsView.vue'
import SkinsView from '@/views/SkinsView.vue'
const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    { path: '/', name: 'landing', component: LandingView },
    { path: '/summoners/:region/:slug', name: 'summoner', component: SummonerView },
    { path: '/champions', name: 'champions', component: ChampionsView},
    { path: '/skins', name: 'skins', component: SkinsView},
  ],
})

export default router
