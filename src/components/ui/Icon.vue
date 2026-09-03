<template>
  <FontAwesomeIcon :icon="icon" :class="customClass" />
</template>

<script setup>
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'

defineProps({
  icon: {
    type: [String, Array],
    required: true,
  },
  customClass: {
    type: String,
    default: '',
  },
})
</script>
