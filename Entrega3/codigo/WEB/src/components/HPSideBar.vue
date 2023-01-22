<template>
  <div class="shadow-xl rounded-2xl bg-white dark:bg-black py-3 px-8 h-full w-full">
    <div class="flex flex-col space-y-6 h-full">
      <HPSideBarDesporto />
      <HPSideBarCompetitions />
    </div>
  </div>
</template>

<script setup lang="ts">
import HPSideBarCompetitions from "./HPSideBarCompetitions.vue";
import HPSideBarDesporto from "./HPSideBarDesporto.vue";
</script>
