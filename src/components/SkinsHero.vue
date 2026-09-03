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
          <div class="skin-viewer flex-1 flex flex-col items-center mt-4 w-full">

            <!-- Skin Selector -->
            <select
              v-model="selectedSkin"
              @change="loadSkinModel"
              class="mb-4 p-2 rounded w-full bg-[#1a1a1a] text-white focus:outline-none focus:ring-2 focus:ring-amber-500">
              <option v-for="skin in skins" :key="skin.name" :value="skin.glbUrl">
                {{ skin.name }}
              </option>
            </select>

            <!-- Animation Controls -->
            <div class="animation-controls flex items-center gap-2 mb-4 w-full">
              <button
                @click="prevAnimation"
                class="flex-1 py-2 rounded bg-amber-500 text-black font-semibold hover:bg-amber-600 transition">
                Prev
              </button>

              <select
                v-model="selectedAnimation"
                @change="playAnimation"
                class="flex-[2] p-2 rounded bg-[#1a1a1a] text-white font-medium w-full focus:outline-none focus:ring-2 focus:ring-amber-500">
                <option v-for="anim in animations" :key="anim.name" :value="anim.name">
                  {{ anim.name }}
                </option>
              </select>

              <button
                @click="nextAnimation"
                class="flex-1 py-2 rounded bg-amber-500 text-black font-semibold hover:bg-amber-600 transition">
                Next
              </button>
            </div>

            <!-- Three.js Canvas -->
            <Spinner v-if="canvasLoading"/>
            <div
              v-else
              ref="threeCanvas"
              class="w-full flex-1 border-2 border-amber-500/50 rounded-xl">
            </div>

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
import { ref, computed, nextTick, onMounted, watch } from 'vue'
import { useChampionStore } from '@/stores/champion'
import { SearchIcon } from 'lucide-vue-next'
import Spinner from '@/components/ui/Spinner.vue'
import * as THREE from 'three'
import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader.js'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls.js'

// Constants
const tags = ['Assassin', 'Fighter', 'Mage', 'Marksman', 'Support', 'Tank']

// Stores and refs
const championStore = useChampionStore()
const champions = ref([])
const selectedChampion = ref(null)
const search = ref('')
const leftGrid = ref(null)
const champGrid = ref(null)
const loading = ref(false)
const selectedTags = ref([])
const skins = ref([]) // [{ name, glbUrl }]
const selectedSkin = ref(null)
const threeCanvas = ref(null)
const canvasLoading = ref(false)

// Animation handling
const animations = ref([]) // Array of { name, clip }
const selectedAnimation = ref(null)

// Three.js variables
let scene, camera, renderer, loader, currentModel, controls, mixer
const clock = new THREE.Clock()

// Filter champions
const filteredChamps = computed(() =>
  champions.value.map(champ => {
    const matchesSearch = champ.name.toLowerCase().includes(search.value.toLowerCase())
    const matchesTags =
      selectedTags.value.length === 0 ||
      selectedTags.value.every(tag => champ.tags.includes(tag))
    return { ...champ, matches: matchesSearch && matchesTags }
  })
)

// Toggle tag filters
const toggleTag = tag => {
  selectedTags.value.includes(tag)
    ? selectedTags.value = selectedTags.value.filter(t => t !== tag)
    : selectedTags.value.push(tag)
}

// Scroll to first match
const scrollToFirstMatch = () => {
  nextTick(() => {
    const firstMatch = champGrid.value.querySelector('.champion-card.border-amber-500')
    if (firstMatch) firstMatch.scrollIntoView({ behavior: 'smooth', block: 'center' })
  })
}

// Initialize Three.js
const initThree = () => {
  canvasLoading.value = true
  if (!threeCanvas.value) return

  scene = new THREE.Scene()
  camera = new THREE.PerspectiveCamera(45, threeCanvas.value.clientWidth / threeCanvas.value.clientHeight, 0.1, 1000)
  camera.position.set(0, 1, 3)

  renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true })
  renderer.setSize(threeCanvas.value.clientWidth, threeCanvas.value.clientHeight)
  threeCanvas.value.appendChild(renderer.domElement)

  // Light
  const light = new THREE.DirectionalLight(0xffffff, 1)
  light.position.set(0, 5, 5)
  scene.add(light)
  scene.add(new THREE.AmbientLight(0xffffff, 0.5))

  // Orbit controls
  controls = new OrbitControls(camera, renderer.domElement)
  controls.enableDamping = true
  controls.dampingFactor = 0.05

  // Loader
  loader = new GLTFLoader()
  canvasLoading.value = false
  animate()
}

// Load GLB
const loadSkinModel = () => {
  if (!selectedSkin.value || !loader) return
  canvasLoading.value = true
  if (currentModel) {
    scene.remove(currentModel)
    currentModel.traverse(child => {
      if (child.geometry) child.geometry.dispose()
      if (child.material) child.material.dispose()
    })
    currentModel = null
    mixer = null
    animations.value = []
    selectedAnimation.value = null
  }

  loader.load(
    selectedSkin.value,
    gltf => {
      console.log(gltf)
      currentModel = gltf.scene
      scene.add(currentModel)

      const box = new THREE.Box3().setFromObject(currentModel);
      const center = box.getCenter(new THREE.Vector3());
      const size = box.getSize(new THREE.Vector3());
      currentModel.position.x -= center.x;
      currentModel.position.y -= center.y; // use center.y, not box.min.y
      currentModel.position.z -= center.z;

      // Camera distance & position
      const maxDim = Math.max(size.x, size.y, size.z);
      const fov = camera.fov * (Math.PI / 180);
      const cameraZ = Math.abs(maxDim / 2 / Math.tan(fov / 2));
      camera.position.set(0, 0, cameraZ * 0.45); // view from slightly closer
      camera.lookAt(0, 0, 0);
      camera.near = cameraZ / 100;
      camera.far = cameraZ * 10;
      camera.updateProjectionMatrix();

      // OrbitControls target at center
      controls.target.set(0, -50, 0);
      controls.maxDistance = cameraZ * 3;
      controls.minDistance = cameraZ * 0.2;
      controls.update();

      // Setup animations
      if (gltf.animations.length) {
        mixer = new THREE.AnimationMixer(currentModel)
        animations.value = gltf.animations.map(a => ({ name: a.name, clip: a }))
        // pick first animation with "idle" in name
        const idleAnim = animations.value.find(a => /idle/i.test(a.name)) || animations.value[0]
        selectedAnimation.value = idleAnim.name
        const action = mixer.clipAction(idleAnim.clip)
        action.play()
      }
    },
    undefined,
    err => console.error('Failed to load GLB:', err)
  )
  canvasLoading.value = false
}

// Play selected animation
const playAnimation = () => {
  if (!mixer || !currentModel || !selectedAnimation.value) return
  const anim = animations.value.find(a => a.name === selectedAnimation.value)
  if (!anim) return
  mixer.stopAllAction()
  const action = mixer.clipAction(anim.clip)
  action.reset().play()
}

// Animate scene
const animate = () => {
  requestAnimationFrame(animate)
  const delta = clock.getDelta()
  if (mixer) mixer.update(delta)
  if (currentModel) currentModel.rotation.y += 0.001
  if (controls) controls.update()
  renderer.render(scene, camera)
}

// Select champion
const selectChampion = champ => {
  selectedChampion.value = champ
  skins.value = [{ name: 'Quantum Galaxy Slayer Zed', glbUrl: '/models/quantum_galaxy_slayer_zed.glb' }]
  selectedSkin.value = skins.value[0].glbUrl

  nextTick(() => {
    if (!renderer) initThree()
    loadSkinModel()
  })
}

const nextAnimation = () => {
  if (!animations.value.length) return
  const currentIndex = animations.value.findIndex(a => a.name === selectedAnimation.value)
  const nextIndex = (currentIndex + 1) % animations.value.length
  selectedAnimation.value = animations.value[nextIndex].name
}

const prevAnimation = () => {
  if (!animations.value.length) return
  const currentIndex = animations.value.findIndex(a => a.name === selectedAnimation.value)
  const prevIndex = (currentIndex - 1 + animations.value.length) % animations.value.length
  selectedAnimation.value = animations.value[prevIndex].name
}

// Load champions
onMounted(async () => {
  if (!championStore.champions.length) {
    loading.value = true
    await championStore.fetchChampions()
  }
  champions.value = championStore.champions
  loading.value = false
})

// Watch skin change
watch(selectedSkin, () => {
  loadSkinModel()
})

// Watch animation change
watch(selectedAnimation, () => {
  playAnimation()
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

.skin-viewer select {
  background-color: #1a1a1a;
  color: white;
  border: 1px solid #ff6a00;
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
