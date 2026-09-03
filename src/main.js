import './assets/main.scss'
import api from '@/api.js'

import { createApp } from 'vue'
import { createPinia } from 'pinia'

// Import your icon setup
import './plugins/fontawesome'
import Icon from './components/ui/Icon.vue'
import App from './App.vue'
import router from './router'

const app = createApp(App)

app.config.globalProperties.$api = api

app.use(createPinia())
app.use(router)
app.component('Icon', Icon)
app.mount('#app')
